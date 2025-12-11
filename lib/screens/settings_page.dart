import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Theme Logic
import '../logic/theme_logic.dart';

// Services
import '../services/settings_service.dart';

// Model
import '../models/user_model.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsService _service = SettingsService();

  bool isDark = themeNotifier.value == ThemeMode.dark;

  UserModel get currentUser {
    final u = FirebaseAuth.instance.currentUser;
    return UserModel(name: u?.displayName, email: u?.email);
  }

  // ===========================================================================
  // ✏️ EDIT NAMA
  // ===========================================================================
  Future<void> _editName() async {
    final controller = TextEditingController(text: currentUser.name ?? "");

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Nama"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: "Nama Baru",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(c),
          ),
          ElevatedButton(
            onPressed: () async {
              final newName = controller.text.trim();
              if (newName.isEmpty) return;

              Navigator.pop(c);

              try {
                await _service.updateName(newName);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Nama berhasil diperbarui!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal memperbarui: $e")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 🔒 GANTI PASSWORD
  // ===========================================================================
  Future<void> _changePassword() async {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Ganti Password"),
        content: TextField(
          controller: controller,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: "Password Baru",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(c),
          ),
          ElevatedButton(
            onPressed: () async {
              final newPass = controller.text.trim();
              if (newPass.length < 6) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Minimal 6 karakter")),
                );
                return;
              }

              Navigator.pop(c);

              try {
                await _service.updatePassword(newPass);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Password berhasil diperbarui!")),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Gagal: $e")),
                );
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 🚪 LOGOUT CONFIRMATION
  // ===========================================================================
  void _logoutDialog() {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Konfirmasi Logout'),
        content: const Text('Yakin keluar dari akun ini?'),
        actions: [
          TextButton(
            child: const Text('Batal'),
            onPressed: () => Navigator.pop(c),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
            onPressed: () async {
              Navigator.pop(c);
              await _service.logout();

              Navigator.pushNamedAndRemoveUntil(context, '/', (_) => false);
            },
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // 🌙 BUILD UI – Modern & Premium
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final user = currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // -----------------------------------------------------------------
            // 👤 PROFILE CARD (Gradient Premium + Glass)
            // -----------------------------------------------------------------
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor.withOpacity(.15),
                    Theme.of(context).primaryColor.withOpacity(.05),
                  ],
                ),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withOpacity(.2),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: const AssetImage('assets/profile.jpg'),
                ),
                title: Text(
                  user.name ?? "Pengguna",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
                subtitle: Text(user.email ?? "-"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _editName,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // -----------------------------------------------------------------
            // 🌙 DARK MODE SWITCH
            // -----------------------------------------------------------------
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).cardColor,
              ),
              child: SwitchListTile(
                value: isDark,
                title: const Text("Mode Gelap"),
                subtitle: const Text("Ubah tema aplikasi"),
                secondary: const Icon(Icons.dark_mode),
                onChanged: (v) {
                  setState(() => isDark = v);
                  themeNotifier.value = v ? ThemeMode.dark : ThemeMode.light;
                },
              ),
            ),

            const SizedBox(height: 16),

            // -----------------------------------------------------------------
            // LIST SETTINGS ITEMS
            // -----------------------------------------------------------------
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.lock),
                    title: const Text("Ganti Password"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: _changePassword,
                  ),
                  const Divider(height: 0),
                  ListTile(
                    leading: const Icon(Icons.info_outline),
                    title: const Text("Tentang Aplikasi"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: "HealthMate Islami",
                        applicationVersion: "1.0.0",
                        applicationIcon: Image.asset('assets/logo.png', height: 40),
                        children: const [
                          SizedBox(height: 10),
                          Text("Aplikasi kesehatan dengan sentuhan Islami:"),
                          Text("• Water Tracker"),
                          Text("• Food Tracker"),
                          Text("• Exercise Tracker"),
                          Text("• Motivasi Qur'an"),
                          Text("• Laporan Kesehatan"),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            const Spacer(),

            // -----------------------------------------------------------------
            // 🔴 BUTTON LOGOUT
            // -----------------------------------------------------------------
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
                backgroundColor: Colors.red.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: _logoutDialog,
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
