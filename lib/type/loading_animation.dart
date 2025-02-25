import 'package:flutter/material.dart';

class LoadingAnimation extends StatefulWidget {
  const LoadingAnimation({super.key, this.size = 200});

  final double size;

  @override
  State<LoadingAnimation> createState() => _LoadingAnimationState();
}

class _LoadingAnimationState extends State<LoadingAnimation>
    with TickerProviderStateMixin<LoadingAnimation> {
  late AnimationController controller1;
  late Animation<double> animation1;

  late AnimationController controller2;
  late Animation<double> animation2;

  @override
  void initState() {
    controller1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation1 = Tween<double>(begin: 0, end: .5)
        .animate(CurvedAnimation(parent: controller1, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
          controller2.forward();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });

    controller2 =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    animation2 = Tween<double>(begin: 0, end: .5)
        .animate(CurvedAnimation(parent: controller2, curve: Curves.easeInOut))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });

    controller1.forward();
    super.initState();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: CustomPaint(
        painter: MyPainter(
          radius1: animation1.value,
          radius2: animation2.value,
        ),
        child: Container(),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  const MyPainter({required this.radius1, required this.radius2});

  final double radius1;
  final double radius2;

  @override
  void paint(Canvas canvas, Size size) {
    final circle1 = Paint()..color = Colors.amber;
    final circle2 = Paint()..color = Colors.green;

    canvas
      ..drawCircle(
        Offset(size.width * .5, size.height * .5),
        size.width * radius1,
        circle1,
      )
      ..drawCircle(
        Offset(size.width * .5, size.height * .5),
        size.width * radius2,
        circle2,
      );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
