class Coin {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double marketCap;
  final int marketCapRank;
  final double high24h;
  final double low24h;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double circulatingSupply;
  final double totalSupply;
  final double maxSupply;
  final List<double> sparklineIn7d;
  final double priceChangePercentage1hInCurrency;
  final double priceChangePercentage24hInCurrency;
  final double priceChangePercentage7dInCurrency;

  Coin({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.marketCap,
    required this.marketCapRank,
    required this.high24h,
    required this.low24h,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.circulatingSupply,
    required this.totalSupply,
    required this.maxSupply,
    required this.sparklineIn7d,
    required this.priceChangePercentage1hInCurrency,
    required this.priceChangePercentage24hInCurrency,
    required this.priceChangePercentage7dInCurrency,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    List<double> sparklineData = [];
    if (json['sparkline_in_7d'] != null && json['sparkline_in_7d']['price'] != null) {
      sparklineData = List<double>.from(json['sparkline_in_7d']['price'].map((x) => x.toDouble()));
    }
    
    return Coin(
      id: json['id'],
      symbol: json['symbol'],
      name: json['name'],
      image: json['image'],
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      marketCapRank: json['market_cap_rank'] ?? 0,
      high24h: (json['high_24h'] ?? 0).toDouble(),
      low24h: (json['low_24h'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
      totalSupply: (json['total_supply'] ?? 0).toDouble(),
      maxSupply: (json['max_supply'] ?? 0).toDouble(),
      sparklineIn7d: sparklineData,
      priceChangePercentage1hInCurrency: (json['price_change_percentage_1h_in_currency'] ?? 0).toDouble(),
      priceChangePercentage24hInCurrency: (json['price_change_percentage_24h_in_currency'] ?? 0).toDouble(),
      priceChangePercentage7dInCurrency: (json['price_change_percentage_7d_in_currency'] ?? 0).toDouble(),
    );
  }
}