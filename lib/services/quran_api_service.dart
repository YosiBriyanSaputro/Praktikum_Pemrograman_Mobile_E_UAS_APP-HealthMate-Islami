import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/quran_verse_model.dart';

class QuranApiService {

  Future<QuranVerse?> getRandomAyat() async {
    try {
      // Random ayat
      final randomRes = await http.get(
        Uri.parse("https://api.alquran.cloud/v1/ayah/random"),
      );

      if (randomRes.statusCode != 200) return null;

      final randomData = jsonDecode(randomRes.body);
      final int number = randomData["data"]["number"];

      // Ambil ayat & terjemahan
      final finalRes = await http.get(
        Uri.parse(
          "https://api.alquran.cloud/v1/ayah/$number/editions/quran-uthmani,id.indonesian",
        ),
      );

      if (finalRes.statusCode != 200) return null;

      final data = jsonDecode(finalRes.body);

      return QuranVerse(
        ayat: data["data"][0]["text"],
        arti: data["data"][1]["text"],
        surah:
            "${data["data"][0]["surah"]["englishName"]} • Ayat ${data["data"][0]["numberInSurah"]}",
      );
    } catch (_) {
      return null;
    }
  }
}
