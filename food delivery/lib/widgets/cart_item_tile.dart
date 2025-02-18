import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../models/cart.dart';
import '../utils/constants.dart';

class CartItemTile extends StatefulWidget {
  final FoodItem foodItem;
  final int quantity;

  const CartItemTile({
    Key? key,
    required this.foodItem,
    required this.quantity,
  }) : super(key: key);

  @override
  _CartItemTileState createState() => _CartItemTileState();
}

class _CartItemTileState extends State<CartItemTile> {
  late int quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.quantity; // Initialize with the quantity passed from parent
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(widget.foodItem.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: AppConstants.defaultPadding),
        color: Colors.red,
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {
        for (var i = 0; i < quantity; i++) {
          context.read<Cart>().removeItem(widget.foodItem.id);
        }
      },
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          child: Image.network(
            widget.foodItem.imageUrl,
            width: 60,
            height: 60,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: Icon(Icons.restaurant),
              );
            },
          ),
        ),
        title: Text(
          widget.foodItem.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          '\$${(widget.foodItem.price * quantity).toStringAsFixed(2)}',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.remove),
              onPressed: () {
                if (quantity > 0) {
                  setState(() {
                    quantity--;
                  });
                  context.read<Cart>().removeItem(widget.foodItem.id);
                }
              },
            ),
            Text(
              quantity.toString(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  quantity++;
                });
                context.read<Cart>().addItem(widget.foodItem);
              },
            ),
          ],
        ),
      ),
    );
  }
}
