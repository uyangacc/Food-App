import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'ogogdol.dart';
import 'zagvar.dart';

class RecipeFormPage extends StatefulWidget {
  final Recipe? recipe;

  const RecipeFormPage({super.key, this.recipe});

  @override
  State<RecipeFormPage> createState() => _RecipeFormPageState();
}

class _RecipeFormPageState extends State<RecipeFormPage> {
  final _name = TextEditingController();
  final _desc = TextEditingController();
  final _minutes = TextEditingController();
  final _kcal = TextEditingController();
  final _steps = TextEditingController();
  final _ingName = TextEditingController();
  final _ingAmount = TextEditingController();

  String category = categories.first;
  String level = levels.first;

  final List<Ingredient> addedIngredients = [];

  String imageData = '';
  Uint8List? previewBytes;
  bool picking = false;

  bool get isEditing => widget.recipe != null;

  @override
  void initState() {
    super.initState();

    final recipe = widget.recipe;

    if (recipe != null) {
      _name.text = recipe.name;
      _desc.text = recipe.description;
      _minutes.text = recipe.minutes.toString();
      _kcal.text = recipe.kcal.toString();
      _steps.text = recipe.steps.join('\n');

      category = recipe.category;
      level = recipe.level;

      addedIngredients.addAll(recipe.ingredients);

      imageData = recipe.imageData;
      previewBytes = recipe.imageBytes;
    } else {
      _minutes.text = '30';
      _kcal.text = '400';
    }
  }

  Future<void> _pickImage() async {
    try {
      final xFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (xFile == null || !mounted) return;

      setState(() => picking = true);

      final bytes = await xFile.readAsBytes();
      final decoded = img.decodeImage(bytes);

      if (decoded != null && mounted) {
        final jpg = Uint8List.fromList(
          img.encodeJpg(decoded, quality: 80),
        );

        setState(() {
          previewBytes = jpg;
          imageData = base64Encode(jpg);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Зураг сонгоход алдаа гарлаа')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => picking = false);
      }
    }
  }

  void _addIngredient() {
    if (_ingName.text.trim().isEmpty) return;

    setState(() {
      addedIngredients.add(
        Ingredient(
          _ingName.text.trim(),
          _ingAmount.text.trim(),
        ),
      );

      _ingName.clear();
      _ingAmount.clear();
    });
  }

  void _save() {
    if (_name.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Хоолны нэрээ оруулна уу')),
      );
      return;
    }

    final stepList = _steps.text
        .split('\n')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    final oldRecipe = widget.recipe;

    final updatedRecipe = Recipe(
      id: oldRecipe?.id ?? DateTime.now().millisecondsSinceEpoch,
      name: _name.text.trim(),
      category: category,
      description:
          _desc.text.trim().isEmpty ? 'Гэрийн амтат хоол.' : _desc.text.trim(),
      level: level,
      ingredients: List<Ingredient>.from(
        addedIngredients.isEmpty
            ? [const Ingredient('Үндсэн орц', 'Тохирох хэмжээгээр')]
            : addedIngredients,
      ),
      steps: stepList.isEmpty ? ['Орцуудаа бэлтгэн амталж болгоно.'] : stepList,
      minutes: int.tryParse(_minutes.text) ?? 30,
      kcal: int.tryParse(_kcal.text) ?? 400,
      imageData: imageData,
      isFavorite: oldRecipe?.isFavorite ?? false,
    );

    if (isEditing) {
      MockStore.updateRecipe(updatedRecipe);
    } else {
      MockStore.addRecipe(updatedRecipe);
    }

    Navigator.pop(context);
  }

  InputDecoration _dec(String label, {String? hint}) => InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: AppColors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      );

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    _minutes.dispose();
    _kcal.dispose();
    _steps.dispose();
    _ingName.dispose();
    _ingAmount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Жор засах' : 'Шинэ жор нэмэх',
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
        children: [
          GestureDetector(
            onTap: picking ? null : _pickImage,
            child: Container(
              height: 180,
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.sky,
                borderRadius: BorderRadius.circular(22),
              ),
              child: previewBytes != null
                  ? Image.memory(
                      previewBytes!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.add_a_photo_outlined,
                          size: 42,
                          color: AppColors.primaryDark,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Өөрийн зургийг оруулах бол энд дарна уу',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _name,
            decoration: _dec('Хоолны нэр', hint: 'Жишээ: Цуйван'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: category,
                  decoration: _dec('Ангилал'),
                  items: [
                    for (final c in categories)
                      DropdownMenuItem(
                        value: c,
                        child: Text('${emojiOf(c)} $c'),
                      ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => category = v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: level,
                  decoration: _dec('Түвшин'),
                  items: [
                    for (final l in levels)
                      DropdownMenuItem(
                        value: l,
                        child: Text(l),
                      ),
                  ],
                  onChanged: (v) {
                    if (v != null) setState(() => level = v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _minutes,
                  keyboardType: TextInputType.number,
                  decoration: _dec('Хугацаа (мин)'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _kcal,
                  keyboardType: TextInputType.number,
                  decoration: _dec('Илчлэг (ккал)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _desc,
            maxLines: 2,
            decoration: _dec('Тайлбар'),
          ),
          const SizedBox(height: 22),
          const Text(
            'Орц найрлага нэмэх',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextField(
                  controller: _ingName,
                  decoration: _dec('Орц', hint: 'Гурил'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextField(
                  controller: _ingAmount,
                  decoration: _dec('Хэмжээ', hint: '300 г'),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                ),
                onPressed: _addIngredient,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          if (addedIngredients.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                for (final ing in addedIngredients)
                  Chip(
                    label: Text(
                      '${ing.name} ${ing.amount.isNotEmpty ? "(${ing.amount})" : ""}',
                    ),
                    backgroundColor: AppColors.sky,
                    side: BorderSide.none,
                    onDeleted: () {
                      setState(() => addedIngredients.remove(ing));
                    },
                  ),
              ],
            ),
          ],
          const SizedBox(height: 22),
          const Text(
            'Хийх дараалал',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _steps,
            minLines: 4,
            maxLines: 8,
            decoration: _dec(
              'Алхмууд',
              hint: 'Нэг мөрөнд нэг алхам бичнэ үү',
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            height: 56,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              onPressed: _save,
              child: Text(
                isEditing ? 'Өөрчлөлт хадгалах' : 'Жор хадгалах',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
