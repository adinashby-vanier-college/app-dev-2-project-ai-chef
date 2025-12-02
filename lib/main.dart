import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_ai_app/screens/landing_page.dart';
import 'services/gemini_service.dart';
import 'cubit/recipe_cubit.dart';
import 'home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "assets/config.env");

  runApp(
    BlocProvider(
      create: (context) => RecipeCubit(GeminiService()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe Suggestions',
      home: LandingPage(),
    );
  }
}