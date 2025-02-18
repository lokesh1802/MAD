// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_item.dart';

class ApiService {
  static const String baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<FoodItem>> getFoodItems({String? category}) async {
    try {
      late http.Response response;

      if (category == null || category == 'All') {
        // Get all meals
        response = await http.get(Uri.parse('$baseUrl/search.php?s='));
      } else {
        // Get meals by category
        response = await http.get(Uri.parse('$baseUrl/filter.php?c=$category'));
      }

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final meals = data['meals'] as List<dynamic>?;
        
        if (meals == null) return [];

        List<FoodItem> foodItems = [];

        for (var meal in meals) {
          // For category-filtered results, we need to get full meal details
          if (category != null && category != 'All') {
            final detailResponse = await http.get(
              Uri.parse('$baseUrl/lookup.php?i=${meal['idMeal']}')
            );
            
            if (detailResponse.statusCode == 200) {
              final detailData = json.decode(detailResponse.body);
              final mealDetail = detailData['meals'][0];
              
              foodItems.add(FoodItem(
                id: mealDetail['idMeal'],
                name: mealDetail['strMeal'],
                price: _generatePrice(mealDetail['idMeal']),
                description: _truncateDescription(mealDetail['strInstructions'] ?? ''),
                imageUrl: mealDetail['strMealThumb'],
                restaurant: mealDetail['strArea'] ?? 'International Kitchen',
                category: mealDetail['strCategory'],
              ));
            }
          } else {
            // For all meals, we already have full details
            foodItems.add(FoodItem(
              id: meal['idMeal'],
              name: meal['strMeal'],
              price: _generatePrice(meal['idMeal']),
              description: _truncateDescription(meal['strInstructions'] ?? ''),
              imageUrl: meal['strMealThumb'],
              restaurant: meal['strArea'] ?? 'International Kitchen',
              category: meal['strCategory'],
            ));
          }
        }

        return foodItems;
      } else {
        throw Exception('Failed to load foods');
      }
    } catch (e) {
      print('Error in getFoodItems: $e');
      throw Exception('Error loading foods');
    }
  }

  double _generatePrice(String mealId) {
    return 8.99 + (int.parse(mealId) % 17);
  }

  String _truncateDescription(String text) {
    const maxLength = 100;
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }
}