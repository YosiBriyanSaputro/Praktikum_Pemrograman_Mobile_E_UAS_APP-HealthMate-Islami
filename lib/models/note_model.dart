import 'package:cloud_firestore/cloud_firestore.dart';

class NoteModel {
  final String id;
  final String text;
  final Timestamp createdAt;
  final Timestamp updatedAt;

  NoteModel({
    required this.id,
    required this.text,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NoteModel.fromDoc(DocumentSnapshot doc) {
    return NoteModel(
      id: doc.id,
      text: doc["text"] ?? "",
      createdAt: doc["created_at"] ?? Timestamp.now(),
      updatedAt: doc["updated_at"] ?? Timestamp.now(),
    );
  }
}
