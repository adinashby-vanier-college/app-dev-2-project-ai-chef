import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/landing_page.dart';
import 'services/gemini_service.dart';
import 'cubit/recipe_cubit.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from assets folder (mobile-safe)
  await dotenv.load(fileName: "assets/config.env");

  // Optional: print to confirm values
  print('API_KEY: ${dotenv.env['API_KEY']}');
  print('BASE_URL: ${dotenv.env['BASE_URL']}');
  print('MAPS_API_KEY: ${dotenv.env['MAPS_API_KEY']}');

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app with RecipeCubit
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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const LandingPage(),
    );
  }
}
