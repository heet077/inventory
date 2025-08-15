import 'package:flutter/material.dart';
import '../screens/inventory_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String inventory = '/inventory';

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const InventoryScreen(),
      inventory: (context) => const InventoryScreen(),
    };
  }

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          builder: (context) => const InventoryScreen(),
        );
      case inventory:
        return MaterialPageRoute(
          builder: (context) => const InventoryScreen(),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => const InventoryScreen(),
        );
    }
  }
} 