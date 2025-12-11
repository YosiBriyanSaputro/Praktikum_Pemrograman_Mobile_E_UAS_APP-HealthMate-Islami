import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/water_motivation_model.dart';
import '../services/water_api_service.dart';
import '../logic/water_crud.dart';

class WaterTrackerPage extends StatefulWidget {
  const WaterTrackerPage({super.key});

  @override
  State<WaterTrackerPage> createState() => _WaterTrackerPageState();
}

class _WaterTrackerPageState extends State<WaterTrackerPage> {
  final user = FirebaseAuth.instance.currentUser;

  final int _goal = 8; // 8 gelas
  late String today;
  int _count = 0;

  // Motivation
  String _motivation = "“Tetap jaga kesehatan dan minum air hari ini!”";
  bool _loadingMotivation = false;

  final _api = WaterApiService();
  final _crud = WaterCrud();

  @override
  void initState() {
    super.initState();
    today = _getToday();

    _loadTodayData();
    _fetchMotivation();
  }

  String _getToday() {
    final now = DateTime.now();
    return "${now.year}-${_two(now.month)}-${_two(now.day)}";
  }

  String _two(int n) => n < 10 ? "0$n" : "$n";

  Future<void> _loadTodayData() async {
    final loaded = await _crud.loadCups(today);
    setState(() => _count = loaded);
  }

  Future<void> _saveCount() async {
    await _crud.saveCups(today, _count);
  }

  void _add() async {
    if (_count < _goal) {
      setState(() => _count++);
      await _saveCount();
    }
  }

  void _reset() async {
    setState(() => _count = 0);
    await _saveCount();
  }

  Future<void> _fetchMotivation() async {
    setState(() => _loadingMotivation = true);

    final WaterMotivation result = await _api.getMotivation();

    setState(() {
      _motivation = "“${result.quote}”\n— ${result.author}";
      _loadingMotivation = false;
    });
  }

  // =============================
  // 🔥 UI
  // =============================
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = _count / _goal;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Water Tracker'),
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              // ========================
              // 🔵 WATER ICON BESAR
              // ========================
              Container(
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.withOpacity(0.12),
                ),
                child: const Icon(
                  Icons.water_drop,
                  size: 70,
                  color: Colors.teal,
                ),
              ),

              const SizedBox(height: 18),

              Text(
                "Minum Air Hari Ini",
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                '$_count dari $_goal Gelas',
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 20),

              // ========================
              // 💧 WATER PROGRESS BAR
              // ========================
              Container(
                height: 22,
                decoration: BoxDecoration(
                  color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOut,
                      width: MediaQuery.of(context).size.width * progress,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            Colors.teal.shade400,
                            Colors.teal.shade600,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // ========================
              // 🔥 MOTIVATION CARD
              // ========================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: isDark
                      ? Colors.teal.shade900.withOpacity(0.3)
                      : Colors.teal.shade50,
                ),
                child: _loadingMotivation
                    ? const Center(child: CircularProgressIndicator())
                    : Column(
                        children: [
                          Text(
                            _motivation,
                            style: const TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: _fetchMotivation,
                            icon: const Icon(Icons.refresh),
                            label: const Text("Motivasi Baru"),
                          )
                        ],
                      ),
              ),

              const SizedBox(height: 30),

              // ========================
              // 🔘 BUTTON TAMBAH & RESET
              // ========================
              ElevatedButton.icon(
                onPressed: _add,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text(
                  'Tambah 1 Gelas',
                  style: TextStyle(fontSize: 16),
                ),
              ),

              const SizedBox(height: 12),

              OutlinedButton.icon(
                onPressed: _reset,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
