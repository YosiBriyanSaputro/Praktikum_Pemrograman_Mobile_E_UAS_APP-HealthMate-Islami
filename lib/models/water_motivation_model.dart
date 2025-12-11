class WaterMotivation {
  final String quote;
  final String author;

  WaterMotivation({
    required this.quote,
    required this.author,
  });

  factory WaterMotivation.fromJson(Map<String, dynamic> json) {
    return WaterMotivation(
      quote: json["q"] ?? "Tetap hidrasi dan semangat!",
      author: json["a"] ?? "Unknown",
    );
  }

  @override
  String toString() => "“$quote” — $author";
}


