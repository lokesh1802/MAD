// lib/models/food_item.dart

class FoodItem {
  final String id;
  final String name;
  final double price;
  final String description;
  final String imageUrl;
  final String restaurant;
  final String? category;

  FoodItem({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    required this.imageUrl,
    required this.restaurant,
    this.category,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'].toString(),
      name: json['name'],
      price: double.parse(json['price'].toString()),
      description: json['description'],
      imageUrl: json['image_url'],
      restaurant: json['restaurant'],
      category: json['category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'image_url': imageUrl,
      'restaurant': restaurant,
      'category': category,
    };
  }
}