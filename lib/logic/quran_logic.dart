import '../models/quran_verse_model.dart';
import '../services/quran_api_service.dart';

class QuranLogic {
  final QuranApiService _service = QuranApiService();

  Future<QuranVerse> fetchAyat() async {
    final verse = await _service.getRandomAyat();

    if (verse == null) {
      return QuranVerse(
        ayat: "Tidak dapat memuat ayat.",
        arti: "Silakan coba lagi.",
        surah: "",
      );
    }

    return verse;
  }
}
