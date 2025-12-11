import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// SERVICE & LOGIC
import '../services/exercise_api_service.dart';
import '../logic/exercise_crud.dart';
import '../models/exercise_model.dart';

class ExerciseTrackerPage extends StatefulWidget {
  const ExerciseTrackerPage({super.key});

  @override
  State<ExerciseTrackerPage> createState() => _ExerciseTrackerPageState();
}

class _ExerciseTrackerPageState extends State<ExerciseTrackerPage> {
  final user = FirebaseAuth.instance.currentUser;

  // Service
  final ExerciseApiService api = ExerciseApiService();
  final ExerciseCrud crud = ExerciseCrud();

  // ===========================================================
  // ⭐ POPUP REKOMENDASI EXERCISE (UI SUPER PREMIUM)
  // ===========================================================
  void _showRecommendations() async {
    final List<ExerciseModel> list = await api.getRecommendations();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Container(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Column(
                  children: [
                    // Drag indicator
                    Container(
                      width: 50,
                      height: 6,
                      margin: const EdgeInsets.only(top: 10, bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),

                    const Text(
                      "🔥 Rekomendasi Aktivitas",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final e = list[i];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  Text(
                                    "Level: ${e.difficulty}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                    ),
                                  ),

                                  const SizedBox(height: 12),

                                  Text(
                                    e.instructions,
                                    style: const TextStyle(height: 1.4),
                                  ),

                                  const SizedBox(height: 16),

                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _addExercise(prefill: e.name);
                                    },
                                    icon: const Icon(Icons.add),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.teal,
                                      minimumSize:
                                          const Size(double.infinity, 45),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    label: const Text("Tambahkan Aktivitas"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ===========================================================
  // ⭐ TAMBAH AKTIVITAS
  // ===========================================================
  void _addExercise({String prefill = ""}) {
    final nameC = TextEditingController(text: prefill);
    final durC = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Tambah Aktivitas"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameC,
                decoration: const InputDecoration(labelText: "Jenis Olahraga"),
              ),
              TextField(
                controller: durC,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Durasi (menit)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameC.text.isEmpty || durC.text.isEmpty) return;

                final now = DateTime.now();
                final date =
                    "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                final time = TimeOfDay.now().format(context);

                await crud.addExercise(
                  name: nameC.text,
                  duration: int.parse(durC.text),
                  date: date,
                  time: time,
                );

                if (mounted) Navigator.pop(context);
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================
  // ⭐ EDIT
  // ===========================================================
  void _editExercise(String id, String current, int dur) {
    final nameC = TextEditingController(text: current);
    final durC = TextEditingController(text: dur.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Aktivitas"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Jenis")),
            TextField(controller: durC, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: "Durasi")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              await crud.updateExercise(
                id: id,
                name: nameC.text,
                duration: int.parse(durC.text),
              );
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Simpan Perubahan"),
          )
        ],
      ),
    );
  }

  // ===========================================================
  // ⭐ DELETE
  // ===========================================================
  Future<void> _delete(String id) async => crud.deleteExercise(id);

  // ===========================================================
  // ⭐ UI UTAMA
  // ===========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Exercise Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: _showRecommendations,
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add),
        onPressed: () => _addExercise(),
      ),

      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(user!.uid)
            .collection("exercises")
            .orderBy("created_at", descending: true)
            .snapshots(),
        builder: (_, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snap.data!.docs;

          // Total durasi hari ini
          int total = list.fold<int>(
            0,
            (sum, e) => sum + (e["duration"] as int),
          );

          return Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                // ===================================================
                // ⭐ KARTU TOTAL DURASI
                // ===================================================
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    gradient: LinearGradient(
                      colors: [Colors.teal.shade300, Colors.teal.shade700],
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.fitness_center,
                          size: 40, color: Colors.white),
                      const SizedBox(width: 14),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Total Durasi Hari Ini",
                            style: TextStyle(color: Colors.white70),
                          ),
                          Text(
                            "$total menit",
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // ===================================================
                // ⭐ LIST AKTIVITAS
                // ===================================================
                Expanded(
                  child: list.isEmpty
                      ? const Center(
                          child: Text("Belum ada aktivitas.\nTambahkan dengan tombol +"),
                        )
                      : ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (_, i) {
                            final e = list[i];

                            return Card(
                              margin: const EdgeInsets.only(bottom: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(16),

                                // Ikon besar kiri
                                leading: Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.teal.shade100,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.run_circle,
                                      size: 30, color: Colors.teal),
                                ),

                                title: Text(
                                  e["name"],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),

                                subtitle: Text(
                                  "Durasi: ${e["duration"]} menit\n${e["time"]} • ${e["date"]}",
                                ),

                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blueAccent),
                                      onPressed: () => _editExercise(
                                        e.id,
                                        e["name"],
                                        e["duration"],
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.redAccent),
                                      onPressed: () => _delete(e.id),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
