import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/water_motivation_model.dart';

class WaterApiService {
  Future<WaterMotivation> getMotivation() async {
    try {
      final url = Uri.parse("https://zenquotes.io/api/random");
      final res = await http.get(url);

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return WaterMotivation.fromJson(data[0]);
      }
    } catch (_) {}

    return WaterMotivation(
      quote: "Minum air bantu tubuh tetap segar.",
      author: "Health Bot",
    );
  }
}
