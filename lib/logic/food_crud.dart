// lib/logic/food_crud.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FoodCrud {
  final user = FirebaseAuth.instance.currentUser;

  // =====================================================
  // 🚀 CREATE — Tambah Makanan
  // =====================================================
  Future<void> addFood({
    required String name,
    required int calories,
    required String date,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("foods")
        .add({
      "name": name,
      "calories": calories,
      "date": date,
      "created_at": Timestamp.now(),
    });
  }

  // =====================================================
  // 🚀 UPDATE — Edit Makanan
  // =====================================================
  Future<void> updateFood({
    required String id,
    required String name,
    required int calories,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("foods")
        .doc(id)
        .update({
      "name": name,
      "calories": calories,
    });
  }

  // =====================================================
  // 🚀 DELETE — Hapus Makanan
  // =====================================================
  Future<void> deleteFood(String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("foods")
        .doc(id)
        .delete();
  }
}
