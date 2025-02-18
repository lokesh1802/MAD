import 'package:flutter/foundation.dart';
import 'food_item.dart';

class Cart extends ChangeNotifier {
  Map<String, int> _items = {};
  List<FoodItem> _foodItems = [];

  Map<String, int> get items => _items;
  List<FoodItem> get foodItems => _foodItems;

  void addItem(FoodItem item) {
    if (_items.containsKey(item.id)) {
      _items[item.id] = _items[item.id]! + 1;
    } else {
      _items[item.id] = 1;
      _foodItems.add(item);
    }
    notifyListeners();
  }

  void removeItem(String id) {
    if (_items.containsKey(id)) {
      if (_items[id]! > 1) {
        _items[id] = _items[id]! - 1;
      } else {
        _items.remove(id);
        _foodItems.removeWhere((item) => item.id == id);
      }
      notifyListeners();
    }
  }

  double get total {
    double sum = 0;
    _items.forEach((id, quantity) {
      final item = _foodItems.firstWhere((item) => item.id == id);
      sum += item.price * quantity;
    });
    return sum;
  }

  get itemCount => null;

  void clear() {
    _items = {};
    _foodItems = [];
    notifyListeners();
  }
}
