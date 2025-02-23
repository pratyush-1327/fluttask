import 'package:fluttask/presentation/screens/api_key_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttask/presentation/screens/todo_screen.dart'; // Import the next screen

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned(
            bottom: -70,
            left: 100,
            child: Image.asset(
              "lib/presentation/images/splant.png",
              fit: BoxFit.fitWidth,
            ),
          ),

          // Centered Text & Button
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Welcome to Fluttask!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      _createRoute(),
                    );
                  },
                  child: const Text("Get Started"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom Page Route with Slide Transition
  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 300), // Animation Speed
      pageBuilder: (context, animation, secondaryAnimation) => ApiKeyScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Start from the right
        const end = Offset.zero; // Move to normal position
        const curve = Curves.easeInOut; // Smooth animation

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(position: offsetAnimation, child: child);
      },
    );
  }
}
