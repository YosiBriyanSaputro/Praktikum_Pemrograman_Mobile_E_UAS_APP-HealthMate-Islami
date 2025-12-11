import 'package:firebase_auth/firebase_auth.dart';

class SettingsService {
  final _auth = FirebaseAuth.instance;

  // Update display name
  Future<void> updateName(String newName) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await user.updateDisplayName(newName);
    await user.reload();
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await user.updatePassword(newPassword);
  }

  // Logout
  Future<void> logout() async {
    await _auth.signOut();
  }
}
