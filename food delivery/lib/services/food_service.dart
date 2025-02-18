// lib/services/food_service.dart

import '../models/food_item.dart';
import 'api_service.dart';

class FoodService {
  final ApiService _api = ApiService();
  
  // Cache mechanism
  List<FoodItem>? _cachedAllFoods;
  Map<String, List<FoodItem>> _categoryCache = {};
  DateTime? _lastCacheTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  Future<List<FoodItem>> getFoods({String? category}) async {
    try {
      // Check if we should use cache
      if (_isCacheValid) {
        if (category == null || category == 'All') {
          if (_cachedAllFoods != null) {
            return _cachedAllFoods!;
          }
        } else if (_categoryCache.containsKey(category)) {
          return _categoryCache[category]!;
        }
      }

      // Fetch from API if no valid cache
      final foods = await _api.getFoodItems(category: category);

      // Update cache
      if (category == null || category == 'All') {
        _cachedAllFoods = foods;
      } else {
        _categoryCache[category] = foods;
      }
      _lastCacheTime = DateTime.now();

      return foods;
    } catch (e) {
      // Try to return cached data if API fails
      if (category == null || category == 'All') {
        if (_cachedAllFoods != null) {
          return _cachedAllFoods!;
        }
      } else if (_categoryCache.containsKey(category)) {
        return _categoryCache[category]!;
      }
      
      print('Error fetching foods: $e');
      throw Exception('Failed to load foods. Please check your internet connection.');
    }
  }

  // Check if cache is still valid
  bool get _isCacheValid {
    if (_lastCacheTime == null) return false;
    return DateTime.now().difference(_lastCacheTime!) < _cacheValidDuration;
  }

  // Clear cache
  void clearCache() {
    _cachedAllFoods = null;
    _categoryCache.clear();
    _lastCacheTime = null;
  }

  // Get categories (if needed in the future)
  Future<List<String>> getCategories() async {
    try {
      final foods = await getFoods();
      final categories = {'All'};
      
      for (var food in foods) {
        if (food.category != null && food.category!.isNotEmpty) {
          categories.add(food.category!);
        }
      }
      
      return categories.toList()..sort();
    } catch (e) {
      print('Error fetching categories: $e');
      return [
        'All',
        'Beef',
        'Chicken',
        'Dessert',
        'Lamb',
        'Pasta',
        'Pork',
        'Seafood',
        'Side',
        'Starter',
        'Vegan',
        'Vegetarian'
      ];
    }
  }

  // Search foods (if needed in the future)
  Future<List<FoodItem>> searchFoods(String query) async {
    if (query.isEmpty) return [];

    try {
      // Try to search in cache first
      if (_isCacheValid && _cachedAllFoods != null) {
        return _cachedAllFoods!.where((food) =>
          food.name.toLowerCase().contains(query.toLowerCase()) ||
          food.category?.toLowerCase().contains(query.toLowerCase()) == true ||
          food.restaurant.toLowerCase().contains(query.toLowerCase())
        ).toList();
      }

      // If no cache, fetch all foods and search
      final foods = await getFoods();
      return foods.where((food) =>
        food.name.toLowerCase().contains(query.toLowerCase()) ||
        food.category?.toLowerCase().contains(query.toLowerCase()) == true ||
        food.restaurant.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error searching foods: $e');
      throw Exception('Failed to search foods. Please try again.');
    }
  }
}