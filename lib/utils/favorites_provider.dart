import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider with ChangeNotifier {
  final String _prefsKey = 'favorite_coins';
  Set<String> _favorites = {};
  bool _isLoaded = false;
  
  Set<String> get favorites => _favorites;
  bool get isLoaded => _isLoaded;
  
  FavoritesProvider() {
    _loadFavorites();
  }
  
  // Load favorites from shared preferences
  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList(_prefsKey) ?? [];
    _favorites = favoritesList.toSet();
    _isLoaded = true;
    notifyListeners();
  }
  
  // Save favorites to shared preferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_prefsKey, _favorites.toList());
  }
  
  // Check if a coin is in favorites
  bool isFavorite(String coinId) {
    return _favorites.contains(coinId);
  }
  
  // Toggle favorite status for a coin
  Future<void> toggleFavorite(String coinId) async {
    if (_favorites.contains(coinId)) {
      _favorites.remove(coinId);
    } else {
      _favorites.add(coinId);
    }
    await _saveFavorites();
    notifyListeners();
  }
  
  // Get the list of favorite coin IDs
  List<String> getFavoriteIds() {
    return _favorites.toList();
  }
}