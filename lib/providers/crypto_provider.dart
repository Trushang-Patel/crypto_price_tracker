import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/coin.dart';
import '../models/chart_data.dart';
import '../services/api_service.dart';

class CryptoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Coin> _coins = [];
  List<Coin> get coins => _coins;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  
  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  
  Map<String, ChartData> _chartDataCache = {};
  
  // Selected time range for chart (in days)
  int _selectedTimeRange = 7;
  int get selectedTimeRange => _selectedTimeRange;
  
  // Timer for auto-refresh
  Timer? _refreshTimer;
  
  // Initialize with data
  Future<void> initialize() async {
    await fetchCoins();
    
    // Set up periodic refresh (every 60 seconds)
    _refreshTimer = Timer.periodic(const Duration(seconds: 60), (_) {
      fetchCoins(silent: true);
    });
  }
  
  // Dispose resources
  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
  
  // Set selected time range
  void setTimeRange(int days) {
    _selectedTimeRange = days;
    notifyListeners();
  }
  
  // Fetch list of coins
  Future<void> fetchCoins({bool silent = false}) async {
    if (!silent) {
      _isLoading = true;
      notifyListeners();
    }
    
    try {
      final coinsData = await _apiService.getCoins();
      _coins = coinsData.map((coin) => Coin.fromJson(coin)).toList();
      _errorMessage = '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  // Get chart data for a specific coin
  Future<ChartData?> getCoinChartData(String coinId, int days) async {
    final cacheKey = '$coinId-$days';
    
    // Return from cache if available and not expired
    if (_chartDataCache.containsKey(cacheKey)) {
      return _chartDataCache[cacheKey];
    }
    
    try {
      final data = await _apiService.getCoinChartData(coinId, days);
      final chartData = ChartData.fromJson(data);
      
      // Cache the result
      _chartDataCache[cacheKey] = chartData;
      
      return chartData;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return null;
    }
  }
  
  // Get a specific coin by ID
  Coin? getCoinById(String id) {
    try {
      return _coins.firstWhere((coin) => coin.id == id);
    } catch (e) {
      return null;
    }
  }
  
  // Refresh chart data (clear cache)
  void refreshChartData() {
    _chartDataCache.clear();
    notifyListeners();
  }
}