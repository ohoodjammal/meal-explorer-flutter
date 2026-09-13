import 'dart:convert';

import 'package:final_food/details.dart';
import 'package:final_food/fav.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:final_food/category_icons.dart';
import 'package:final_food/chatbot.dart';
import 'package:final_food/SplashScreen.dart';
import 'package:final_food/about_us.dart'; // changed

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List categories = [];

  List cards = [];
  bool isLoading = true; 
 Future<void> showFood(String categoryName) async {
  setState(() {
    isLoading = true; // changed
  });

  try {
    final response = await http.get(
      Uri.parse(
        "https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName",
      ),
    );
    final data = jsonDecode(response.body);
    setState(() {
      cards = data['meals'] ?? []; // changed
      isLoading = false; // changed
    });
  } catch (e) {
    debugPrint(e.toString());
    setState(() {
      isLoading = false; // changed
    });
  }
}

  TextEditingController controller = TextEditingController();

  Future<void> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/list.php?c=list'),
      );

      final data = jsonDecode(response.body);

      setState(() {
        categories = [
          {'strCategory': 'All'},
          ...data['meals'],
        ];
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> searchByName(String name) async {
  setState(() {
    isLoading = true; // changed
  });

  final response = await http.get(
    Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s=$name'),
  );
  final data = jsonDecode(response.body);
  setState(() {
    cards = data['meals'] ?? [];
    isLoading = false; // changed
  });
}
Future<void> showAllFood() async {
  setState(() {
    isLoading = true; // changed
  });

  try {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s='),
    );

    final data = jsonDecode(response.body);

    setState(() {
      cards = data['meals'] ?? [];
      isLoading = false; // changed
    });
  } catch (e) {
    debugPrint(e.toString());
    setState(() {
      isLoading = false; // changed
    });
  }
}

  @override
  void initState() {
    super.initState();
    getCategories();
    showAllFood();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F4),

      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Color(0xFFFF6B3D), // لون أيقونة Menu
        ),
        backgroundColor: const Color(0xFFF9F7F4),

        title: Row(
          children: [
            Text(
              'Meal Explorer',
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                fontWeight: FontWeight.bold, 
                color: const Color(0xFFFF6B3D),
              ),
            ),

            const SizedBox(width: 22),

            SizedBox(
              height: 80,
              width: 100,
              child: Image.asset('assets/images/icon.png', fit: BoxFit.cover),
            ),
          ],
        ),
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFFF9F7F4)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 42,
                    color: Color(0xFFFF6B3D),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Meal Explorer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF6B3D),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text('Discover your meal'),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFFFF6B3D)),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 6),
            ListTile(
              leading: const Icon(Icons.favorite, color: Color(0xFFFF6B3D)),
              title: const Text('Favorites'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Fav()),
                );
              },
            ),
            SizedBox(height: 6),

            ListTile(
              leading: const Icon(
                Icons.grid_view_outlined,
                color: Color(0xFFFF6B3D),
              ),
              title: const Text('Categories'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 6),
            ListTile(
              leading: const Icon(
                Icons.chat_bubble_outline,
                color: Color(0xFFFF6B3D),
              ),
              title: const Text('Meal Assistant'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBot()),
                );
              },
            ),
            SizedBox(height: 6),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFFFF6B3D)),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 6),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFFFF6B3D)),
              title: const Text('About Us'),
              onTap: () {
                // changed
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutUs()),
                );
              },
            ),
            SizedBox(height: 6),
            ListTile(
              leading: const Icon(
                Icons.dark_mode_outlined,
                color: Color(0xFFFF6B3D),
              ),
              title: const Text('Dark Mode'),
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: 6),
            ListTile(
              leading: const Icon(Icons.language, color: Color(0xFFFF6B3D)),
              title: const Text('Language'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: ListView(
          children: [
            const Text(
              'Why are you craving?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 10),

            Card(
              elevation: 5,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              child: TextField(
                onChanged: (value) {
                  searchByName(value);
                },
                controller: controller,

                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.search, color: Color(0xFFFF6B3D)),
                  ),

                  hintText: 'Search meals',

                  hintStyle: const TextStyle(color: Colors.grey),

                  border: InputBorder.none,

                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              height: 60,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,

                itemBuilder: (context, index) {
                  String categoryName = categories[index]['strCategory'];

                  return GestureDetector(
                    onTap: () {
                      if (categoryName == 'All') {
                        showAllFood();
                      } else {
                        showFood(categoryName);
                      }
                    },
                    child: Container(
                      width: 150,

                      margin: const EdgeInsets.only(right: 10),

                      padding: const EdgeInsets.symmetric(horizontal: 10),

                      decoration: BoxDecoration(
                        color: Colors.white,

                        borderRadius: BorderRadius.circular(20),
                      ),

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,

                        children: [
                          Icon(
                            categoryIcons[categoryName],
                            size: 30,
                            color: const Color(0xFFFF6B3D),
                          ),

                          const SizedBox(width: 6),

                          Flexible(
                            child: Text(
                              categoryName,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),

            isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF6B3D)),
                  )
                : cards.isEmpty
                ? const Center(
                    child: Text(
                      'No meals found \nTry searching for another meal.',style: TextStyle(fontWeight: FontWeight.bold,color: Color(0xFFFF6B3D)),
                      textAlign: TextAlign.center,
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: cards.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.90,
                        ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  Details(mealId: cards[index]['idMeal']),
                            ),
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            children: [
                              Expanded(
                                child: Image.network(
                                  cards[index]['strMealThumb'],
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Text(
                                  cards[index]['strMeal'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFF9F7F4),
        elevation: 4,
        items: [
          BottomNavigationBarItem(
            icon: (IconButton(
              onPressed: () {},
              icon: Icon(Icons.home, color: const Color(0xFFFF6B3D)),
            )),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => Fav()),
                );
              },
              icon: Icon(Icons.favorite, color: const Color(0xFFFF6B3D)),
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ChatBot()),
                );
              },
              icon: Icon(
                Icons.smart_toy_outlined,
                color: const Color(0xFFFF6B3D),
              ),
            ),
            label: 'AI',
          ),
        ],
      ),
    );
  }
}
