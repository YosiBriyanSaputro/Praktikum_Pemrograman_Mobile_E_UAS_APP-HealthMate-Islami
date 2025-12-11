import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_register_model.dart';
import '../models/user_login_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // LOGIN
  Future<User?> login(UserLoginModel data) async {
    final res = await _auth.signInWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );
    return res.user;
  }

  // REGISTER
  Future<User?> register(UserRegisterModel data) async {
    final res = await _auth.createUserWithEmailAndPassword(
      email: data.email,
      password: data.password,
    );

    // Update display name
    await res.user?.updateDisplayName(data.name);

    return res.user;
  }
}
