// lib/utils/constants.dart

import 'package:flutter/material.dart';

class AppConstants {
  // App Information
  static const String appName = 'Food Delivery';
  static const String appVersion = '1.0.0';
  
  // API Constants
  static const String baseApiUrl = 'https://api.example.com';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String cartKey = 'cart_items';
  static const String addressKey = 'delivery_address';
  static const String themeKey = 'app_theme';

  // UI Dimensions
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double cardBorderRadius = 15.0;
  static const double buttonHeight = 48.0;
  static const double cardElevation = 4.0;
  static const double gridSpacing = 16.0;
  static const double iconSize = 24.0;
  static const double cartIconSize = 20.0;
  static const double foodImageHeight = 120.0;
  static const double categoryHeight = 50.0;

  // UI Colors
  static const Color primaryColor = Color(0xFF2196F3);
  static const Color secondaryColor = Color(0xFF4CAF50);
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFA000);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color cardColor = Colors.white;
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color dividerColor = Color(0xFFBDBDBD);

  // Category Data
  static const List<String> foodCategories = [
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

  // Text Styles
  static const TextStyle headerStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: textPrimaryColor,
  );

  static const TextStyle subheaderStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: textPrimaryColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 14,
    color: textSecondaryColor,
  );

  static const TextStyle priceStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: primaryColor,
  );

  // Input Decoration
  static InputDecoration searchDecoration = InputDecoration(
    hintText: 'Search foods...',
    prefixIcon: Icon(Icons.search),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(cardBorderRadius),
    ),
    contentPadding: EdgeInsets.symmetric(
      horizontal: defaultPadding,
      vertical: smallPadding,
    ),
  );

  // Card Decoration
  static BoxDecoration cardDecoration = BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(cardBorderRadius),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ],
  );

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 350);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Messages
  static const String noInternetMessage = 'No internet connection';
  static const String serverErrorMessage = 'Server error occurred';
  static const String addedToCartMessage = 'Item added to cart';
  static const String removedFromCartMessage = 'Item removed from cart';
  static const String emptyCartMessage = 'Your cart is empty';
  static const String orderSuccessMessage = 'Order placed successfully!';
  static const String orderFailureMessage = 'Failed to place order';

  // Validation Constants
  static const int maxAddressLength = 200;
  static const int minOrderAmount = 10;
  static const double minDeliveryAmount = 15.0;
  static const int maxCartItems = 99;
  static const String phonePattern = r'^\+?[\d\s-]{10,}$';
  static const String emailPattern = 
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';

  // Placeholder Images
  static const String placeholderImage = 'assets/images/placeholder.png';
  static const String errorImage = 'assets/images/error.png';
  static const String emptyCartImage = 'assets/images/empty_cart.png';

  // Grid Settings
  static const int gridCrossAxisCount = 2;
  static const double gridChildAspectRatio = 0.75;

  // Cart Badge Settings
  static const double badgeSize = 16;
  static const double badgeFontSize = 10;
  static const double badgePadding = 4;

  // Button Settings
  static final ButtonStyle primaryButtonStyle = ElevatedButton.styleFrom(
    minimumSize: Size(double.infinity, buttonHeight),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(cardBorderRadius),
    ),
  );

  // Private constructor to prevent instantiation
  AppConstants._();
}

// Extension for responsive sizing
extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isSmallScreen => screenWidth < 600;
  bool get isMediumScreen => screenWidth >= 600 && screenWidth < 1200;
  bool get isLargeScreen => screenWidth >= 1200;
}

// Extension for theme access
extension ThemeGetter on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colors => Theme.of(this).colorScheme;
}

// Extension for snackbar showing
extension ShowSnackBar on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppConstants.errorColor : AppConstants.successColor,
        behavior: SnackBarBehavior.floating,
        duration: AppConstants.shortAnimation,
      ),
    );
  }
}