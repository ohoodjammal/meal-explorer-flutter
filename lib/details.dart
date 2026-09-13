import 'dart:convert';

import 'package:final_food/container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:final_food/category_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Details extends StatefulWidget {
  final String mealId;

  const Details({super.key, required this.mealId});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  bool isLoading = false;
  Map<String, dynamic>? data;

  bool isFavorite = false;

  int servings = 1; // changed
  final int originalServings = 1; // changed

  Future<void> getDetails() async {
    final response = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=${widget.mealId}',
      ),
    );

    setState(() {
      data = jsonDecode(response.body);
    });
  }

  Future<void> toggleFavorite() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(widget.mealId)) {
      favorites.remove(widget.mealId);
    } else {
      favorites.add(widget.mealId);
    }

    await prefs.setStringList('favorites', favorites);
  }

  Future<void> shareRecipe(Map<String, dynamic> meal) async {
    final mealName = meal['strMeal'].toString();
    final youtubeUrl = meal['strYoutube']?.toString().trim();

    final message = youtubeUrl == null || youtubeUrl.isEmpty
        ? 'Check out this recipe: $mealName'
        : 'Check out this recipe: $mealName\n\nWatch the recipe:\n$youtubeUrl';

    await SharePlus.instance.share(
      ShareParams(text: message),
    );
  }

  Future<void> checkFavorite() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList('favorites') ?? [];

    setState(() {
      isFavorite = favorites.contains(widget.mealId);
    });
  }

  String scaleMeasure(String measure) {
    // changed
    if (measure.trim().isEmpty) return measure;

    final match = RegExp(
      r'^(\d+(?:\.\d+)?|\d+/\d+)(.*)$',
    ).firstMatch(measure.trim());

    if (match == null) return measure;

    final numberText = match.group(1)!;
    final rest = match.group(2)!;

    double number;

    if (numberText.contains('/')) {
      final parts = numberText.split('/');

      number = double.parse(parts[0]) / double.parse(parts[1]);
    } else {
      number = double.parse(numberText);
    }

    final newNumber = number * servings / originalServings;

    String formatted;

    if (newNumber == newNumber.roundToDouble()) {
      formatted = newNumber.toInt().toString();
    } else {
      formatted = newNumber.toStringAsFixed(2);
    }

    return '$formatted$rest';
  }

  @override
  void initState() {
    super.initState();

    getDetails();
    checkFavorite();
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final meal = data!['meals'][0];

    final ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];

      if (ingredient != null &&
          ingredient.toString().trim().isNotEmpty) {
        ingredients.add({
          'ingredient': ingredient,
          'measure': measure,
        });
      }
    }

    final instructions = (meal['strInstructions'] as String)
        .split(RegExp(r'\r?\n'))
        .where((step) {
      final text = step.trim().toLowerCase();

      if (text.isEmpty) {
        return false;
      }

      // حذف step 1 / step 2 / Step 3
      if (RegExp(r'^step\s*\d+\s*[:.\-]?\s*$').hasMatch(text)) {
        return false;
      }

      // حذف الأرقام فقط: 1 / 2 / 3 / 4
      if (RegExp(r'^\d+\s*$').hasMatch(text)) {
        return false;
      }

      return true;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),

      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.only(bottom: 90),

            children: [
              Stack(
                children: [
                  Image.network(
                    meal['strMealThumb'],
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),

                  Positioned(
                    top: 50,
                    left: 15,
                    child: CircleAvatar(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 50,
                    right: 15,
                    child: Row(
                      children: [
                        CircleAvatar(
                          child: IconButton(
                            onPressed: () => shareRecipe(meal),
                            icon: const Icon(Icons.share_outlined),
                          ),
                        ),

                        const SizedBox(width: 8),

                        CircleAvatar(
                          child: IconButton(
                            onPressed: () async {
                              await toggleFavorite();

                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? const Color(0xFFFF6B3D)
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Text(
                meal['strMeal'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 6),

              // changed
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InfoCard(
                    icon: categoryIcons[meal['strCategory']] ??
                        Icons.category,
                    text: meal['strCategory'],
                  ),

                  const SizedBox(width: 10), // changed

                  InfoCard(
                    icon: Icons.public,
                    text: meal['strArea'] ?? 'unknown area',
                  ),

                  const SizedBox(width: 10), // changed

                  InfoCard(
                    icon: Icons.timer_outlined,
                    text: '45 min',
                  ),
                ],
              ),

              Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Ingredients',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Row(
                      // changed
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,

                      children: [
                        const Text(
                          'Servings',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (servings > 1) {
                                  setState(() {
                                    servings--; // changed
                                  });
                                }
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                              ),
                            ),

                            Text(
                              '$servings', // changed
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  servings++; // changed
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle,
                                color: Color(0xFFFF6B3D),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    GridView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),

                      itemCount: ingredients.length,

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 4,
                      ),

                      itemBuilder: (context, index) {
                        return Container(
                          padding:
                              const EdgeInsets.symmetric(horizontal: 8),

                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(12),
                          ),

                          child: Row(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              const Icon(
                                Icons.expand_circle_down_rounded,
                                color: Colors.green,
                                size: 18,
                              ),

                              const SizedBox(width: 5),

                              Expanded(
                                child: Text(
                                  ingredients[index]['ingredient'],
                                  overflow:
                                      TextOverflow.ellipsis,
                                ),
                              ),

                              Text(
                                scaleMeasure(
                                  ingredients[index]['measure'] ?? '',
                                ), // changed
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 25),

                    const Text(
                      'Instruction',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Column(
                      children:
                          List.generate(instructions.length, (index) {
                        return Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: 8),

                          child: Row(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,

                            children: [
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.orange,

                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              const SizedBox(width: 12),

                              Expanded(
                                child: Text(
                                  instructions[index].trim(),
                                  style: const TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Positioned(
            bottom: 15,
            left: 16,
            right: 16,

            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 14),

              decoration: BoxDecoration(
                color: Colors.deepOrange,
                borderRadius:
                    BorderRadius.circular(12),
              ),

              child: InkWell(
                onTap: () async {
                  final youtubeUrl = meal['strYoutube'];

                  if (youtubeUrl == null ||
                      youtubeUrl.toString().trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'No video available for this recipe',
                        ),
                      ),
                    );

                    return;
                  }

                  final url =
                      Uri.parse(youtubeUrl.toString());

                  try {
                    await launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  } catch (e) {
                    debugPrint(
                      'YouTube error: $e',
                    );
                  }
                },

                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,

                  children: [
                    Icon(
                      Icons.play_circle_outline,
                      color: Colors.white,
                    ),

                    SizedBox(width: 8),

                    Text(
                      'Watch Recipe',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}