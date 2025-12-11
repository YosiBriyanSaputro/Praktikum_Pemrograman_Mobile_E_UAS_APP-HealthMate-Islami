import 'package:flutter/material.dart';

// Logic
import '../logic/login_logic.dart';

// Model
import '../models/user_login_model.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginLogic _logic = LoginLogic();

  // Controllers
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  // ===========================================================================
  // 🔑 LOGIN HANDLER
  // ===========================================================================
  Future<void> _login() async {
    final data = UserLoginModel(
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );

    setState(() => _loading = true);

    final error = await _logic.login(data);

    if (mounted) {
      if (error == null) {
        // Berhasil
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        // Gagal
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error)));
      }
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // 🌟 BUILD UI – PREMIUM DESIGN
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🌈 BACKGROUND GRADIENT (Light & Dark mode)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    Colors.black,
                    Colors.grey.shade900,
                  ]
                : [
                    Colors.teal.shade100,
                    Colors.white,
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ------------------------------------------------------------
                  // 🟢 LOGO
                  // ------------------------------------------------------------
                  Image.asset('assets/logo.png', height: 90),
                  const SizedBox(height: 12),

                  // ------------------------------------------------------------
                  // ✨ TITLE
                  // ------------------------------------------------------------
                  Text(
                    'Selamat Datang 🙌',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Masuk untuk melihat progress kesehatan harianmu',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ------------------------------------------------------------
                  // 🧊 LOGIN CARD (Glass Effect)
                  // ------------------------------------------------------------
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(.05)
                          : Colors.white.withOpacity(.85),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(.1)
                            : Colors.teal.withOpacity(.2),
                      ),
                    ),

                    child: Column(
                      children: [
                        // ------------------------------------------------------
                        // ✉️ EMAIL FIELD
                        // ------------------------------------------------------
                        TextField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: "Email",
                            prefixIcon: const Icon(Icons.email),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withOpacity(.05)
                                : Colors.teal.shade50,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ------------------------------------------------------
                        // 🔒 PASSWORD FIELD
                        // ------------------------------------------------------
                        TextField(
                          controller: passController,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: const Icon(Icons.lock),
                            filled: true,
                            fillColor: isDark
                                ? Colors.white.withOpacity(.05)
                                : Colors.teal.shade50,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ------------------------------------------------------
                        // 🟩 LOGIN BUTTON
                        // ------------------------------------------------------
                        ElevatedButton(
                          onPressed: _loading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.teal.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Masuk",
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),

                        const SizedBox(height: 12),

                        // ------------------------------------------------------
                        // 🔄 REGISTER LINK
                        // ------------------------------------------------------
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, '/register'),
                          child: const Text("Belum punya akun? Daftar"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
