<img width="543" height="817" alt="Screenshot 2025-06-12 174644" src="https://github.com/user-attachments/assets/828c08cc-3c1a-416c-8a48-276d1b962395" /># MedHealth - Your Digital Pharmacy

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
- All contributors and testers

