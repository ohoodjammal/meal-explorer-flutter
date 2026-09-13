import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  static const backgroundColor = Color(0xFFF9F7F4);
  static const accentColor = Color(0xFFFF6B3D);
  static const textColor = Color(0xFF2F2B28);
  static const mutedTextColor = Color(0xFF746D67);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: accentColor),
        title: Text(
          'About Us',
          style: TextStyle(
            color: accentColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final contentWidth = constraints.maxWidth > 720
                ? 680.0
                : double.infinity;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: contentWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildIntro(),
                      const SizedBox(height: 28),
                      _buildSection(
                        title: 'Our Mission',
                        child: const Text(
                          'We believe great food brings people together. Our mission is to make discovering and preparing delicious meals feel simple, inspiring, and enjoyable for everyone.',
                          style: TextStyle(
                            color: mutedTextColor,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'What You Can Do',
                        child: Column(
                          children: [
                            _FeatureItem(
                              icon: Icons.explore_outlined,
                              title: 'Discover Meals',
                              description:
                                  'Find new meal ideas for every craving.',
                            ),
                            _FeatureItem(
                              icon: Icons.grid_view_rounded,
                              title: 'Explore Categories',
                              description:
                                  'Browse recipes by cuisine and category.',
                            ),
                            _FeatureItem(
                              icon: Icons.favorite_border_rounded,
                              title: 'Save Favorites',
                              description:
                                  'Keep the recipes you love close at hand.',
                            ),
                            _FeatureItem(
                              icon: Icons.menu_book_outlined,
                              title: 'Get Recipe Instructions',
                              description:
                                  'Follow clear ingredients and cooking steps.',
                            ),
                            _FeatureItem(
                              icon: Icons.chat_bubble_outline_rounded,
                              title: 'Meal Assistant',
                              description:
                                  'Get helpful meal ideas with AI assistance.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildSection(
                        title: 'About the App',
                        child: const Text(
                          'Meal Explorer uses TheMealDB API to retrieve meal and recipe information, helping you discover ingredients, instructions, and inspiration from cuisines around the world.',
                          style: TextStyle(
                            color: mutedTextColor,
                            fontSize: 15,
                            height: 1.6,
                          ),
                        ),
                      ),
                      const SizedBox(height: 34),
                      const Center(
                        child: Text(
                          'Made with ❤️ for food lovers',
                          style: TextStyle(
                            color: accentColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildIntro() {
    return Column(
      children: [
        Container(
          width: 112,
          height: 112,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: accentColor.withValues(alpha: 0.14),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Image.asset('assets/images/icon.png'),
        ),
        const SizedBox(height: 18),
        Text(
          'Meal Explorer',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            color: textColor,
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Your friendly guide to discovering delicious meals, exploring recipes, and finding inspiration for your next dish.',
          textAlign: TextAlign.center,
          style: TextStyle(color: mutedTextColor, fontSize: 15, height: 1.6),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: accentColor.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.playfairDisplay(
              color: textColor,
              fontSize: 21,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AboutUs.accentColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: AboutUs.accentColor, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AboutUs.textColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  description,
                  style: const TextStyle(
                    color: AboutUs.mutedTextColor,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
