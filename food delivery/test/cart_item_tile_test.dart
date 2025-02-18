import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../lib/models/cart.dart';
import '../lib/models/food_item.dart';
import '../lib/widgets/cart_item_tile.dart';

void main() {
  testWidgets('Increment and decrement quantity', (WidgetTester tester) async {
    // Create a FoodItem instance
    final foodItem = FoodItem(
      id: '1',
      name: 'Pizza',
      price: 9.99,
      description: 'Delicious pizza',
      imageUrl: 'https://example.com/pizza.jpg',
      restaurant: 'Pizza Place',
    );

    // Initialize Cart model with a Provider
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => Cart(),
        child: MaterialApp(
          home: Scaffold(
            body: CartItemTile(
              foodItem: foodItem,
              quantity: 0, // Initially set the quantity to 0
            ),
          ),
        ),
      ),
    );

    // Initially, the quantity should be 0
    expect(find.text('0'), findsOneWidget);

    // Simulate clicking the increment button
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle(); // Ensure the widget tree has settled

    // Add debug print of the widget tree to inspect if the text is being updated
    debugDumpApp();  // Print the entire widget tree

    // Now the quantity should be 1
    expect(find.text('1'), findsOneWidget);

    // Simulate clicking the decrement button
    await tester.tap(find.byIcon(Icons.remove));
    await tester.pumpAndSettle(); // Ensure the widget tree has settled

    // The quantity should be 0 again
    expect(find.text('0'), findsOneWidget);

    // Simulate clicking the increment button twice
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // The quantity should now be 2
    expect(find.text('2'), findsOneWidget);
  });
}
