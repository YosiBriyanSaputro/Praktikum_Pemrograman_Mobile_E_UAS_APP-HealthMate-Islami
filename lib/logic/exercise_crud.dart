// lib/logic/exercise_crud.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseCrud {
  final user = FirebaseAuth.instance.currentUser;

  // ============================
  // 🔥 CREATE (Tambah Exercise)
  // ============================
  Future<void> addExercise({
    required String name,
    required int duration,
    required String time,
    required String date,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("exercises")
        .add({
      "name": name,
      "duration": duration,
      "time": time,
      "date": date,
      "created_at": Timestamp.now(),
    });
  }

  // ============================
  // 🔥 UPDATE (Edit Exercise)
  // ============================
  Future<void> updateExercise({
    required String id,
    required String name,
    required int duration,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("exercises")
        .doc(id)
        .update({
      "name": name,
      "duration": duration,
    });
  }

  // ============================
  // 🔥 DELETE (Hapus Exercise)
  // ============================
  Future<void> deleteExercise(String id) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("exercises")
        .doc(id)
        .delete();
  }
}
