import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/water_report_model.dart';

class WaterReportService {
  final col = FirebaseFirestore.instance;

  Future<List<WaterReportModel>> getReport({
    required String uid,
    required List<String> dates,
  }) async {
    final snap = await col
        .collection("users")
        .doc(uid)
        .collection("water")
        .get();

    final map = { for (var d in dates) d : 0 };

    for (var e in snap.docs) {
      final date = e.id;
      map[date] = (e["cups"] as int?) ?? 0;
    }

    return dates.map((d) {
      return WaterReportModel(
        date: d,
        cups: map[d]!,
      );
    }).toList();
  }
}
