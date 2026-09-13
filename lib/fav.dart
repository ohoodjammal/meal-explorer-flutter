import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Fav extends StatefulWidget {
  const Fav({super.key});

  @override
  State<Fav> createState() => _FavState();
}

class _FavState extends State<Fav> {
  List cards = [];
  String? selectedCategory;

Future<void> getFavorites() async {
  // changed
  final prefs = await SharedPreferences.getInstance(); // changed

  final favorites = prefs.getStringList('favorites') ?? []; // changed

  for (final id in favorites) {
    final response = await http.get(
      // changed
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    final data = jsonDecode(response.body); // changed

    if (data['meals'] != null) {
      cards.add(data['meals'][0]); // changed
    }
  }

  if (!mounted) return; // changed

  setState(() {}); // changed
}

  Future<void> removeFavorite(String id) async {
  // changed
  final prefs = await SharedPreferences.getInstance(); // changed

  final favorites = prefs.getStringList('favorites') ?? []; // changed

  favorites.remove(id); // changed

  await prefs.setStringList('favorites', favorites); // changed

  if (!mounted) return; // changed

  setState(() {
    cards.removeWhere((meal) => meal['idMeal'] == id); // changed
  });
}
  @override
  void initState() {
    // changed
    super.initState(); // changed
    getFavorites(); // changed
  }

  final favCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final categories = cards
        .map((meal) => meal['strCategory'])
        .whereType<String>()
        .where((category) => category.isNotEmpty)
        .toSet()
        .toList();
    final filteredCards = selectedCategory == null
        ? cards
        : cards
              .where((meal) => meal['strCategory'] == selectedCategory)
              .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F7F4),

        title: Text(
          'Favorites',
          style: TextStyle(
            color: Color(0xFFFF6B3D),
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
          color: Color(0xFFFF6B3D),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final category = await showModalBottomSheet<String>(
                context: context,
                backgroundColor: const Color(0xFFF9F7F4),
                builder: (context) {
                  return SafeArea(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          title: const Text('All'),
                          leading: const Icon(
                            Icons.filter_list,
                            color: Color(0xFFFF6B3D),
                          ),
                          onTap: () => Navigator.pop(context, ''),
                        ),
                        ...categories.map(
                          (category) => ListTile(
                            title: Text(category),
                            onTap: () => Navigator.pop(context, category),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              if (category != null) {
                setState(() {
                  selectedCategory = category.isEmpty ? null : category;
                });
              }
            },
            icon: const Icon(Icons.filter_list),
            color: const Color(0xFFFF6B3D),
          ),
        ],
      ),
      body: cards.isEmpty
          ? const Center(
              child: Text(
                'No favorite meals yet,                                                                                 Start exploring and save the recipes you love',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF6B3D),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : filteredCards.isEmpty
          ? const Center(
              child: Text(
                'No favorite meals in this category',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF6B3D),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : ListView.builder(
              itemCount: filteredCards.length,
              itemBuilder: (context, index) {
                final meal = filteredCards[index];

                return Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      // صورة الوجبة هون
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          image: DecorationImage(
                            image: NetworkImage(
                              meal['strMealThumb'], // changed
                            ),
                            fit: BoxFit.cover, // changed
                          ),
                        ),
                      ),

                      // معلومات الوجبة هون
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                meal['strMeal'], // changed
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '🌿 ${meal['strCategory']}', // changed
                              ),

                              const SizedBox(height: 5),

                              Text(
                                '🌍 ${meal['strArea']}', // changed
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          removeFavorite(meal['idMeal']); // changed
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Color(0xFFFF6B3D),
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
