import 'package:flutter/material.dart';
class DoDidDoneTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF9F7BF6), // Primary color
      brightness: Brightness.light,
      primary: const Color(0xFF9F7BF6),  // Primary color
      secondary: const Color(0xFF4CEb8b),  // Secondary color
      onPrimary: Colors.white,
    ),
    useMaterial3: true,
        
    // Добавляем стиль для кнопок
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF4ceb8b),), // Цвет фона кнопок
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: Colors.white), // Текст кнопок белый
        ),
      ),
    ),
    
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: const Color(0xFF9f7bf6), // Цвет выбранной иконки
      unselectedItemColor:
          const Color(0xFF4ceb8b).withOpacity(0.5), // Цвет невыбранной иконки
      backgroundColor: Colors.transparent, // Прозрачный фон
    ),
  );
}