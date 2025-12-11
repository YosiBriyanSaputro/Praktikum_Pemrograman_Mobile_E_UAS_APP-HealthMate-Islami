// lib/models/exercise_model.dart

class ExerciseModel {
  final String name;
  final String difficulty;
  final String instructions;

  ExerciseModel({
    required this.name,
    required this.difficulty,
    required this.instructions,
  });

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      name: json["name"] ?? "Unknown",
      difficulty: json["difficulty"] ?? "Unknown",
      instructions: json["instructions"] ?? "No description available",
    );
  }
}
