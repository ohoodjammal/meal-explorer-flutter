import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoCard({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color:  const Color.fromARGB(255, 246, 226, 197),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 18,color: const Color.fromARGB(255, 172, 57, 23),), const SizedBox(width: 6), Text(text,style: TextStyle(
          color:const Color.fromARGB(255, 172, 57, 23)
        ),)],
      ),
    );
  }
}
