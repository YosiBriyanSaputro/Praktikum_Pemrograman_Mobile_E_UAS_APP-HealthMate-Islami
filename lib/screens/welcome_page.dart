import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Deteksi apakah sedang dark mode
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
                    Colors.teal.shade200,
                    Colors.white,
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ------------------------------------------------------------
                  // ✨ LOGO BESAR
                  // ------------------------------------------------------------
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isDark
                          ? Colors.white.withOpacity(.05)
                          : Colors.white.withOpacity(.8),
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(.1),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/logo.png',
                      height: 110,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ------------------------------------------------------------
                  // 🕌 TITLE & TAGLINE
                  // ------------------------------------------------------------
                  Text(
                    'HealthMate Islami',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Aplikasi pendamping kesehatan harian\nbernuansa Islami untuk hidup lebih seimbang.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      height: 1.4,
                      color: isDark ? Colors.grey[300] : Colors.grey[700],
                    ),
                  ),

                  const SizedBox(height: 35),

                  // ------------------------------------------------------------
                  // 🟩 START BUTTON
                  // ------------------------------------------------------------
                  ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      backgroundColor: Colors.teal.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 6,
                      shadowColor: Colors.teal.withOpacity(.4),
                    ),
                    child: const Text(
                      "Mulai Sekarang",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ------------------------------------------------------------
                  // 💬 SMALL TEXT
                  // ------------------------------------------------------------
                  Text(
                    "Mulailah perjalanan hidup sehatmu hari ini ✨",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
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
