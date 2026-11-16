import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

const categories = ['Монгол', 'Шөл', 'Шарсан', 'Хурдан хоол', 'Амттан'];
const levels = ['Хялбар', 'Дунд', 'Хэцүү'];

String normalizeIngredient(String s) => s.trim().toLowerCase();

class Ingredient {
  final String name, amount;
  const Ingredient(this.name, [this.amount = '']);
  String get key => normalizeIngredient(name);
}

class Recipe {
  final int id;
  final String name, category, description, level, imageData;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final int minutes, kcal;
  bool isFavorite;

  Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.level,
    required this.ingredients,
    required this.steps,
    required this.minutes,
    required this.kcal,
    this.imageData = '',
    this.isFavorite = false,
  });

  Uint8List? _bytes;

  /// Хэрэглэгчийн оруулсан зураг (байхгүй бол null)
  Uint8List? get imageBytes {
    if (imageData.isEmpty) return null;
    return _bytes ??= base64Decode(imageData);
  }
}

/// Апп дотор өгөгдөл хадгалах, шинэчлэх хэсэг
class MockStore {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);
  static void notify() => version.value++;

  static List<String> fridge = ['Үхрийн мах', 'Гурил', 'Сонгино', 'Төмс'];

  static List<Recipe> recipes = [
    Recipe(
      id: 1,
      name: 'Бууз',
      category: 'Монгол',
      description: 'Монголчуудын цагаан сарын гол хоол. Уураар жигнэдэг.',
      level: 'Дунд',
      ingredients: const [
        Ingredient('Гурил', '500 г'),
        Ingredient('Үхрийн мах', '400 г'),
        Ingredient('Сонгино', '2 ширхэг'),
      ],
      steps: const [
        'Гурилыг усаар зуурч, 20 минут амраана.',
        'Мах, сонгиноо жижиглэн хэрчиж амтална.',
        'Гурилаа элдэж махаа чимхээд 15 минут жигнэнэ.',
      ],
      minutes: 45,
      kcal: 420,
      isFavorite: true,
    ),
  ];

  static void addRecipe(Recipe recipe) {
    recipes.insert(0, recipe);
    notify();
  }

  static void updateRecipe(Recipe updatedRecipe) {
    final index = recipes.indexWhere(
      (r) => r.id == updatedRecipe.id,
    );

    if (index != -1) {
      recipes[index] = updatedRecipe;
      notify();
    }
  }

  static void toggleFavorite(Recipe r) {
    r.isFavorite = !r.isFavorite;
    notify();
  }

  static void toggleFridge(String name) {
    final clean = name.trim();
    if (clean.isEmpty) return;
    final key = normalizeIngredient(clean);
    final idx = fridge.indexWhere((e) => normalizeIngredient(e) == key);
    if (idx >= 0) {
      fridge.removeAt(idx);
    } else {
      fridge.add(clean);
    }
    notify();
  }
}
