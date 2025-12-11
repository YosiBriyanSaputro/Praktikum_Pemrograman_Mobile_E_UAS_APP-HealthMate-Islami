import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/exercise_report_model.dart';

class ExerciseReportService {
  final col = FirebaseFirestore.instance;

  Future<List<ExerciseReportModel>> getReport({
    required String uid,
    required List<String> dates,
  }) async {
    final snap = await col
        .collection("users")
        .doc(uid)
        .collection("exercises")
        .where("date", isGreaterThanOrEqualTo: dates.first)
        .orderBy("date")
        .get();

    final map = { for (var d in dates) d : 0 };

    for (var e in snap.docs) {
      final d = e["date"];
      map[d] = (map[d] ?? 0) + (e["duration"] as int? ?? 0);
    }

    return dates.map((d) {
      return ExerciseReportModel(
        date: d,
        totalDuration: map[d]!,
      );
    }).toList();
  }
}
