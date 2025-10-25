const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, QueryCommand } = require('@aws-sdk/lib-dynamodb');
const { sendVerificationEmail } = require('../utils/email');

const client = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(client);

// Register new user
router.post('/register', async (req, res) => {
  try {
    const { username, password, csufEmail, fullName } = req.body;

    // Validate required fields
    if (!username || !password || !csufEmail || !fullName) {
      return res.status(400).json({
        message: 'All fields are required: username, password, csufEmail, fullName'
      });
    }

    // Validate CSUF email
    if (!csufEmail.toLowerCase().endsWith('@csu.fullerton.edu')) {
      return res.status(400).json({
        message: 'Must use a valid CSUF email address (@csu.fullerton.edu)'
      });
    }

    // Validate username (alphanumeric, underscore, hyphen only, 3-20 chars)
    if (!/^[a-zA-Z0-9_-]{3,20}$/.test(username)) {
      return res.status(400).json({
        message: 'Username must be 3-20 characters (letters, numbers, underscore, hyphen only)'
      });
    }

    // Check if CSUF email already exists
    const existingByEmail = await docClient.send(new GetCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      Key: { csufEmail: csufEmail.toLowerCase() }
    }));

    if (existingByEmail.Item) {
      return res.status(400).json({ message: 'CSUF email already registered' });
    }

    // Check if username already exists
    const existingByUsername = await docClient.send(new QueryCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      IndexName: 'UsernameIndex',
      KeyConditionExpression: 'username = :username',
      ExpressionAttributeValues: {
        ':username': username.toLowerCase()
      }
    }));

    if (existingByUsername.Items && existingByUsername.Items.length > 0) {
      return res.status(400).json({ message: 'Username already taken' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create verification code
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();

    // Create user (csufEmail is the partition key)
    const user = {
      csufEmail: csufEmail.toLowerCase(),
      username: username.toLowerCase(),
      password: hashedPassword,
      fullName,
      isEmailVerified: false,
      verificationCode,
      rating: 0,
      totalRatings: 0,
      createdAt: new Date().toISOString()
    };

    await docClient.send(new PutCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      Item: user
    }));

    // Send verification email
    try {
      await sendVerificationEmail(csufEmail, verificationCode);
    } catch (emailError) {
      console.error('Email sending failed:', emailError);
      // Continue registration even if email fails
    }

    // Remove sensitive data
    delete user.password;
    delete user.verificationCode;

    res.status(201).json(user);
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: 'Server error during registration' });
  }
});

// Login with username
router.post('/login', async (req, res) => {
  try {
    const { username, password } = req.body;

    if (!username || !password) {
      return res.status(400).json({ message: 'Username and password required' });
    }

    // Find user by username using GSI
    const result = await docClient.send(new QueryCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      IndexName: 'UsernameIndex',
      KeyConditionExpression: 'username = :username',
      ExpressionAttributeValues: {
        ':username': username.toLowerCase()
      }
    }));

    if (!result.Items || result.Items.length === 0) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    const user = result.Items[0];

    // Check password
    const isValidPassword = await bcrypt.compare(password, user.password);
    if (!isValidPassword) {
      return res.status(401).json({ message: 'Invalid credentials' });
    }

    // Generate JWT (use csufEmail as identifier since it's the primary key)
    const token = jwt.sign(
      {
        csufEmail: user.csufEmail,
        username: user.username
      },
      process.env.JWT_SECRET,
      { expiresIn: process.env.JWT_EXPIRES_IN }
    );

    // Remove sensitive data
    delete user.password;
    delete user.verificationCode;

    res.json({ user, token });
  } catch (error) {
    console.error('Login error:', error);
    res.status(500).json({ message: 'Server error during login' });
  }
});

// Verify email
router.post('/verify-email', async (req, res) => {
  try {
    const { code, csufEmail } = req.body;

    if (!code || !csufEmail) {
      return res.status(400).json({ message: 'Code and csufEmail required' });
    }

    // Get user by csufEmail (partition key)
    const result = await docClient.send(new GetCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      Key: { csufEmail: csufEmail.toLowerCase() }
    }));

    if (!result.Item) {
      return res.status(404).json({ message: 'User not found' });
    }

    const user = result.Item;

    if (user.isEmailVerified) {
      return res.status(400).json({ message: 'Email already verified' });
    }

    if (user.verificationCode !== code) {
      return res.status(400).json({ message: 'Invalid verification code' });
    }

    // Update user
    await docClient.send(new UpdateCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      Key: { csufEmail: csufEmail.toLowerCase() },
      UpdateExpression: 'SET isEmailVerified = :verified REMOVE verificationCode',
      ExpressionAttributeValues: {
        ':verified': true
      }
    }));

    user.isEmailVerified = true;
    delete user.password;
    delete user.verificationCode;

    res.json(user);
  } catch (error) {
    console.error('Email verification error:', error);
    res.status(500).json({ message: 'Server error during verification' });
  }
});

module.exports = router;
