import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/note_model.dart';

class NotesService {
  final user = FirebaseAuth.instance.currentUser;

  Stream<List<NoteModel>> getNotesStream() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .collection("notes")
        .orderBy("created_at", descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((d) => NoteModel.fromDoc(d)).toList());
  }
}
