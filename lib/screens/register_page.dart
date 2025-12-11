import 'package:flutter/material.dart';

// Logic & Model
import '../logic/register_logic.dart';
import '../models/user_register_model.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final RegisterLogic _logic = RegisterLogic();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();

  bool _obscure = true;
  bool _loading = false;

  // ===========================================================================
  // 🚀 REGISTER HANDLER
  // ===========================================================================
  Future<void> _register() async {
    final data = UserRegisterModel(
      name: nameController.text.trim(),
      email: emailController.text.trim(),
      password: passController.text.trim(),
    );

    setState(() => _loading = true);

    final error = await _logic.register(data);

    if (mounted) {
      if (error == null) {
        // Berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Akun berhasil dibuat! Silakan login.")),
        );
        Navigator.pop(context);
      } else {
        // Gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }

    setState(() => _loading = false);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // 🌟 BUILD UI – PREMIUM AESTHETIC
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // 🌈 GRADIENT BACKGROUND
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
                children: [
                  // ------------------------------------------------------------
                  // ✨ LOGO
                  // ------------------------------------------------------------
                  Image.asset('assets/logo.png', height: 90),
                  const SizedBox(height: 12),

                  // ------------------------------------------------------------
                  // 📌 TITLE
                  // ------------------------------------------------------------
                  Text(
                    'Buat Akun Baru',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 6),

                  Text(
                    'Mulai perjalanan hidup sehatmu ✨',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------------------
                  // 🧊 FORM CARD (Glass Effect)
                  // ------------------------------------------------------------
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(.05)
                          : Colors.white.withOpacity(.85),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withOpacity(.1)
                            : Colors.teal.withOpacity(.25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),

                    child: Column(
                      children: [
                        // ------------------------------------------------------
                        // 👤 NAMA LENGKAP
                        // ------------------------------------------------------
                        TextField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: "Nama Lengkap",
                            prefixIcon: const Icon(Icons.person),
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
                        // 🟩 REGISTER BUTTON
                        // ------------------------------------------------------
                        ElevatedButton(
                          onPressed: _loading ? null : _register,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(50),
                            backgroundColor: Colors.teal.shade700,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: _loading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Daftar',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),

                        const SizedBox(height: 10),

                        // ------------------------------------------------------
                        // 🔄 LINK KEMBALI
                        // ------------------------------------------------------
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Sudah punya akun? Masuk"),
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
