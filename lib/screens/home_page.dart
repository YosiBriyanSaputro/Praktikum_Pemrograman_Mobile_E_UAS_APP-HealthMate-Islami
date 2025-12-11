import 'package:flutter/material.dart';

// logic
import '../logic/quran_logic.dart';

// model
import '../models/quran_verse_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final QuranLogic _logic = QuranLogic();

  String ayat = "Memuat ayat...";
  String arti = "Memuat terjemahan...";
  String surah = "";

  @override
  void initState() {
    super.initState();
    _loadAyat();
  }

  Future<void> _loadAyat() async {
    final result = await _logic.fetchAyat();

    setState(() {
      ayat = result.ayat;
      arti = result.arti;
      surah = result.surah;
    });
  }

  // ============================
  // 🔥 MENU BUTTON BARU
  // ============================
  Widget _menuButton(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark ? Colors.grey.shade900 : Colors.white,
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.black12,
              blurRadius: 8,
              spreadRadius: 1,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 30, color: Colors.teal),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================
  // 🔥 UI
  // ============================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------- Sapaan --------
              Text(
                'Assalamu’alaikum,',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Semoga harimu penuh keberkahan 🌙',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary.withOpacity(0.7),
                ),
              ),

              const SizedBox(height: 20),

              // ===================================================
              // 🔥 CARD AYAT QUR'AN BARU — GRADIENT
              // ===================================================
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: isDark
                        ? [
                            Colors.teal.shade800,
                            Colors.teal.shade600,
                          ]
                        : [
                            Colors.teal.shade200,
                            Colors.teal.shade100,
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          isDark ? Colors.black54 : Colors.teal.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ayat,
                            style: const TextStyle(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            arti,
                            style: const TextStyle(fontSize: 14, height: 1.4),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            surah,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset('assets/logo.png', height: 50),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // ------ TITLE MENU ------
              Text(
                'Menu Cepat',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),

              const SizedBox(height: 12),

              // ===================================================
              // 🔥 GRID MENU — NEW DESIGN
              // ===================================================
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1.15,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _menuButton(
                      context, Icons.local_drink, 'Water Tracker', '/water'),
                  _menuButton(
                      context, Icons.restaurant, 'Food Tracker', '/food'),
                  _menuButton(context, Icons.fitness_center, 'Exercise',
                      '/exercise'),
                  _menuButton(
                      context, Icons.note_alt, 'Catatan Pribadi', '/notes'),
                ],
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
