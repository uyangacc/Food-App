import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:lottie/lottie.dart';
import 'main.dart';
import 'zagvar.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;
  bool showPassword = false;
  bool isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  // Rive Controller болон Inputs
  StateMachineController? _controller;
  SMIInput<bool>? _isFocus;
  SMIInput<bool>? _isPrivateField;
  SMIInput<double>? _numLook;
  SMIInput<bool>? _successTrigger;
  SMIInput<bool>? _failTrigger;

  final String stateMachineName = "Login Machine";

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Rive файл ачаалагдах үед input-уудыг холбох
  void _onRiveInit(Artboard artboard) {
    final controller =
        StateMachineController.fromArtboard(artboard, stateMachineName);
    if (controller != null) {
      artboard.addController(controller);
      _controller = controller;
      _isFocus = controller.findInput<bool>('isFocus');
      _isPrivateField = controller.findInput<bool>('isPrivateField');
      _numLook = controller.findInput<double>('numLook');
      _successTrigger = controller.findInput<bool>('successTrigger');
      _failTrigger = controller.findInput<bool>('failTrigger');
    }
  }

  void _onFocusChanged(bool hasFocus, {bool isPassword = false}) {
    _isFocus?.value = hasFocus;
    _isPrivateField?.value = isPassword;
  }

  void _onTextChanged(String value, {bool isPassword = false}) {
    if (isPassword) {
      _isPrivateField?.value = true;
    } else {
      _numLook?.value = value.length.toDouble() * 2;
    }
  }

  // Товч дарахад ажиллах логик
  void submit() async {
    if (!_formKey.currentState!.validate()) {
      _failTrigger?.value = true; // Алдаа гарвал уурлах анимаци
      return;
    }

    _successTrigger?.value = true; // Амжилттай бол баярлах анимаци

    // 1. Lottie анимаци гаргах
    setState(() {
      isLoading = true;
    });

    // 2. 1.5 секунд хүлээх
    await Future.delayed(const Duration(milliseconds: 1500));

    // 3. Үндсэн хуудас руу шилжих
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Shell()),
    );
  }

  // Lottie ачаалах анимаци харуулах функц
  Widget buildLoading() {
    return Center(
      child: Lottie.asset(
        'assets/animation/Spoon_Loader.json',
        width: 150,
        height: 150,
        fit: BoxFit.fill,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
            child: isLoading
                ? buildLoading()
                : Column(
                    children: [
                      // --- RIVE ТЕДДИ АНИМАЦИ ---
                      SizedBox(
                        height: 200,
                        child: RiveAnimation.asset(
                          'assets/13321-25212-auth-teddy.riv',
                          onInit: _onRiveInit,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Form card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(23),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 20,
                              offset: const Offset(0, 7),
                            ),
                          ],
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLogin ? 'Тавтай морил!' : 'Бүртгэл үүсгэх',
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.ink),
                              ),
                              const SizedBox(height: 20),

                              // Хэрэв бүртгүүлэх горимд байвал "Нэр" хэсэг гарч ирнэ
                              if (!isLogin) ...[
                                TextFormField(
                                  controller: nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Таны нэр',
                                    prefixIcon:
                                        const Icon(Icons.person_outline),
                                    filled: true,
                                    fillColor: AppColors.bg,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (v) =>
                                      (!isLogin && (v == null || v.isEmpty))
                                          ? 'Нэрээ оруулна уу'
                                          : null,
                                ),
                                const SizedBox(height: 18),
                              ],

                              // Утасны дугаар input
                              Focus(
                                onFocusChange: (hasFocus) => _onFocusChanged(
                                    hasFocus,
                                    isPassword: false),
                                child: TextFormField(
                                  controller: phoneController,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (v) =>
                                      _onTextChanged(v, isPassword: false),
                                  decoration: InputDecoration(
                                    hintText: 'Утасны дугаар',
                                    prefixIcon:
                                        const Icon(Icons.phone_outlined),
                                    filled: true,
                                    fillColor: AppColors.bg,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (v) => (v == null || v.isEmpty)
                                      ? 'Дугаараа оруулна уу'
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 18),

                              // Нууц үг input
                              Focus(
                                onFocusChange: (hasFocus) =>
                                    _onFocusChanged(hasFocus, isPassword: true),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: !showPassword,
                                  onChanged: (v) =>
                                      _onTextChanged(v, isPassword: true),
                                  decoration: InputDecoration(
                                    hintText: 'Нууц үг',
                                    prefixIcon: const Icon(Icons.lock_outline),
                                    suffixIcon: IconButton(
                                      icon: Icon(showPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off),
                                      onPressed: () => setState(
                                          () => showPassword = !showPassword),
                                    ),
                                    filled: true,
                                    fillColor: AppColors.bg,
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15),
                                        borderSide: BorderSide.none),
                                  ),
                                  validator: (v) => (v == null || v.length < 6)
                                      ? 'Нууц үг богино байна'
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 25),

                              // Нэвтрэх / Бүртгүүлэх үндсэн товч
                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: FilledButton(
                                  onPressed: submit,
                                  style: FilledButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                  child: Text(
                                      isLogin ? 'Нэвтрэх' : 'Бүртгүүлэх',
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800)),
                                ),
                              ),
                              const SizedBox(height: 15),

                              // Нэвтрэх болон Бүртгүүлэх хооронд шилжүүлэх товч
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLogin = !isLogin;
                                    });
                                  },
                                  child: Text(
                                    isLogin
                                        ? 'Бүртгэлгүй юу? Бүртгүүлэх'
                                        : 'Аль хэдийн бүртгэлтэй юу? Нэвтрэх',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
