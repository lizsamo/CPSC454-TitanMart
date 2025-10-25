const { SESClient, SendEmailCommand } = require('@aws-sdk/client-ses');

const sesClient = new SESClient({ region: process.env.AWS_REGION || 'us-east-2' });

async function sendVerificationEmail(email, code) {
  try {
    const params = {
      Source: 'lizsamon@csu.fullerton.edu', // Must be a verified email in SES
      Destination: {
        ToAddresses: [email]
      },
      Message: {
        Subject: {
          Data: 'Verify your TitanMart account',
          Charset: 'UTF-8'
        },
        Body: {
          Html: {
            Data: `
              <h1>Welcome to TitanMart!</h1>
              <p>Your verification code is: <strong>${code}</strong></p>
              <p>Please enter this code in the app to verify your CSUF email.</p>
              <p>If you didn't create this account, please ignore this email.</p>
            `,
            Charset: 'UTF-8'
          }
        }
      }
    };

    const command = new SendEmailCommand(params);
    await sesClient.send(command);
    console.log('Verification email sent to:', email);
  } catch (error) {
    console.error('Error sending email:', error);
    // Don't throw - let registration continue even if email fails
  }
}

module.exports = { sendVerificationEmail };
