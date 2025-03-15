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

- **Flutter**: Cross-platform mobile app development framework
- **Provider**: State management solution for Flutter
- **fl_chart**: For creating interactive and responsive charts
- **CoinGecko API**: For real-time cryptocurrency data
- **http package**: For making HTTP requests to the CoinGecko API
- **shared_preferences**: For local storage to save user preferences (e.g., favorite cryptocurrencies)
- **intl package**: For formatting numbers and dates

## Getting Started

### Prerequisites

To get started, ensure you have the following installed:

- **Flutter SDK** (latest version)
- **Dart SDK** (latest version)
- **Android Studio / VS Code** (with Flutter and Dart plugins)
- **iOS Simulator** (for macOS) or **Android Emulator**

### Installation

1. Clone this repository:

```bash
git clone https://github.com/Trushang-Patel/crypto_price_tracker.git
```

2. Navigate to the project directory:
```bash
cd crypto_price_tracker
```

3. Install the required dependencies:
```bash
flutter pub get
```

4.Run the app on your desired platform (iOS or Android):
```bash
flutter run
```

## API Integration

This app uses the CoinGecko API to fetch cryptocurrency data. The CoinGecko API is free to use and does not require an API key. However, there are rate limits, so please be mindful of the requests.

For more details, refer to the [CoinGecko API documentation](https://www.coingecko.com/en/api/documentation).

## Performance Optimization

To enhance performance, the app incorporates the following techniques:

- **Caching**: Chart data is cached to reduce redundant API calls.
- **Efficient UI Rendering**: The app uses `const` constructors to improve rendering performance.
- **Lazy Loading**: Screens are lazily loaded using `IndexedStack` to improve initial load times.
- **Throttling API Requests**: To avoid hitting the CoinGecko rate limits, API requests are throttled.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- [CoinGecko API](https://www.coingecko.com/) for providing cryptocurrency data.
- [fl_chart](https://pub.dev/packages/fl_chart) for the charting functionality.
- [Flutter Team](https://flutter.dev/) for developing the amazing Flutter framework.

## Contribution

Feel free to contribute to this project! You can fork the repository, make changes, and submit pull requests. Any improvements are appreciated.


