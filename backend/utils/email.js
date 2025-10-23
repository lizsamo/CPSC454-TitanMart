const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  host: process.env.SMTP_HOST,
  port: process.env.SMTP_PORT,
  secure: false,
  auth: {
    user: process.env.SMTP_USER,
    pass: process.env.SMTP_PASSWORD
  }
});

async function sendVerificationEmail(email, code) {
  try {
    await transporter.sendMail({
      from: process.env.SMTP_USER,
      to: email,
      subject: 'Verify your TitanMart account',
      html: `
        <h1>Welcome to TitanMart!</h1>
        <p>Your verification code is: <strong>${code}</strong></p>
        <p>Please enter this code in the app to verify your CSUF email.</p>
        <p>If you didn't create this account, please ignore this email.</p>
      `
    });
    console.log('Verification email sent to:', email);
  } catch (error) {
    console.error('Error sending email:', error);
  }
}

module.exports = { sendVerificationEmail };
