import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const CineScopeApp());
}

class CineScopeApp extends StatelessWidget {
  const CineScopeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CineScope',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFE50914),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF141414),
        fontFamily: 'Roboto',
      ),

      // ─── NAMED ROUTES ───────────────────────────────────────────────────────
      // Định nghĩa tập trung tất cả route của ứng dụng.
      // Đây là "bản đồ" điều hướng — mỗi String key ứng với 1 màn hình.
      // ────────────────────────────────────────────────────────────────────────
      initialRoute: '/',
      routes: {
        '/':          (context) => const SplashScreen(),
        '/home':      (context) => const HomeScreen(),
        '/detail':    (context) => const MovieDetailScreen(),
        // '/favorites': (context) => const FavoritesScreen(),
        // '/profile':   (context) => const ProfileScreen(),
      },
    );
  }
}