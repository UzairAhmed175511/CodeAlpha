import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_quote_generator_app/Services/hive_service.dart';
import 'package:random_quote_generator_app/ViewModels/quote_view_model.dart';
import 'package:random_quote_generator_app/views/quote_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Hive before app runs
  await HiveService.initHive();

  // ✅ Run app with Provider
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => QuoteViewModel())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Random Quote Generator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const QuoteScreen(),
    );
  }
}
