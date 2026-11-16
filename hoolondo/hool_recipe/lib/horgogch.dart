import 'package:flutter/material.dart';
import 'ogogdol.dart';
import 'jor_detail_page.dart';
import 'zagvar.dart';

class FridgePage extends StatefulWidget {
  const FridgePage({super.key});
  @override
  State<FridgePage> createState() => _FridgePageState();
}

class _FridgePageState extends State<FridgePage> {
  final _input = TextEditingController();

  void _addCustom() {
    if (_input.text.trim().isEmpty) return;
    MockStore.toggleFridge(_input.text.trim());
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: MockStore.version,
      builder: (_, __, ___) {
        final fridgeKeys = MockStore.fridge.map(normalizeIngredient).toSet();

        // Бүх жорын орцууд + хөргөгчинд байгаа орцууд
        final suggestions = <String>{
          ...MockStore.fridge,
          for (final r in MockStore.recipes)
            for (final i in r.ingredients) i.name,
        }.toList();

        // Тохирох хоолуудыг шүүх
        final matched = MockStore.recipes
            .map((r) {
              final have =
                  r.ingredients.where((i) => fridgeKeys.contains(i.key)).length;
              return (recipe: r, have: have, total: r.ingredients.length);
            })
            .where((x) => x.have > 0)
            .toList()
          ..sort((a, b) => (b.have / b.total).compareTo(a.have / a.total));

        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
            children: [
              const Text('Миний хөргөгч',
                  style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink)),
              const SizedBox(height: 4),
              const Text(
                  'Гэртээ байгаа орцоо нэмээд хийж болох хоолоо хараарай.',
                  style: TextStyle(color: AppColors.muted)),
              const SizedBox(height: 16),
              // Шинэ орц бичиж нэмэх хэсэг
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      onSubmitted: (_) => _addCustom(),
                      decoration: InputDecoration(
                        hintText: 'Өөрт байгаа орц бичих (жнь: Өндөг)...',
                        prefixIcon: const Icon(Icons.kitchen,
                            color: AppColors.primaryDark),
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.onPrimary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: _addCustom,
                      child: const Text('Нэмэх',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Text('Сонгосон орц (${MockStore.fridge.length})',
                  style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                      color: AppColors.ink)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final item in suggestions)
                    FilterChip(
                      label: Text(item),
                      selected: fridgeKeys.contains(normalizeIngredient(item)),
                      showCheckmark: false,
                      avatar: fridgeKeys.contains(normalizeIngredient(item))
                          ? const Icon(Icons.check,
                              size: 16, color: AppColors.onPrimary)
                          : null,
                      onSelected: (_) => MockStore.toggleFridge(item),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.white,
                      side: BorderSide.none,
                      labelStyle: TextStyle(
                        color: AppColors.ink,
                        fontWeight:
                            fridgeKeys.contains(normalizeIngredient(item))
                                ? FontWeight.w800
                                : FontWeight.w600,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                ],
              ),
              const SizedBox(height: 28),
              const Text('Хийж болох хоол',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink)),
              const SizedBox(height: 12),
              if (matched.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                        'Дээрээс орц сонгоход тохирох хоол энд харагдана.',
                        style: TextStyle(color: AppColors.muted)),
                  ),
                )
              else
                for (final m in matched)
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RecipeDetailPage(recipe: m.recipe)),
                    ),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: cardShadow,
                      ),
                      child: Row(
                        children: [
                          RecipeThumb(
                              recipe: m.recipe,
                              width: 70,
                              height: 70,
                              emojiSize: 34),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(m.recipe.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16)),
                                    ),
                                    if (m.have == m.total)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFDDF1E4),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: const Text('Бүх орц байна',
                                            style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w800,
                                                color: AppColors.ok)),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: m.have / m.total,
                                    minHeight: 7,
                                    backgroundColor: AppColors.sky,
                                    color: m.have == m.total
                                        ? AppColors.ok
                                        : AppColors.primary,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                    '${m.have}/${m.total} орц бүрдсэн · ${m.recipe.minutes} мин',
                                    style: const TextStyle(
                                        color: AppColors.muted, fontSize: 12)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
          ),
        );
      },
    );
  }
}
