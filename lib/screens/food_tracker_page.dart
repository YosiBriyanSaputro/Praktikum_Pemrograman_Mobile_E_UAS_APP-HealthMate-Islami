import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// SERVICE & LOGIC
import '../services/food_api_service.dart';
import '../logic/food_crud.dart';
import '../models/food_model.dart';

class FoodTrackerPage extends StatefulWidget {
  const FoodTrackerPage({super.key});

  @override
  State<FoodTrackerPage> createState() => _FoodTrackerPageState();
}

class _FoodTrackerPageState extends State<FoodTrackerPage> {
  final _foodService = FoodApiService();
  final _foodCrud = FoodCrud();
  final user = FirebaseAuth.instance.currentUser;

  // SEARCH & FILTER
  String _search = "";
  String _filter = "Tanggal Terbaru";

  final List<String> filterItems = [
    "Tanggal Terbaru",
    "Kalori Tertinggi",
    "Kalori Terendah",
  ];

  // ============================================================
  // POPUP REKOMENDASI MAKANAN
  // ============================================================
  void _showMealRecommendation() async {
    final list = await _foodService.getRecommendedMeals();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          child: Container(
            color: Theme.of(context).cardColor,
            child: DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              builder: (_, controller) {
                return Column(
                  children: [
                    const SizedBox(height: 10),
                    Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const Text(
                      "🍽 Rekomendasi Makanan Sehat",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.builder(
                        controller: controller,
                        itemCount: list.length,
                        itemBuilder: (_, i) {
                          final FoodModel m = list[i];

                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 10),
                            elevation: 3,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16),
                                  ),
                                  child: m.image.isEmpty
                                      ? Container(
                                          height: 160,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.fastfood, size: 60),
                                        )
                                      : Image.network(
                                          m.image,
                                          height: 180,
                                          width: double.infinity,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(14),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        m.name,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        "Kategori: ${m.category} • Asal: ${m.area}",
                                        style: TextStyle(
                                            color: Colors.grey.shade700,
                                            fontSize: 13),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        m.instructions,
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                      const SizedBox(height: 12),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton.icon(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.teal,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                            _addFood(prefill: m.name);
                                          },
                                          icon: const Icon(Icons.add),
                                          label: const Text("Tambahkan ke daftar"),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  // ============================================================
  // POPUP TAMBAH & EDIT MAKANAN
  // ============================================================
  void _addFood({String prefill = ""}) {
    final nameC = TextEditingController(text: prefill);
    final calC = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Tambah Makanan${prefill.isNotEmpty ? ' (Rekomendasi)' : ''}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: calC, decoration: const InputDecoration(labelText: "Kalori"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              if (nameC.text.isEmpty || calC.text.isEmpty) return;

              final now = DateTime.now();
              final date = "${now.year}-${now.month}-${now.day}";

              await _foodCrud.addFood(
                name: nameC.text,
                calories: int.parse(calC.text),
                date: date,
              );

              if (mounted) Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  void _editFood(String id, String currentName, int currentCal) {
    final nameC = TextEditingController(text: currentName);
    final calC = TextEditingController(text: currentCal.toString());

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Makanan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameC, decoration: const InputDecoration(labelText: "Nama")),
            TextField(controller: calC, decoration: const InputDecoration(labelText: "Kalori"), keyboardType: TextInputType.number),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () async {
              await _foodCrud.updateFood(
                id: id,
                name: nameC.text,
                calories: int.parse(calC.text),
              );

              if (mounted) Navigator.pop(context);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Food Tracker"),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome),
            onPressed: _showMealRecommendation,
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () => _addFood(),
        child: const Icon(Icons.add),
      ),

      body: Column(
        children: [
          // ====================================================
          // 🔎 BEAUTIFUL SEARCH BAR
          // ====================================================
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey.shade800
                    : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14),
              ),
              child: TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  border: InputBorder.none,
                  hintText: "Cari makanan...",
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onChanged: (v) => setState(() => _search = v.toLowerCase()),
              ),
            ),
          ),

          // ====================================================
          // 🎛 BEAUTIFUL FILTER CHIPS
          // ====================================================
          SizedBox(
            height: 46,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 16),
              children: filterItems.map((item) {
                final bool selected = item == _filter;

                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ChoiceChip(
                    label: Text(item),
                    selected: selected,
                    selectedColor: Colors.teal,
                    backgroundColor: Colors.grey.shade300,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
                    onSelected: (_) => setState(() => _filter = item),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user!.uid)
                  .collection("foods")
                  .orderBy("created_at", descending: true)
                  .snapshots(),
              builder: (_, snap) {
                if (!snap.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                List docs = snap.data!.docs;

                // SEARCH FILTER
                docs = docs.where((f) {
                  return f["name"]
                      .toString()
                      .toLowerCase()
                      .contains(_search);
                }).toList();

                // SORTING FILTER
                if (_filter == "Kalori Tertinggi") {
                  docs.sort((a, b) =>
                      (b["calories"] as int).compareTo(a["calories"]));
                } else if (_filter == "Kalori Terendah") {
                  docs.sort((a, b) =>
                      (a["calories"] as int).compareTo(b["calories"]));
                }

                int total =
                    docs.fold(0, (sum, f) => sum + (f["calories"] as int));

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      // TOTAL CARD
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [Colors.teal.shade300, Colors.teal.shade600],
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_fire_department,
                                size: 40, color: Colors.white),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Total Kalori",
                                    style: TextStyle(color: Colors.white70)),
                                Text(
                                  "$total kcal",
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // LIST MAKANAN
                      Expanded(
                        child: docs.isEmpty
                            ? const Center(child: Text("Tidak ada data yang cocok"))
                            : ListView.builder(
                                itemCount: docs.length,
                                itemBuilder: (_, i) {
                                  final f = docs[i];

                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 3,
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(14),
                                      leading: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.teal.shade100,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: const Icon(Icons.restaurant),
                                      ),
                                      title: Text(
                                        f["name"],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                          "${f["calories"]} kcal • ${f["date"]}"),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () => _editFood(
                                                f.id,
                                                f["name"],
                                                f["calories"]),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () =>
                                                _foodCrud.deleteFood(f.id),
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
          ),
        ],
      ),
    );
  }
}
