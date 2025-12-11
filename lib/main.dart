import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// FIREBASE
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

// screens
import 'screens/welcome_page.dart';
import 'screens/login_page.dart';
import 'screens/register_page.dart';
import 'screens/home_page.dart';
import 'screens/settings_page.dart';
import 'screens/water_tracker_page.dart';
import 'screens/food_tracker_page.dart';
import 'screens/exercise_tracker_page.dart';
import 'screens/notes_page.dart';
import 'screens/report_page.dart';

// IMPORT THEME CONTROLLER YANG ASLI
import 'logic/theme_logic.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HealthMateApp());
}

class HealthMateApp extends StatelessWidget {
  const HealthMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier, // PAKAI YANG DARI theme_logic.dart
      builder: (context, currentMode, _) {
        final light = ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
          textTheme: GoogleFonts.poppinsTextTheme(),
          scaffoldBackgroundColor: Colors.teal.shade50,
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.grey,
          ),
        );

        final dark = ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            selectedItemColor: Colors.teal,
            unselectedItemColor: Colors.white70,
          ),
        );

        return MaterialApp(
          title: 'HealthMate Islami',
          debugShowCheckedModeBanner: false,
          theme: light,
          darkTheme: dark,
          themeMode: currentMode,

          home: const AuthWrapper(),

          routes: {
            '/login': (c) => const LoginPage(),
            '/register': (c) => const RegisterPage(),
            '/home': (c) => const MainScreen(),
            '/settings': (c) => const SettingsPage(),
            '/water': (c) => const WaterTrackerPage(),
            '/food': (c) => const FoodTrackerPage(),
            '/exercise': (c) => const ExerciseTrackerPage(),
            '/notes': (c) => const NotesPage(),
            '/reports': (c) => const ReportPage(),
          },
        );
      },
    );
  }
}


// =============================
// 🔥 AUTH WRAPPER
// =============================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData) {
          return const MainScreen();
        }

        return const WelcomePage();
      },
    );
  }
}


// =============================
// 🔥 MAIN SCREEN (BOTTOM NAV)
// =============================
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),        // 0
    ReportPage(),      // 1
    SettingsPage(),    // 2
  ];

  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: 5,
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.teal,
        unselectedItemColor: Colors.grey.shade600,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_graph),
            label: 'Laporan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
    );
  }
}
