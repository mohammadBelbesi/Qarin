import 'package:flutter/material.dart';
import 'package:karen/screens/request/requests_page.dart';
import 'screens/log/OTPPage.dart';
import 'screens/log/registration_page.dart';
import 'screens/home/home_page.dart';
import 'screens/log/onboarding_page.dart';
import 'screens/category/category_page.dart';
import 'screens/request/my_requests_page.dart';
import 'screens/profile/profile_page.dart';
import 'package:karen/screens/main_client_screen.dart';
import 'package:karen/screens/main_store_screen.dart';
import 'package:karen/screens/cart/cart_page.dart'; // Import the cart page

class AppRoutes {
  // Static routes for direct mapping
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      '/': (context) => const MainScreen(),
      '/onboarding': (context) => const OnboardingPage(),
      '/OTPPage': (context) => const OTPPage(),
      '/register': (context) => const RegistrationPage(),
      '/home': (context) => const HomePage(),
      '/requests': (context) => const RequestsPage(),
      '/myRequest': (context) => const MyRequestsPage(),
      '/profile': (context) => const ProfilePage(),
      '/store': (context) => const MainStoreScreen(),
      '/cart': (context) => const CartPage(), // Add cart page route
    };
  }

  // Dynamic route generator
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/category':
        final args = settings.arguments as Map<String, dynamic>?;

        // Retrieve parameters
        final categoryId = args?['categoryId'] ?? ''; // Default to empty string
        final categoryName =
            args?['categoryName'] ?? 'Default'; // Default to 'Default'

        return MaterialPageRoute(
          builder: (context) => CategoryPage(
            categoryId: categoryId,
            categoryName: categoryName,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(
              title: const Text('Page Not Found'),
            ),
            body: const Center(
              child: Text('404 - Page Not Found'),
            ),
          ),
        );
    }
  }
}
