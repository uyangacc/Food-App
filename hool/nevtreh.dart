import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
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

  // State Machine-ийн нэр (Rive файл доторх State Machine нэр, ихэвчлэн "Login Machine" эсвэл үндсэн нь байна)
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

  // Хэрэглэгч input дээр дарж бичих үед нүдний харааг удирдах
  void _onFocusChanged(bool hasFocus, {bool isPassword = false}) {
    _isFocus?.value = hasFocus;
    _isPrivateField?.value = isPassword;
  }

  void _onTextChanged(String value, {bool isPassword = false}) {
    if (isPassword) {
      // Нууц үг бичиж байхад гараараа нүдээ таглах анимаци руу шилжих
      _isPrivateField?.value = true;
    } else {
      // Энгийн text бичихэд үсгийн тоогоор нүд нь хөдлөх (numLook)
      _numLook?.value = value.length.toDouble() * 2;
    }
  }

  void submit() {
    if (!_formKey.currentState!.validate()) {
      _failTrigger?.value = true; // Алдаа гарвал уурлах анимаци
      return;
    }

    _successTrigger?.value = true; // Амжилттай бол баярлах анимаци

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Shell()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 25),
            child: Column(
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

                        // Утасны дугаар input
                        Focus(
                          onFocusChange: (hasFocus) =>
                              _onFocusChanged(hasFocus, isPassword: false),
                          child: TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            onChanged: (v) =>
                                _onTextChanged(v, isPassword: false),
                            decoration: InputDecoration(
                              hintText: 'Утасны дугаар',
                              prefixIcon: const Icon(Icons.phone_outlined),
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

                        // Нууц үг input (Энд дархад баавгай гараараа нүдээ таглана)
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

                        // Нэвтрэх товч
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: FilledButton(
                            onPressed: submit,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: Text(isLogin ? 'Нэвтрэх' : 'Бүртгүүлэх',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w800)),
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
