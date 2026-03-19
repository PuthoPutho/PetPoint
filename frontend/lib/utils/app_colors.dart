import 'package:flutter/material.dart';

class AppTheme {
  //theme
  static ThemeData get lightTheme {
    return ThemeData(
      fontFamily: 'GoogleSans',
      scaffoldBackgroundColor: Colors.white,
      primaryColor: AppColors.primaryGreen,
    );
  }
}

//color
class AppColors {
  static const Color primaryGreen = Color(0xFF59AC77);
}

class AppTextStyle {
  //textstyle
  static const TextStyle headingStyle = TextStyle(
    fontFamily: 'GoogleSans',
    fontSize: 36,
    fontWeight: FontWeight.w800,
    color: Colors.black,
  );

  static const TextStyle subHeadingStyle = TextStyle(
    fontFamily: 'GoogleSans',
    fontSize: 30,
    fontWeight: FontWeight.w700,
    color: Colors.black,  
  );

  static const TextStyle bodyStyle = TextStyle(
    fontFamily: 'GoogleSans',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

}