import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WaterCrud {
  final user = FirebaseAuth.instance.currentUser;

  // Load jumlah gelas hari ini
  Future<int> loadCups(String today) async {
    final ref = FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("water")
        .doc(today);

    final doc = await ref.get();
    return doc.exists ? (doc["cups"] as int? ?? 0) : 0;
  }

  // Simpan jumlah gelas
  Future<void> saveCups(String today, int count) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("water")
        .doc(today)
        .set({"cups": count});
  }
}
