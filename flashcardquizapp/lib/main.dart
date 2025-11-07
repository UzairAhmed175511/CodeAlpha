import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/flashcard_viewmodel.dart';
import 'views/flashcard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => FlashcardViewModel(),
      child: const FlashcardApp(),
    ),
  );
}

class FlashcardApp extends StatelessWidget {
  const FlashcardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<FlashcardViewModel>(
      builder: (context, viewModel, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flashcard Quiz App',
          themeMode: viewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          // 🌤 LIGHT THEME
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
            scaffoldBackgroundColor: Colors.grey[100],
            cardColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.black87),
              bodyMedium: TextStyle(color: Colors.black87),
            ),
          ),

          // 🌙 DARK THEME
          darkTheme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.tealAccent,
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(
              0xFF121212,
            ), // proper dark background
            cardColor: const Color(0xFF1E1E1E),
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            textTheme: const TextTheme(
              bodyLarge: TextStyle(color: Colors.white),
              bodyMedium: TextStyle(color: Colors.white70),
            ),
          ),

          home: const FlashcardScreen(),
        );
      },
    );
  }
}
