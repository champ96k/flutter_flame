import '../config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OverlayScreen extends StatelessWidget {
  const OverlayScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onTap
  });

  final String title;
  final String subtitle;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: const Alignment(0, -0.15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 4*brickHeight,),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineLarge,
            ).animate().slideY(duration: 750.ms, begin: -3, end: 0),
            const SizedBox(height: 16),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            )
                .animate(onPlay: (controller) => controller.repeat())
                .fadeIn(duration: 1.seconds)
                .then()
                .fadeOut(duration: 1.seconds),
          ],
        ),
      ),
    );
  }
}