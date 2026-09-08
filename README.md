# VP Nexues Mobile

A complete mobile e-commerce solution for farm-fresh vegetables, fruits, beverages, and groceries.

## Project Structure

```
VPNexues Mobile/
├── frontend/           # Flutter mobile & web app
│   └── vpnexues/       # Flutter project root
│       ├── lib/        # Dart source code
│       ├── android/    # Android platform
│       ├── ios/        # iOS platform
│       ├── web/        # Web platform
│       ├── assets/     # Images, fonts, etc.
│       ├── test/       # Unit & widget tests
│       └── pubspec.yaml
│
├── backend/            # Java Spring Boot API
│   └── vpnexues-backend/
│       ├── src/        # Java source code
│       ├── pom.xml     # Maven config
│       └── render.yaml # Deployment config
│
└── README.md           # This file
```

## Frontend (Flutter)

**Location:** `frontend/vpnexues/`

### Features
- Splash screen with branding
- OTP login/signup (WhatsApp-style)
- Home with product listings, flash sales, banners
- Categories (Vegetables, Fruits, Beverages, Groceries)
- Product details with add-to-cart
- Cart with coupon support
- Checkout with Razorpay payment
- Order tracking with real-time status
- Push notifications (Firebase FCM)
- Multi-language (English, Tamil, Arabic)
- Multi-country (India, UAE, Singapore)

### Tech Stack
- Flutter SDK >=3.12.2
- Provider (state management)
- HTTP (API calls)
- Firebase Messaging
- Razorpay

### Setup
```bash
cd frontend/vpnexues
flutter pub get
flutter run
```

## Backend (Java Spring Boot)

**Location:** `backend/vpnexues-backend/`

### Features
- REST API for products, cart, orders, auth
- JWT authentication
- OTP via email
- Razorpay payment integration
- Firebase Cloud Messaging
- Multi-country configuration

### Setup
```bash
cd backend/vpnexues-backend
./mvnw spring-boot:run
```

### Deployment
- Configured for Render deployment
- See `render.yaml` for deployment config

## Getting Started

1. **Backend:** Start the Spring Boot server on port 8080
2. **Frontend:** Run the Flutter app pointing to the backend URL

```bash
# Run with custom API URL
flutter run --dart-define=API_BASE_URL=http://localhost:8080/api
```

## License

Private - VP Nexues
