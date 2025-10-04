import 'package:flutter/material.dart';
import 'package:med_health_app/theme.dart';

class CardCategory extends StatelessWidget {
  final String imageCategory;
  final String nameCategory;

  CardCategory({
    required this.imageCategory,
    required this.nameCategory,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          EdgeInsets.symmetric(vertical: 8), // Add padding for better spacing
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center the content
        children: [
          Image.asset(
            imageCategory,
            width: 60,
            height: 60,
          ),
          SizedBox(height: 8), // Reduced space between image and text
          Text(
            nameCategory,

            style: mediumTextStyle.copyWith(
              fontSize: 10,
            ),
            textAlign: TextAlign.center, // Center text alignment
          ),
          SizedBox(height: 8), // Space below the text
        ],
      ),
    );
  }
}
