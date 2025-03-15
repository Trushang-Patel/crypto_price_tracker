class ChartData {
  final List<List<num>> prices;
  final List<List<num>> marketCaps;
  final List<List<num>> totalVolumes;
  
  ChartData({
    required this.prices,
    required this.marketCaps,
    required this.totalVolumes,
  });
  
  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      prices: List<List<num>>.from(json['prices'].map((x) => List<num>.from(x))),
      marketCaps: List<List<num>>.from(json['market_caps'].map((x) => List<num>.from(x))),
      totalVolumes: List<List<num>>.from(json['total_volumes'].map((x) => List<num>.from(x))),
    );
  }
}