import 'package:flutter/material.dart';

// Service, Logic & Model
import '../services/notes_service.dart';
import '../logic/notes_crud.dart';
import '../models/note_model.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final NotesService _notesService = NotesService();
  final NotesCrud _notesCrud = NotesCrud();

  // Palet warna note (otomatis fleksibel untuk light/dark)
  final List<Color> lightColors = const [
    Color(0xFFFFF3E0),
    Color(0xFFE3F2FD),
    Color(0xFFFCE4EC),
    Color(0xFFE8F5E9),
    Color(0xFFF3E5F5),
    Color(0xFFFFEBEE),
  ];

  final List<Color> darkColors = const [
    Color(0xFF3E2723),
    Color(0xFF1A237E),
    Color(0xFF4A148C),
    Color(0xFF1B5E20),
    Color(0xFF311B92),
    Color(0xFF880E4F),
  ];

  // -----------------------------------------------------------
  // 🔥 Tambah Catatan
  // -----------------------------------------------------------
  void _addNote() {
    final c = TextEditingController();

    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Tambah Catatan'),
        content: TextField(
          controller: c,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Tulis catatan...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(d),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (c.text.isEmpty) return;
              await _notesCrud.addNote(c.text);
              Navigator.pop(d);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // 🔥 Edit Catatan
  // -----------------------------------------------------------
  void _editNote(String docId, String oldText) {
    final c = TextEditingController(text: oldText);

    showDialog(
      context: context,
      builder: (d) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text('Edit Catatan'),
        content: TextField(
          controller: c,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Edit catatan...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(d), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              if (c.text.isEmpty) return;
              await _notesCrud.updateNote(docId, c.text);
              Navigator.pop(d);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------
  // 🔥 Hapus Catatan
  // -----------------------------------------------------------
  void _deleteNote(String docId) async {
    await _notesCrud.deleteNote(docId);
  }

  String _formatDate(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year}";
  }

  // -----------------------------------------------------------
  // ⭐ UI NOTE CARD PREMIUM
  // -----------------------------------------------------------
  Widget _noteCard(NoteModel note, int index, bool isDark) {
    final bgColor = (isDark ? darkColors : lightColors)[index % 6];

    return GestureDetector(
      onTap: () => _editNote(note.id, note.text),
      onLongPress: () => _deleteNote(note.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: bgColor.withOpacity(isDark ? 0.8 : 1),
          borderRadius: BorderRadius.circular(16),

          // Shadow premium
          boxShadow: [
            BoxShadow(
              color: isDark ? Colors.black54 : Colors.black26,
              blurRadius: 6,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text catatan
            Expanded(
              child: Text(
                note.text,
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.3,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.fade,
              ),
            ),

            const SizedBox(height: 10),

            // Tanggal update
            Text(
              _formatDate(note.updatedAt.toDate()),
              style: TextStyle(
                fontSize: 11,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------------------------------------
  // ⭐ BUILD UI UTAMA
  // -----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Catatan"),
      ),

      // STREAM FIRESTORE
      body: StreamBuilder<List<NoteModel>>(
        stream: _notesService.getNotesStream(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final notes = snap.data!;

          if (notes.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada catatan.",
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // GRID VIEW PREMIUM
          return GridView.builder(
            padding: const EdgeInsets.all(14),
            itemCount: notes.length,
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: 0.85,
            ),
            itemBuilder: (context, i) => _noteCard(notes[i], i, isDark),
          );
        },
      ),

      // BUTTON TAMBAH CATATAN
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNote,
        backgroundColor: Colors.teal,
        icon: const Icon(Icons.add),
        label: const Text("Catatan"),
      ),
    );
  }
}
