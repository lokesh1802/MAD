import 'package:flutter_test/flutter_test.dart';
import '../lib/models/food_item.dart';

void main() {
  group('FoodItem Tests', () {
    test('FoodItem object can be created with valid data', () {
      final food = FoodItem(
        id: '1',
        name: 'Pizza',
        price: 9.99,
        description: 'Delicious pizza',
        imageUrl: 'https://example.com/pizza.jpg',
        restaurant: 'Pizza Place',
      );

      expect(food.id, '1');
      expect(food.name, 'Pizza');
      expect(food.price, 9.99);
      expect(food.description, 'Delicious pizza');
      expect(food.imageUrl, 'https://example.com/pizza.jpg');
      expect(food.restaurant, 'Pizza Place');
    });

    test('FoodItem equality works as expected', () {
  final food1 = FoodItem(
    id: '1',
    name: 'Pizza',
    price: 9.99,
    description: 'Delicious pizza',
    imageUrl: 'https://example.com/pizza.jpg',
    restaurant: 'Pizza Place',
  );

  final food2 = FoodItem(
    id: '1',
    name: 'Pizza',
    price: 9.99,
    description: 'Delicious pizza',
    imageUrl: 'https://example.com/pizza.jpg',
    restaurant: 'Pizza Place',
  );

  expect(food1, equals(food2)); // This should pass now
});

  });
}
