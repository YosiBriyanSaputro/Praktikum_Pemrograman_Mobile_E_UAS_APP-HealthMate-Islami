import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesCrud {
  final user = FirebaseAuth.instance.currentUser;

  // ADD
  Future<void> addNote(String text) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("notes")
        .add({
      "text": text,
      "created_at": Timestamp.now(),
      "updated_at": Timestamp.now(),
    });
  }

  // UPDATE
  Future<void> updateNote(String docId, String text) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("notes")
        .doc(docId)
        .update({
      "text": text,
      "updated_at": Timestamp.now(),
    });
  }

  // DELETE
  Future<void> deleteNote(String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("notes")
        .doc(docId)
        .delete();
  }
}
