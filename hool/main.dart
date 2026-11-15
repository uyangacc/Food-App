import 'package:flutter/material.dart';
import 'recipes_page.dart';
import 'horgogch.dart';
import 'profile.dart';
import 'zagvar.dart';
import 'nevtreh.dart';

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
  int tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: tab,
        children: const [
          RecipesPage(),
          FridgePage(),
          FavoritesPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) {
          setState(() => tab = i);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant_menu),
            label: 'Жорууд',
          ),
          NavigationDestination(
            icon: Icon(Icons.kitchen),
            label: 'Хөргөгч',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: 'Дуртай',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Профайл',
          ),
        ],
      ),
    );
  }
}
