class Constants {
  // API Constants
  static const String apiBaseUrl = 'https://api.coingecko.com/api/v3';
  
  // Time ranges for charts (in days)
  static const List<int> timeRanges = [1, 7, 30, 90, 365];
  
  // Default refresh interval in seconds
  static const int defaultRefreshInterval = 60;
  
  // Shared preferences keys
  static const String prefsFavoriteCoins = 'favorite_coins';
  static const String prefsSelectedCurrency = 'selected_currency';
  
  // Supported currencies
  static const Map<String, String> supportedCurrencies = {
    'usd': '\$',
    'eur': '€',
    'gbp': '£',
    'jpy': '¥',
    'inr': '₹',
  };
  
  // Error messages
  static const String errorLoadingCoins = 'Failed to load coin data. Please check your internet connection and try again.';
  static const String errorLoadingChart = 'Failed to load chart data.';
  static const String errorApiRateLimit = 'API rate limit reached. Please try again later.';
}