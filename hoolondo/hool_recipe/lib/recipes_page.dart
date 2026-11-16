import 'package:flutter/material.dart';
import 'ogogdol.dart';
import 'jor_detail_page.dart';
import 'jor_nemeh.dart';
import 'zagvar.dart';

class RecipesPage extends StatefulWidget {
  const RecipesPage({super.key});
  @override
  State<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  String selectedCategory = 'Бүгд';
  String query = '';

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MockStore.version,
      builder: (_, __, ___) {
        final items = MockStore.recipes.where((r) {
          final matchCat =
              selectedCategory == 'Бүгд' || r.category == selectedCategory;
          final matchQ = query.isEmpty ||
              r.name.toLowerCase().contains(query.toLowerCase());
          return matchCat && matchQ;
        }).toList();

        return Scaffold(
          backgroundColor: AppColors.bg,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RecipeFormPage()),
            ),
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.onPrimary,
            icon: const Icon(Icons.add),
            label: const Text('Жор нэмэх',
                style: TextStyle(fontWeight: FontWeight.w800)),
          ),
          body: Column(
            children: [
              // Дээд толгой хэсэг
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
                decoration: const BoxDecoration(
                  gradient: yellowGradient,
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(32)),
                ),
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      const Text('Сайн байна уу!',
                          style: TextStyle(
                              fontSize: 14, color: Color(0xFF5B4410))),
                      const SizedBox(height: 2),
                      const Text('Өнөөдөр юу хийж идэх вэ?',
                          style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w800,
                              color: AppColors.onPrimary)),
                      const SizedBox(height: 14),
                      TextField(
                        onChanged: (v) => setState(() => query = v),
                        decoration: InputDecoration(
                          hintText: 'Жорын нэрээр хайх...',
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.primaryDark),
                          filled: true,
                          fillColor: AppColors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              // Ангиллын сонголт
              SizedBox(
                height: 40,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  children: [
                    for (final c in ['Бүгд', ...categories])
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label:
                              Text('${c == 'Бүгд' ? '🍽️' : emojiOf(c)}  $c'),
                          selected: selectedCategory == c,
                          showCheckmark: false,
                          onSelected: (_) =>
                              setState(() => selectedCategory = c),
                          selectedColor: AppColors.primary,
                          backgroundColor: AppColors.white,
                          side: BorderSide.none,
                          labelStyle: TextStyle(
                            color: AppColors.ink,
                            fontWeight: selectedCategory == c
                                ? FontWeight.w800
                                : FontWeight.w600,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // Жорын карт жагсаалт
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 90),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 230,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    childAspectRatio: 0.76,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) => RecipeCard(recipe: items[i]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MockStore.version,
      builder: (_, __, ___) {
        final items = MockStore.recipes.where((r) => r.isFavorite).toList();
        return SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text('Дуртай жорууд',
                    style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink)),
              ),
              Expanded(
                child: items.isEmpty
                    ? const Center(
                        child: Text('Дуртай жор одоогоор алга',
                            style: TextStyle(color: AppColors.muted)))
                    : GridView.builder(
                        padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 230,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.76,
                        ),
                        itemCount: items.length,
                        itemBuilder: (_, i) => RecipeCard(recipe: items[i]),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const RecipeCard({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 800),
            reverseTransitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (context, animation, secondaryAnimation) {
              return RecipeDetailPage(recipe: recipe);
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: cardShadow,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Hero(
                      tag: 'recipe-${recipe.id}',
                      child: RecipeThumb(
                        recipe: recipe,
                        emojiSize: 52,
                        radius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => MockStore.toggleFavorite(recipe),
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.white.withOpacity(0.9),
                        child: Icon(
                          recipe.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          size: 18,
                          color: recipe.isFavorite ? Colors.red : AppColors.ink,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(recipe.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: AppColors.ink)),
                  const SizedBox(height: 2),
                  Text('${recipe.category} · ${recipe.level}',
                      style: const TextStyle(
                          color: AppColors.muted, fontSize: 12)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.schedule,
                          size: 14, color: AppColors.primaryDark),
                      const SizedBox(width: 3),
                      Text('${recipe.minutes} мин',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 10),
                      const Icon(Icons.local_fire_department_outlined,
                          size: 14, color: AppColors.primaryDark),
                      const SizedBox(width: 3),
                      Text('${recipe.kcal} ккал',
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
