// lib/services/exercise_api_service.dart

import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

import '../models/exercise_model.dart';

class ExerciseApiService {
  final String apiKey = "SO1bMimAHItxZ/dRY8B/5Q==v1iM04RoLcfJwX07"; // pindah dari UI ke service

  Future<List<ExerciseModel>> getRecommendations() async {
    try {
      final url = Uri.parse(
        "https://api.api-ninjas.com/v1/exercises?type=cardio",
      );

      final response = await http.get(
        url,
        headers: {"X-Api-Key": apiKey},
      );

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);

        if (data.isEmpty) {
          return [
            ExerciseModel(
              name: "Unknown",
              difficulty: "N/A",
              instructions: "No description available.",
            )
          ];
        }

        // random shuffle
        data.shuffle(Random());

        // Parsing JSON ke Model
        return data.take(6).map((item) {
          return ExerciseModel.fromJson(item);
        }).toList();
      }
    } catch (e) {
      // Bisa tambah log
    }

    // fallback kalau error
    return [
      ExerciseModel(
        name: "Unknown",
        difficulty: "N/A",
        instructions: "No description available.",
      )
    ];
  }
}
