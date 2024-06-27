import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onPressed;

  const MyButton({super.key, required this.text, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: const Color.fromARGB(255, 21, 58, 169)), // Set icon color
      label: Text(text, style: const TextStyle(color: Color.fromARGB(255, 21, 58, 169))), // Set text color
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20), // Add rounded corners
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Adjust padding
      ),
    );
  }
}