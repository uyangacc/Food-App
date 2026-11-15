import 'package:flutter/material.dart';
import 'recipes_page.dart';
import 'horgogch.dart';
import 'profile.dart';
import 'zagvar.dart';
import 'nevtreh.dart';
import 'jor_nemeh.dart';
import 'package:native_liquid_glass_navbar/native_liquid_glass_navbar.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const HoolApp());
}

class HoolApp extends StatelessWidget {
  const HoolApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Хоолны жор Design',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
        ),
        scaffoldBackgroundColor: AppColors.bg,
      ),
      home: const AuthPage(),
    );
  }
}

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _currentIndex = 0;

  void _openCreateModal() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecipeFormPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Stack(
        children: [
          // Үндсэн хуудас солигдох хэсэг (Доороо navigation bar-д дарагдахгүй зайтай)
          Positioned.fill(
            child: IndexedStack(
              index: _currentIndex,
              children: const [
                RecipesPage(),
                FridgePage(),
                FavoritesPage(),
                ProfilePage(),
              ],
            ),
          ),

          // Доод талын Liquid Glass Navbar-ийг дээд давхаргад (Stack) байрлуулах
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: NativeLiquidGlassNavBar(
              currentIndex: _currentIndex,
              tintColor: AppColors.primary,
              unselectedColor: Colors.grey,
              iconSize: 24.0,
              fontSize: 11.0,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              actionButton: NativeLiquidGlassActionButton.icon(
                icon: Icons.add_rounded,
                onTap: _openCreateModal,
              ),
              tabs: const [
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Жорууд',
                  icon: Icons.restaurant_menu_rounded,
                ),
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Хөргөгч',
                  icon: Icons.kitchen_rounded,
                ),
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Дуртай',
                  icon: Icons.favorite_rounded,
                ),
                NativeLiquidGlassNavBarItem.icon(
                  label: 'Профайл',
                  icon: Icons.person_rounded,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildLoading() {
  return Center(
    child: Lottie.asset(
      'assets/animations/loading.json',
      width: 150,
      height: 150,
      fit: BoxFit.fill,
    ),
  );
}

