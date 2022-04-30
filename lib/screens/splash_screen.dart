import 'package:flutter/material.dart';

class AppSplashScreen extends StatelessWidget {
  const AppSplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/ecommerce.png',
              height: 200,
              width: 200,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Authenticating\nPlease wait...",
              textAlign: TextAlign.center,
              textScaleFactor: 2,
            ),
            const SizedBox(
              height: 20,
            ),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
