# TitanMart - CSUF Student Marketplace

A secure consumer-to-consumer marketplace application exclusively for CSUF students, enabling them to safely sell and purchase items directly from one another within a trusted campus community.

## Project Overview

**Course**: CPSC 454 - Cloud Security
**Goal**: Build a secure e-commerce mobile app with cloud infrastructure and security controls

## Features

- **User Authentication**: CSUF email verification (@csu.fullerton.edu)
- **Product Browsing**: Search and filter products by category
- **Shopping Cart**: Add multiple items and manage quantities
- **Secure Checkout**: Stripe payment processing with escrow
- **Rating System**: User ratings and reviews for accountability
- **Cloud Security**: AWS-based infrastructure with IAM, WAF, and security monitoring

## Tech Stack

### iOS App (Frontend)
- Swift 5.9
- SwiftUI
- Xcode 15+
- iOS 17+

### Backend
- Node.js 18.x
- Express.js
- AWS Lambda (Serverless)
- API Gateway
- DynamoDB
- S3 for image storage
- Stripe for payments

### Cloud Security
- AWS IAM policies
- AWS WAF for application firewall
- CloudWatch for monitoring
- Encryption at rest and in transit

## Project Structure

```
CPSC454-TitanMart/
├── TitanMart/                    # iOS App
│   ├── Models/                   # Data models
│   ├── Views/                    # SwiftUI views
│   │   ├── Auth/                 # Login, signup
│   │   ├── Products/             # Product list, detail
│   │   ├── Cart/                 # Shopping cart, checkout
│   │   └── Profile/              # User profile, orders
│   ├── ViewModels/               # Business logic
│   ├── Services/                 # API, Auth, Cart services
│   └── Utilities/                # Helper functions
├── backend/                      # Node.js API
│   ├── routes/                   # API endpoints
│   ├── middleware/               # Auth middleware
│   ├── utils/                    # Email, helpers
│   ├── server.js                 # Express app
│   ├── serverless.yml            # AWS deployment config
│   └── package.json
└── README.md
```

## Getting Started

### Prerequisites
- macOS with Xcode 15+
- Node.js 18+ and npm
- AWS Account
- Stripe Account
- iOS device or simulator

### iOS App Setup

1. Open the Xcode project:
```bash
cd TitanMart
open TitanMart.xcodeproj
```

2. Build and run the app in Xcode (Cmd + R)

### Backend Setup

1. Install dependencies:
```bash
cd backend
npm install
```

2. Configure environment:
```bash
cp .env.example .env
# Edit .env with your credentials
```

3. Run locally:
```bash
npm run dev
```

4. Deploy to AWS:
```bash
npm install -g serverless
serverless deploy
```

## Development Workflow

### Current Status

The iOS app is fully functional with:
- User authentication (Login/Signup with CSUF email)
- Product browsing and search
- Shopping cart
- Checkout flow
- User profiles and orders
- Mock data for testing

The backend includes:
- RESTful API structure
- Authentication endpoints
- Product, order, and review endpoints
- Stripe payment integration
- AWS deployment configuration

### Next Steps

1. **Deploy Backend**: Set up AWS infrastructure
2. **Connect iOS to Backend**: Update API endpoint in iOS app
3. **Implement Reviews**: Complete rating/review UI
4. **Add Image Upload**: Implement S3 image upload for products
5. **Security Hardening**: Implement WAF rules and security monitoring
6. **Testing**: End-to-end testing with real data

## Security Features

### Authentication
- JWT-based authentication
- CSUF email verification required
- Secure password hashing with bcrypt

### Payment Security
- Stripe integration with escrow-style payments
- PCI compliance through Stripe
- Payment held until buyer confirms receipt

### Cloud Security
- IAM roles with least privilege
- DynamoDB encryption at rest
- API Gateway with request validation
- CloudWatch monitoring and alerts
- WAF rules for common threats

### Data Protection
- All API calls over HTTPS
- Input validation and sanitization
- SQL injection prevention (NoSQL)
- XSS protection

## API Endpoints

### Authentication
- `POST /api/auth/register` - Register new user
- `POST /api/auth/login` - Login
- `POST /api/auth/verify-email` - Verify CSUF email

### Products
- `GET /api/products` - Get all products
- `GET /api/products/:id` - Get single product
- `POST /api/products` - Create product (auth required)

### Orders
- `POST /api/orders` - Create order (auth required)
- `GET /api/orders/user/:userId` - Get user orders (auth required)

### Reviews
- `POST /api/reviews` - Create review (auth required)
- `GET /api/reviews/user/:userId` - Get user reviews

### Payment
- `POST /api/payment/create-intent` - Create payment intent
- `POST /api/payment/webhook` - Stripe webhook

## Testing

### iOS App
Run tests in Xcode:
```bash
Cmd + U
```

### Backend
```bash
npm test
```

### API Testing
Use the included Postman collection or curl:
```bash
curl http://localhost:3000/health
```

## Deployment

### iOS App
1. Configure signing in Xcode
2. Archive the app (Product > Archive)
3. Distribute to TestFlight or App Store

### Backend
```bash
serverless deploy --stage prod
```

## License

MIT License - This is an educational project.

## Team

- Elizsa Montoya
- Denise Munoz-Martinez
- Dylan Dao
- Joshua Andrada
- Miguel Perez

## Acknowledgments

- California State University, Fullerton
- CPSC 454 - Cloud Security with Dr. Yun Tian
- AWS Education
- Stripe for payment processing

## Resources

- [iOS Development Documentation](https://developer.apple.com/documentation/)
- [AWS Documentation](https://docs.aws.amazon.com/)
- [Stripe API Reference](https://stripe.com/docs/api)
- [SwiftUI Tutorials](https://developer.apple.com/tutorials/swiftui)
