import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/food_report_model.dart';

class FoodReportService {
  final col = FirebaseFirestore.instance;

  Future<List<FoodReportModel>> getReport({
    required String uid,
    required List<String> dates,
  }) async {
    final snap = await col
        .collection("users")
        .doc(uid)
        .collection("foods")
        .where("date", isGreaterThanOrEqualTo: dates.first)
        .orderBy("date")
        .get();

    final map = { for (var d in dates) d : 0 };

    for (var e in snap.docs) {
      final d = e["date"];
      map[d] = (map[d] ?? 0) + (e["calories"] as int? ?? 0);
    }

    return dates.map((d) {
      return FoodReportModel(
        date: d,
        totalCalories: map[d]!,
      );
    }).toList();
  }
}
