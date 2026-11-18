import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'ogogdol.dart';
import 'zagvar.dart';
import 'nevtreh.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = 'Хоол сонирхогч';
  String bio = 'Өдөр бүр шинэ амт, шинэ санаа.';

  // Профайлын мэдээлэл засах
  void _editProfile() {
    final nameController = TextEditingController(text: userName);
    final bioController = TextEditingController(text: bio);

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Профайл засах'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Нэр',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: bioController,
              decoration: const InputDecoration(
                labelText: 'Танилцуулга',
                prefixIcon: Icon(Icons.edit_note),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Болих'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                if (nameController.text.trim().isNotEmpty) {
                  userName = nameController.text.trim();
                }
                bio = bioController.text.trim();
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Хадгалах'),
          ),
        ],
      ),
    );
  }

  // Дуртай жорууд
  void _showFavorites() {
    final favorites =
        MockStore.recipes.where((recipe) => recipe.isFavorite).toList();

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.bg,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '❤️ Дуртай жорууд',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 16),
              if (favorites.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 48,
                          color: AppColors.muted,
                        ),
                        SizedBox(height: 10),
                        Text('Одоогоор дуртай жор байхгүй байна.'),
                      ],
                    ),
                  ),
                )
              else
                Flexible(
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: favorites.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final recipe = favorites[index];

                      return Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: AppColors.sky,
                            child: Icon(
                              Icons.restaurant,
                              color: AppColors.primary,
                            ),
                          ),
                          title: Text(
                            recipe.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(recipe.category),
                          trailing: const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Тохиргооны мэдээлэл
  void _showInfo(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Хаах'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Гарах уу?'),
        content: const Text('Та бүртгэлээс гарахдаа итгэлтэй байна уу?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Болих'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Гарах'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) return;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access');
    await prefs.remove('refresh');
    await prefs.remove('user_phone');
    await prefs.remove('user_name');

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthPage()),
      (route) => false,
    );
  }

  Widget _settingTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      leading: Icon(
        icon,
        color: iconColor ?? AppColors.primary,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        color: AppColors.muted,
      ),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        elevation: 0,
        title: const Text(
          'Миний профайл',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            onPressed: _editProfile,
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Профайл засах',
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: ValueListenableBuilder<int>(
        valueListenable: MockStore.version,
        builder: (context, version, child) {
          final favoriteCount =
              MockStore.recipes.where((r) => r.isFavorite).length;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
            children: [
              // Профайлын үндсэн хэсэг
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppColors.sky,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 3,
                        ),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 55,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      bio,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.muted,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.sky,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('🌱'),
                          SizedBox(width: 7),
                          Text(
                            'Шинэхэн тогооч',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Дуртай жорын тоо
                    InkWell(
                      onTap: _showFavorites,
                      borderRadius: BorderRadius.circular(18),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.10),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.redAccent,
                                size: 25,
                              ),
                            ),
                            const SizedBox(width: 14),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Дуртай жор',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    'Хадгалсан жоруудаа харах',
                                    style: TextStyle(
                                      color: AppColors.muted,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '$favoriteCount',
                              style: const TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w800,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.muted,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // Тохиргоо
              const Padding(
                padding: EdgeInsets.only(left: 4, bottom: 12),
                child: Text(
                  'Тохиргоо',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  children: [
                    _settingTile(
                      icon: Icons.person_outline,
                      title: 'Хувийн мэдээлэл',
                      onTap: _editProfile,
                    ),
                    const Divider(height: 1, indent: 55),
                    _settingTile(
                      icon: Icons.notifications_none,
                      title: 'Мэдэгдэл',
                      onTap: () => _showInfo(
                        'Мэдэгдэл',
                        'Мэдэгдлийн тохиргоог удахгүй нэмнэ.',
                      ),
                    ),
                    const Divider(height: 1, indent: 55),
                    _settingTile(
                      icon: Icons.palette_outlined,
                      title: 'Гадаад үзэмж',
                      onTap: () => _showInfo(
                        'Гадаад үзэмж',
                        'Өнгө болон загварын тохиргоог удахгүй нэмнэ.',
                      ),
                    ),
                    const Divider(height: 1, indent: 55),
                    _settingTile(
                      icon: Icons.info_outline,
                      title: 'Аппын тухай',
                      onTap: () => _showInfo(
                        'Аппын тухай',
                        'Хоолны жор — Өдөр бүр шинэ амт, шинэ санаа.',
                      ),
                    ),
                    const Divider(height: 1, indent: 55),
                    _settingTile(
                      icon: Icons.logout,
                      iconColor: Colors.redAccent,
                      title: 'Гарах',
                      onTap: _logout,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Урам өгөх хэсэг
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.sky,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  children: [
                    Text(
                      '🍳',
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '“Сайн хоол хийхийн тулд\nэхлээд дуртай байх хэрэгтэй.”',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
