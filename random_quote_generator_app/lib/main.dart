import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:random_quote_generator_app/Services/hive_service.dart';
import 'package:random_quote_generator_app/ViewModels/quote_view_model.dart';
import 'package:random_quote_generator_app/views/quote_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveService.initHive();

  runApp(
    ChangeNotifierProvider(
      create: (_) => QuoteViewModel(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Random Quote Generator',
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const QuoteScreen(),
    );
  }
}
