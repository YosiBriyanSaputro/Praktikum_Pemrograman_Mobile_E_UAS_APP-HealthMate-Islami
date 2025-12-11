// lib/services/food_api_service.dart

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../models/food_model.dart';

class FoodApiService {
  // =====================================================
  // 🚀 Ambil Data Rekomendasi Makanan dari TheMealDB
  // =====================================================
  Future<List<FoodModel>> getRecommendedMeals() async {
    try {
      final url = Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/search.php?s=chicken",
      );

      final res = await http.get(url);

      if (res.statusCode == 200) {
        final json = jsonDecode(res.body);

        if (json["meals"] == null) return [];

        final List meals = json["meals"];

        // random
        meals.shuffle(Random());

        // parsing JSON → FoodModel
        return meals.take(6).map((m) {
          return FoodModel.fromJson(m);
        }).toList();
      }
    } catch (e) {
      // bisa tambah logger jika diperlukan
    }

    return [];
  }
}
