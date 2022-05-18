import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({Key? key}) : super(key: key);

  static Page route() {
    return const MaterialPage<void>(
      child: SplashPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Kasassy',
          style: TextStyle(
            fontSize: 100,
            fontFamily: 'Italianno',
            color: Colors.brown,
          ),
        ),
      ),
    );
  }
}
