import 'package:flutter/material.dart';
import 'dart:typed_data';

import '../services/gemini_image_generator.dart';

class RecipeStepsScreen extends StatelessWidget {
  final List<String> recipeSteps;
  final GeminiImageGenerator _imageGenerator = GeminiImageGenerator();

  RecipeStepsScreen({super.key, required this.recipeSteps});

  @override
  Widget build(BuildContext context) {

    final cleanSteps = recipeSteps.where((s) {
      final text = s.trim().toLowerCase();
      return text.length > 5 && !text.contains("instructions");
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Cooking Guide")),
      body: ListView.builder(
        itemCount: cleanSteps.length,
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.all(12),
            child: Column(
              children: [
                FutureBuilder<Uint8List?>(
                  future: _imageGenerator.textToImage(cleanSteps[index]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const SizedBox(
                          height: 200,
                          child: Center(child: CircularProgressIndicator())
                      );
                    }
                    if (snapshot.hasData && snapshot.data != null) {
                      return Image.memory(snapshot.data!, fit: BoxFit.cover);
                    }
                    return const Icon(Icons.broken_image, size: 100);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    cleanSteps[index],
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}