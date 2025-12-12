import 'package:flutter/material.dart';

class FavoritesService extends ChangeNotifier {
  final Set<String> _favoriteIds = {};

  Set<String> get favoriteIds => _favoriteIds;

  void toggleFavorite(String mealId) {
    if (_favoriteIds.contains(mealId)) {
      _favoriteIds.remove(mealId);
    } else {
      _favoriteIds.add(mealId);
    }
    notifyListeners();
  }

  bool isFavorite(String mealId) {
    return _favoriteIds.contains(mealId);
  }

  void addFavorite(String mealId) {
    _favoriteIds.add(mealId);
    notifyListeners();
  }

  void removeFavorite(String mealId) {
    _favoriteIds.remove(mealId);
    notifyListeners();
  }
}
