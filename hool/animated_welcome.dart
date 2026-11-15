import 'package:flutter/material.dart';
import 'zagvar.dart';

class AnimatedWelcome extends StatefulWidget {
  const AnimatedWelcome({super.key});

  @override
  State<AnimatedWelcome> createState() => _AnimatedWelcomeState();
}

class _AnimatedWelcomeState extends State<AnimatedWelcome>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<double> scale;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1300),
    );

    fade = CurvedAnimation(
      parent: controller,
      curve: const Interval(0.2, 1, curve: Curves.easeIn),
    );

    scale = Tween<double>(
      begin: 0.5,
      end: 1,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0, 0.7, curve: Curves.elasticOut),
      ),
    );

    slide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.2, 1, curve: Curves.easeOutCubic),
      ),
    );

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ScaleTransition(
          scale: scale,
          child: Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: AppColors.sky,
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  blurRadius: 22,
                  offset: const Offset(0, 9),
                ),
              ],
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: AppColors.primary,
              size: 47,
            ),
          ),
        ),
        const SizedBox(height: 18),
        FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: Column(
              children: [
                const Text(
                  'Амттай',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primaryDark,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 7),
                const Text(
                  'Өдөр бүр шинэ амт, шинэ санаа.',
                  style: TextStyle(
                    color: AppColors.muted,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
