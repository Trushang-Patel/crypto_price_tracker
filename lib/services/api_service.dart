import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://api.coingecko.com/api/v3';
  
  // Get list of coins with market data
  Future<List<dynamic>> getCoins({
    String currency = 'usd',
    int page = 1,
    int perPage = 20,
    String order = 'market_cap_desc',
  }) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/markets?vs_currency=$currency&order=$order&per_page=$perPage&page=$page&sparkline=true&price_change_percentage=1h,24h,7d',
        ),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load coins: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
  
  // Get detailed data for a specific coin
  Future<Map<String, dynamic>> getCoinDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/$id?localization=false&tickers=true&market_data=true&community_data=true&developer_data=true&sparkline=true',
        ),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load coin detail: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
  
  // Get historical chart data for a coin
  Future<Map<String, dynamic>> getCoinChartData(String id, int days) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/coins/$id/market_chart?vs_currency=usd&days=$days',
        ),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load chart data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
  
  // Get global crypto market data
  Future<Map<String, dynamic>> getGlobalData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/global'),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load global data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to connect to API: $e');
    }
  }
}