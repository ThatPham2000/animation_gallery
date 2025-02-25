import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoading extends StatefulWidget {
  const LottieLoading({super.key});

  @override
  State<LottieLoading> createState() => _LottieLoadingState();
}

class _LottieLoadingState extends State<LottieLoading> {
  late final Future<LottieComposition> _composition;

  @override
  void initState() {
    super.initState();

    _composition = AssetLottie('LottieLogo1.json').load();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LottieComposition>(
      future: _composition,
      builder: (context, snapshot) {
        var composition = snapshot.data;
        if (composition != null) {
          return Lottie(composition: composition);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
