import '../models/user_login_model.dart';
import '../services/auth_service.dart';

class LoginLogic {
  final AuthService _service = AuthService();

  String? validate(UserLoginModel data) {
    if (data.email.isEmpty || data.password.isEmpty) {
      return "Email dan password wajib diisi.";
    }
    return null;
  }

  Future<String?> login(UserLoginModel data) async {
    final error = validate(data);
    if (error != null) return error;

    try {
      final user = await _service.login(data);
      if (user != null) return null;
      return "Login gagal.";
    } catch (e) {
      if (e == "user-not-found") return "Akun tidak ditemukan.";
      if (e == "wrong-password") return "Password salah.";
      if (e == "invalid-email") return "Format email tidak valid.";
      return "Terjadi kesalahan.";
    }
  }
}
