import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData themeMode = MyThemes.lightTheme;

  bool get isDarkMode => themeMode == MyThemes.darkTheme;

  void toggleTheme() {
    themeMode == MyThemes.lightTheme
        ? themeMode = MyThemes.darkTheme
        : themeMode = MyThemes.lightTheme;
    notifyListeners();
  }
}

class MyThemes {
  static final lightTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[100],
    primaryColor: Colors.deepPurple,
    primaryColorLight: Colors.black,
    primaryColorDark: Colors.grey[700],
    appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurpleAccent,
      disabledBackgroundColor: Colors.deepPurpleAccent[100],
      padding: const EdgeInsets.symmetric(vertical: 12),
      minimumSize: const Size(300, 1),
    )),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.dark(),
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: Colors.grey[900],
    primaryColor: Colors.deepPurpleAccent[100],
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.grey[400],
    appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurpleAccent),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurpleAccent[200],
      disabledBackgroundColor: Colors.deepPurple,
      padding: const EdgeInsets.symmetric(vertical: 12),
      minimumSize: const Size(300, 1),
    )),
    cardTheme: CardTheme(
      color: Colors.grey[800],
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.light(),
  );
}
