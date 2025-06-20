import 'package:flutter/material.dart';

class PickServiceCard extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback? onTap;

  const PickServiceCard({
    super.key,
    required this.title,
    required this.image,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(image, height: 120, fit: BoxFit.cover),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
