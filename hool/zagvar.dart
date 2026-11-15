import 'package:flutter/material.dart';
import 'ogogdol.dart';

class AppColors {
  static const bg = Color(0xFFFFF9EC);
  static const primary = Color(0xFFF7B500);
  static const primaryDark = Color(0xFFB97A00);
  static const onPrimary = Color(0xFF2B2118);
  static const sky = Color(0xFFFFEFC0);
  static const ink = Color(0xFF2B2118);
  static const muted = Color(0xFF8A7B66);
  static const white = Color(0xFFFFFFFF);
  static const danger = Color(0xFFC0392B);
  static const ok = Color(0xFF2E8B57);
}

const yellowGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFFFFD84D), Color(0xFFF7B500)],
);

const cardShadow = [
  BoxShadow(color: Color(0x1AB97A00), blurRadius: 18, offset: Offset(0, 8)),
];

String emojiOf(String category) {
  switch (category) {
    case 'Монгол':
      return '🥟';
    case 'Шөл':
      return '🍲';
    case 'Шарсан':
      return '🍳';
    case 'Хурдан хоол':
      return '🍔';
    default:
      return '🍪';
  }
}

/// Жорын зураг эсвэл зураг байхгүй бол emoji болон хэрэглэгчийн оруулсан зургийг харуулна
class RecipeThumb extends StatelessWidget {
  final Recipe recipe;
  final double? width, height;
  final double emojiSize;
  final BorderRadius radius;

  const RecipeThumb({
    super.key,
    required this.recipe,
    this.width,
    this.height,
    this.emojiSize = 36,
    this.radius = const BorderRadius.all(Radius.circular(14)),
  });

  @override
  Widget build(BuildContext context) {
    final bytes = recipe.imageBytes;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: width,
        height: height,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.sky,
          borderRadius: radius,
        ),
        child: bytes != null
            ? Image.memory(
                bytes,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              )
            : Center(
                child: Text(
                  emojiOf(recipe.category),
                  style: TextStyle(fontSize: emojiSize),
                ),
              ),
      ),
    );
  }
}
