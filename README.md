# Cryptocurrency Price Tracker

A Flutter application that fetches real-time cryptocurrency prices and visualizes trends using charts.

## Features

- Real-time cryptocurrency price tracking
- Interactive price charts with multiple time ranges (24h, 7d, 30d, 90d, 1y)
- Search functionality to find specific cryptocurrencies
- Favorite/bookmark system to keep track of preferred cryptocurrencies
- Dark mode support
- Market overview with top and worst performers

## Technologies Used

- Flutter for cross-platform mobile app development
- Provider package for state management
- fl_chart for interactive and responsive charts
- CoinGecko API for real-time cryptocurrency data
- http package for API integration
- shared_preferences for local storage
- intl package for formatting numbers and dates

## Getting Started

### Prerequisites

- Flutter SDK (latest version)
- Dart SDK (latest version)
- Android Studio / VS Code with Flutter plugins
- iOS Simulator (for Mac) or Android Emulator

### Installation

1. Clone this repository
https://github.com/Trushang-Patel/crypto-price-tracker.git

2. Navigate to the project directory
cd crypto-price-tracker


3. Install dependencies
flutter pub get


4. Run the app
flutter run


## API Integration

This app uses the free CoinGecko API to fetch cryptocurrency data. No API key is required for basic usage, but there are rate limits. For more details, check the [CoinGecko API documentation](https://www.coingecko.com/en/api/documentation).

## Performance Optimization

The app implements several performance optimization techniques:
- Caching of chart data to minimize API calls
- Efficient UI rendering with `const` constructors where possible
- Lazy loading of screens through IndexedStack
- Throttling of API requests to avoid rate limiting

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- [CoinGecko API](https://www.coingecko.com/) for providing cryptocurrency data
- [fl_chart](https://pub.dev/packages/fl_chart) for the charting functionality
- [Flutter Team](https://flutter.dev/) for the amazing framework