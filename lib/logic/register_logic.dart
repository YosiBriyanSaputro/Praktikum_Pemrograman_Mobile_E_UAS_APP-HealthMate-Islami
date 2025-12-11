import '../models/user_register_model.dart';
import '../services/auth_service.dart';

class RegisterLogic {
  final AuthService _service = AuthService();

  String? validate(UserRegisterModel data) {
    if (data.name.isEmpty ||
        data.email.isEmpty ||
        data.password.isEmpty) {
      return "Semua field harus diisi.";
    }

    if (!data.email.contains('@')) {
      return "Format email tidak valid.";
    }

    if (data.password.length < 6) {
      return "Password minimal 6 karakter.";
    }

    return null;
  }

  Future<String?> register(UserRegisterModel data) async {
    final error = validate(data);
    if (error != null) return error;

    try {
      await _service.register(data);
      return null; // sukses
    } catch (e) {
      final code = e.toString();

      if (code.contains("email-already-in-use")) {
        return "Email sudah digunakan.";
      }
      if (code.contains("invalid-email")) {
        return "Format email tidak valid.";
      }
      if (code.contains("weak-password")) {
        return "Password terlalu lemah.";
      }

      return "Gagal mendaftarkan akun.";
    }
  }
}
