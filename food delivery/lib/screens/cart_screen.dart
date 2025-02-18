import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../widgets/cart_item_tile.dart';
import '../utils/constants.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Consumer<Cart>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://via.placeholder.com/150',
                    width: 150,
                    height: 150,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cart.foodItems.length,
                  itemBuilder: (context, index) {
                    final item = cart.foodItems[index];
                    final quantity = cart.items[item.id]!;
                    return CartItemTile(
                      foodItem: item,
                      quantity: quantity,
                    );
                  },
                ),
              ),
              Container(
                color: Theme.of(context).cardColor,
                padding: EdgeInsets.all(AppConstants.defaultPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Total: \$${cart.total.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: AppConstants.smallPadding),
                    ElevatedButton(
                      child: Text('Checkout'),
                      onPressed: () {
                        if (cart.total >= AppConstants.minDeliveryAmount) {
                          Navigator.pushNamed(context, '/checkout');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Minimum order amount is \$${AppConstants.minDeliveryAmount.toStringAsFixed(2)}',
                              ),
                              backgroundColor: AppConstants.errorColor,
                            ),
                          );
                        }
                      },
                      style: AppConstants.primaryButtonStyle,
                    ),
                    SizedBox(height: AppConstants.smallPadding),
                    ElevatedButton(
                      child: Text('Clear Cart'),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Clear Cart'),
                            content: Text('Are you sure you want to clear your cart?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              ElevatedButton(
                                child: Text('Clear'),
                                onPressed: () {
                                  context.read<Cart>().clear();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      style: AppConstants.primaryButtonStyle,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}