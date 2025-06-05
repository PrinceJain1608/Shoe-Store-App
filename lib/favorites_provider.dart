import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesProvider extends ChangeNotifier {
  List<String> _favorites = [];
  final SharedPreferences _prefs;

  FavoritesProvider(this._prefs) {
    _loadFavorites();
  }

  List<String> get favorites => _favorites;

  void _loadFavorites() {
    final favoritesJson = _prefs.getString('favorites');
    if (favoritesJson != null) {
      _favorites = List<String>.from(json.decode(favoritesJson));
    }
    notifyListeners();
  }

  void _saveFavorites() {
    _prefs.setString('favorites', json.encode(_favorites));
  }

  bool isFavorite(String productId) {
    return _favorites.contains(productId);
  }

  void toggleFavorite(String productId) {
    if (_favorites.contains(productId)) {
      _favorites.remove(productId);
    } else {
      _favorites.add(productId);
    }
    _saveFavorites();
    notifyListeners();
  }
}
