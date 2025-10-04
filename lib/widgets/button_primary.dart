import 'package:flutter/material.dart';
import 'package:med_health_app/theme.dart';

class ButtonPrimary extends StatelessWidget {
  final String text;
  final VoidCallback onTap; // Use VoidCallback instead of Function

  ButtonPrimary({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 100,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap, // Use onTap directly
        style: ElevatedButton.styleFrom(
          backgroundColor:
              greenColor, // Use your greenColor defined in theme.dart
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(color: Colors.white), // White text on green button
        ),
      ),
    );
  }
}
