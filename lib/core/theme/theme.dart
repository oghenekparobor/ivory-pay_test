import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

ThemeData theme(BuildContext context) => ThemeData(
      visualDensity: VisualDensity.adaptivePlatformDensity,
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: const Color(0xFF232220),
          fontSize: 40.sp,
          fontFamily: 'Euclid',
        ),
        displayMedium: TextStyle(
          color: const Color(0xFF232220),
          fontSize: 36.sp,
          fontFamily: 'Euclid',
        ),
        displaySmall: TextStyle(
          color: const Color(0xFF232220),
          fontSize: 28.sp,
          fontFamily: 'Euclid',
        ),
        bodyLarge: TextStyle(
          color: const Color(0xFF232220),
          fontSize: 18.sp,
          fontFamily: 'Euclid',
        ),
        bodyMedium: TextStyle(
          color: const Color(0xFF232220),
          fontSize: 16.sp,
          fontFamily: 'Euclid',
        ),
        bodySmall: TextStyle(
          color: const Color(0xFF232220),
          fontSize: 13.sp,
          fontFamily: 'Euclid',
        ),
      ),
      primaryColor: const Color(0xFF232220),
      colorScheme: Theme.of(context).colorScheme.copyWith(
            secondary: const Color(0xFFFC9E11),
            primary: const Color(0xFF232220),
            tertiary: const Color(0xFFA5957E),
          ),
      scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      canvasColor: const Color(0xFFF8F8F8),
      iconTheme: const IconThemeData(color: Colors.white),
      primaryIconTheme: const IconThemeData(color: Colors.white),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(
          vertical: 2.h,
          horizontal: 16.w,
        ),
        iconColor: Colors.black,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );