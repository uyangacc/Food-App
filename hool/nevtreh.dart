import 'package:flutter/material.dart';
import 'main.dart';
import 'zagvar.dart';
import 'animated_welcome.dart';
import 'package:rive/rive.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool showPassword = false;
  bool showConfirmPassword = false;

  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void switchPage(bool login) {
    setState(() {
      isLogin = login;
      _formKey.currentState?.reset();
      passwordController.clear();
      confirmPasswordController.clear();
    });
  }

  void submit() {
    if (!_formKey.currentState!.validate()) return;

    // Одоогоор frontend туршилтын шилжилт.
    // Backend API холбох үед жинхэнэ нэвтрэлт хийнэ.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isLogin
              ? 'Нэвтрэх мэдээлэл шалгагдлаа!'
              : 'Бүртгэлийн мэдээлэл шалгагдлаа!',
        ),
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const Shell(),
      ),
    );
  }

  Widget inputField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    bool password = false,
    bool confirm = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    final hidden = password
        ? !showPassword
        : confirm
            ? !showConfirmPassword
            : false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: hidden,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.muted),
            suffixIcon: password || confirm
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        if (password) {
                          showPassword = !showPassword;
                        } else {
                          showConfirmPassword = !showConfirmPassword;
                        }
                      });
                    },
                    icon: Icon(
                      hidden ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.muted,
                    ),
                  )
                : null,
            filled: true,
            fillColor: AppColors.bg,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 17,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(
                color: AppColors.muted.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  // ... бэлтгэл код, state болон inputField функцууд хэвээрээ байна ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 25,
            ),
            child: Column(
              children: [
                // --- RIVE АНИМАЦИЙГ ЭНД НЭМНЭ ---
                SizedBox(
                  height: 300, // Өндрийг нь өөрийн хүссэнээр тохируулж болно
                  child: RiveAnimation.asset(
                    'assets/13321-25212-auth-teddy.riv', // Assets хавтас дахь файлын зам
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),
                // ----------------------------------

                // Form card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(23),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 20,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLogin ? 'Тавтай морил!' : 'Бүртгэл үүсгэх',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.ink,
                        ),
                      ),

                      // ... үлдэх форм болон бусад хэсгүүд хэвээрээ ажиллана ...

                      const SizedBox(height: 7),

                      Text(
                        isLogin
                            ? 'Өөрийн бүртгэлээр нэвтэрнэ үү.'
                            : 'Мэдээллээ оруулан бүртгүүлээрэй.',
                        style: const TextStyle(
                          color: AppColors.muted,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 25),

                      // Tab buttons
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: AppColors.bg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          children: [
                            _tabButton('Нэвтрэх', true),
                            _tabButton('Бүртгүүлэх', false),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!isLogin) ...[
                              inputField(
                                label: 'Нэр',
                                hint: 'Нэрээ оруулна уу',
                                icon: Icons.person_outline,
                                controller: nameController,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Нэрээ оруулна уу';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                            ],
                            inputField(
                              label: 'Утасны дугаар',
                              hint: 'Утасны дугаараа оруулна уу',
                              icon: Icons.phone_outlined,
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Утасны дугаараа оруулна уу';
                                }
                                if (!RegExp(r'^\+?\d{8,15}$').hasMatch(value)) {
                                  return 'Зөв утасны дугаар оруулна уу';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 18),
                            inputField(
                              label: 'Нууц үг',
                              hint: 'Нууц үгээ оруулна уу',
                              icon: Icons.lock_outline,
                              controller: passwordController,
                              password: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Нууц үгээ оруулна уу';
                                }
                                if (value.length < 6) {
                                  return 'Нууц үг 6-аас дээш тэмдэгттэй байна';
                                }
                                return null;
                              },
                            ),
                            if (isLogin)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Нууц үг сэргээх үйлдлийг дараа холбоно.',
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Нууц үг мартсан?',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              )
                            else ...[
                              const SizedBox(height: 18),
                              inputField(
                                label: 'Нууц үг давтах',
                                hint: 'Нууц үгээ дахин оруулна уу',
                                icon: Icons.lock_reset,
                                controller: confirmPasswordController,
                                confirm: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Нууц үгээ давтаж оруулна уу';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Нууц үг таарахгүй байна';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 18),
                            ],
                            const SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: FilledButton(
                                onPressed: submit,
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                child: Text(
                                  isLogin ? 'Нэвтрэх' : 'Бүртгүүлэх',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                Text(
                  'Хоол хийх дуртай хүн бүрт зориулав ❤️',
                  style: TextStyle(
                    color: AppColors.muted.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _tabButton(String title, bool loginTab) {
    final selected = isLogin == loginTab;

    return Expanded(
      child: GestureDetector(
        onTap: () => switchPage(loginTab),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? AppColors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(11),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: selected ? AppColors.primary : AppColors.muted,
            ),
          ),
        ),
      ),
    );
  }
}
