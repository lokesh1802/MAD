import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import '../lib/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Food Delivery App Integration Tests', () {
    testWidgets('Complete ordering flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Verify initial screen
      expect(find.text('Food Delivery'), findsOneWidget);

      // Add an item to the cart
      await tester.tap(find.text('Margherita Pizza'));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.add_shopping_cart));
      await tester.pumpAndSettle();

      // Navigate to cart and verify item
      await tester.tap(find.byIcon(Icons.shopping_cart));
      await tester.pumpAndSettle();
      expect(find.text('Margherita Pizza'), findsOneWidget);

      // Proceed to checkout
      await tester.tap(find.text('Checkout'));
      await tester.pumpAndSettle();
      expect(find.text('Order placed successfully!'), findsOneWidget);
    });
  });
}
