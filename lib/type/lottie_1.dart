import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Lottie1 extends StatelessWidget {
  const Lottie1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Lottie.network(
                'https://assets1.lottiefiles.com/packages/lf20_biWZlL.json'),
          ],
        ),
      ),
    );
  }
}
