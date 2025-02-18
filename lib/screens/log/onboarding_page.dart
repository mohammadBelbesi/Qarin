import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50], // Subtle background to match the logo
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/karen_logo.png',
              height: 150,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                size: 150,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 30),

            // Title
            const Text(
              "Welcome to Karen",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87, // Slightly muted black for better readability
              ),
            ),
            const SizedBox(height: 15),

            // Description
            const Text(
              "Compare prices and find the best deals effortlessly.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 40),

            // Get Started Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                backgroundColor: Colors.blueAccent, // Match logo's dominant color
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                shadowColor: Colors.blue[200],
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/OTPPage');
              },
              child: const Text(
                "Get Started",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
