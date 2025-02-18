// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart.dart';
import '../models/food_item.dart';
import '../widgets/food_item_card.dart';
import '../utils/constants.dart';
import '../services/food_service.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final FoodService _foodService = FoodService();
  late TabController _tabController;
  List<FoodItem> _foods = [];
  List<FoodItem> _filteredFoods = [];
  bool _isLoading = true;
  String _currentCategory = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: AppConstants.foodCategories.length, vsync: this);
    _tabController.addListener(_handleTabSelection);
    _loadFoodsByCategory('All');
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      final newCategory = AppConstants.foodCategories[_tabController.index];
      if (newCategory != _currentCategory) {
        _currentCategory = newCategory;
        _loadFoodsByCategory(newCategory);
      }
    }
  }

  Future<void> _loadFoodsByCategory(String category) async {
    try {
      setState(() => _isLoading = true);
      final foods = await _foodService.getFoods(
        category: category == 'All' ? null : category
      );
      setState(() {
        _filteredFoods = foods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load foods'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: () => _loadFoodsByCategory(category),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1504674900247-0877df9cc836',
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.7),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Hungry?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Order fresh food now',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                Stack(
                  children: [
                    IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () => Navigator.pushNamed(context, '/cart'),
                    ),
                    Consumer<Cart>(
                      builder: (context, cart, child) {
                        if (cart.items.isEmpty) return SizedBox.shrink();
                        return Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            constraints: BoxConstraints(
                              minWidth: 16,
                              minHeight: 16,
                            ),
                            child: Text(
                              cart.items.length.toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  tabs: AppConstants.foodCategories.map((category) => Tab(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: AppConstants.smallPadding,
                        horizontal: AppConstants.defaultPadding,
                      ),
                      decoration: BoxDecoration(
                        color: category == _currentCategory
                            ? Theme.of(context).primaryColor.withOpacity(0.1)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(
                          AppConstants.cardBorderRadius,
                        ),
                      ),
                      child: Text(category),
                    ),
                  )).toList(),
                  indicatorColor: Theme.of(context).primaryColor,
                  labelColor: Theme.of(context).primaryColor,
                  unselectedLabelColor: Colors.grey,
                ),
              ),
            ),
          ];
        },
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _filteredFoods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.no_food, size: 64, color: Colors.grey),
                        SizedBox(height: 16),
                        Text(
                          'No foods available in $_currentCategory',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: EdgeInsets.all(16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredFoods.length,
                    itemBuilder: (context, index) {
                      return FoodItemCard(foodItem: _filteredFoods[index]);
                    },
                  ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}