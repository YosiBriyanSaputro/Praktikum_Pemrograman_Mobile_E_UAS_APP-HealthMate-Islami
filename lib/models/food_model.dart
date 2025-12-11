// lib/models/food_model.dart

class FoodModel {
  final String name;
  final String image;
  final String category;
  final String area;
  final String instructions;

  FoodModel({
    required this.name,
    required this.image,
    required this.category,
    required this.area,
    required this.instructions,
  });

  factory FoodModel.fromJson(Map<String, dynamic> json) {
    return FoodModel(
      name: json["strMeal"] ?? "Unknown",
      image: json["strMealThumb"] ?? "",
      category: json["strCategory"] ?? "",
      area: json["strArea"] ?? "",
      instructions: json["strInstructions"] ?? "",
    );
  }
}
