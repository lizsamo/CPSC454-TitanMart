const express = require('express');
const router = express.Router();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { v4: uuidv4 } = require('uuid');
const { DynamoDBClient } = require('@aws-sdk/client-dynamodb');
const { DynamoDBDocumentClient, PutCommand, GetCommand, UpdateCommand, QueryCommand, ScanCommand } = require('@aws-sdk/lib-dynamodb');
const { sendVerificationEmail } = require('../utils/email');

const client = new DynamoDBClient({ region: process.env.AWS_REGION });
const docClient = DynamoDBDocumentClient.from(client);

// Register new user
router.post('/register', async (req, res) => {
  try {
    const { email, password, csufEmail, fullName } = req.body;

    // Validate CSUF email
    if (!csufEmail.toLowerCase().endsWith('@csu.fullerton.edu')) {
      return res.status(400).json({
        message: 'Must use a valid CSUF email address (@csu.fullerton.edu)'
      });
    }

    // Check if user already exists
    const existingUser = await docClient.send(new ScanCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      FilterExpression: 'email = :email',
      ExpressionAttributeValues: {
        ':email': email
      }
    }));

    if (existingUser.Items && existingUser.Items.length > 0) {
      return res.status(400).json({ message: 'User already exists' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Create verification code
    const verificationCode = Math.floor(100000 + Math.random() * 900000).toString();

    // Create user
    const user = {
      userId: uuidv4(),
      email,
      password: hashedPassword,
      csufEmail,
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
    await sendVerificationEmail(csufEmail, verificationCode);

    // Remove sensitive data
    delete user.password;
    delete user.verificationCode;

    res.status(201).json(user);
  } catch (error) {
    console.error('Registration error:', error);
    res.status(500).json({ message: 'Server error during registration' });
  }
});

// Login
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Find user
    const result = await docClient.send(new ScanCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      FilterExpression: 'email = :email',
      ExpressionAttributeValues: {
        ':email': email
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

    // Generate JWT
    const token = jwt.sign(
      { userId: user.userId, email: user.email },
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
    const { code, userId } = req.body;

    // Get user by primary key
    const result = await docClient.send(new GetCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      Key: { userId: userId }
    }));

    if (!result.Item) {
      return res.status(404).json({ message: 'User not found' });
    }

    const user = result.Item;

    if (user.verificationCode !== code) {
      return res.status(400).json({ message: 'Invalid verification code' });
    }

    // Update user
    await docClient.send(new UpdateCommand({
      TableName: process.env.DYNAMODB_USERS_TABLE,
      Key: { userId: userId },
      UpdateExpression: 'SET isEmailVerified = :verified',
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
