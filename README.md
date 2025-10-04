 
MedHealth is a comprehensive mobile pharmacy and health product marketplace built with Flutter. The app provides users with a convenient platform to browse, search, and purchase medicines, vitamins, and health-related products from the comfort of their mobile devices.

## Features

- 🔐 **User Authentication** - Secure login and registration system
- 🏠 **Home & Discovery** - Category-based product browsing with visual interface
- 🔍 **Product Search** - Find specific medicines and health products
- 🛒 **Shopping Cart** - Add products, manage quantities, and checkout
- 📱 **Modern UI** - Clean, responsive design optimized for mobile
- 💊 **Product Management** - Detailed product pages with descriptions and pricing
- 👤 **Profile Management** - User profiles and order history


## Getting Started

### Prerequisites

- Flutter SDK (3.5.3 or higher)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Kassem-Jomaa/medHealth.git
   cd medHealth
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API endpoints**
   - Open `lib/api/config.dart`
   - Replace `YOUR_SERVER_IP_HERE` with your actual server IP address
   - Update the base path according to your server configuration

4. **Run the app**
   ```bash
   flutter run
   ```

### API Configuration

The app requires a backend API to function properly. Make sure you have:

- PHP backend with MySQL database
- API endpoints for authentication, products, and cart management
- Proper CORS configuration for mobile app access

### Project Structure

```
lib/
├── api/           # API configuration and endpoints
├── model/         # Data models
├── pages/         # App screens
├── widgets/       # Reusable UI components
├── theme.dart     # App theming
└── main.dart      # App entry point
```

## Dependencies

- `flutter` - Flutter SDK
- `http` - HTTP client for API calls
- `shared_preferences` - Local data storage
- `intl` - Internationalization and formatting
- `google_fonts` - Custom fonts
- `cached_network_image` - Image caching

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- **Developer**: Kassem Jomaa
- **Repository**: [https://github.com/Kassem-Jomaa/medHealth](https://github.com/Kassem-Jomaa/medHealth)

## Acknowledgments

- Flutter team for the amazing framework


![c439099b-aff0-4074-b904-e775e5b758c7](https://github.com/user-attachments/assets/538477be-2494-49a4-abdb-51f75c66e6a6)

![WhatsApp Image 2025-04-16 at 11 48 03_6f1ddbf2](https://github.com/user-attachments/assets/2059d003-83df-4eb9-8766-598261390e77)


![WhatsApp Image 2025-04-16 at 11 48 03_103a0760](https://github.com/user-attachments/assets/ce9e4bdc-3f43-4ef8-9c8f-81cb19923bba)






- All contributors and testers

