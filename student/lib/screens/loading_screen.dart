import 'package:flutter/material.dart';

import 'package:rive/rive.dart' as rive;

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: rive.RiveAnimation.asset(
          'assets/animations/loader.riv',
          animations: ['loop'],
        ),
      ),
    );
  }
}
