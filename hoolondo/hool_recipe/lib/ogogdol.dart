import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'category': category,
        'description': description,
        'level': level,
        'imageData': imageData,
        'ingredients': ingredients
            .map((item) => {
                  'name': item.name,
                  'amount': item.amount,
                })
            .toList(),
        'steps': steps,
        'minutes': minutes,
        'kcal': kcal,
        'isFavorite': isFavorite,
      };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json['id'] as int,
        name: json['name'] as String,
        category: json['category'] as String,
        description: json['description'] as String,
        level: json['level'] as String,
        imageData: json['imageData'] as String? ?? '',
        ingredients: (json['ingredients'] as List<dynamic>)
            .map((item) => Ingredient(
                  item['name'] as String,
                  item['amount'] as String? ?? '',
                ))
            .toList(),
        steps: (json['steps'] as List<dynamic>)
            .map((step) => step as String)
            .toList(),
        minutes: json['minutes'] as int,
        kcal: json['kcal'] as int,
        isFavorite: json['isFavorite'] as bool? ?? false,
      );
}

/// Апп дотор өгөгдөл хадгалах, шинэчлэх хэсэг
class MockStore {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);
  static void notify() => version.value++;

  static List<String> fridge = ['Үхрийн мах', 'Гурил', 'Сонгино', 'Төмс'];

  static List<Recipe> _createDefaultRecipes() => [
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

  static List<Recipe> recipes = _createDefaultRecipes();

  static String _recipesKey(String phone) => 'recipes_$phone';

  static Future<void> loadPersisted(String phone) async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getString(_recipesKey(phone));
    if (saved == null || saved.isEmpty) {
      recipes = _createDefaultRecipes();
      notify();
      return;
    }

    try {
      final decoded = jsonDecode(saved) as List<dynamic>;
      recipes = decoded
          .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
          .toList();
      notify();
    } catch (_) {
      // Хадгалсан өгөгдөл эвдэрсэн бол анхдагч жорыг хадгална.
    }
  }

  static Future<void> _persistRecipes() async {
    final prefs = await SharedPreferences.getInstance();
    final phone = prefs.getString('user_phone');
    if (phone == null || phone.isEmpty) return;

    await prefs.setString(
      _recipesKey(phone),
      jsonEncode(recipes.map((recipe) => recipe.toJson()).toList()),
    );
  }

  static void addRecipe(Recipe recipe) {
    recipes.insert(0, recipe);
    notify();
    _persistRecipes();
  }

  static void updateRecipe(Recipe updatedRecipe) {
    final index = recipes.indexWhere(
      (r) => r.id == updatedRecipe.id,
    );

    if (index != -1) {
      recipes[index] = updatedRecipe;
      notify();
      _persistRecipes();
    }
  }

  static void toggleFavorite(Recipe r) {
    r.isFavorite = !r.isFavorite;
    notify();
    _persistRecipes();
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
