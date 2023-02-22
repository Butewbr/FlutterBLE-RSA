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
    secondaryHeaderColor: Colors.deepPurpleAccent,
    disabledColor: Colors.deepPurpleAccent[200],
    appBarTheme: const AppBarTheme(backgroundColor: Colors.deepPurple),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: Colors.deepPurpleAccent,
      disabledBackgroundColor: Colors.deepPurpleAccent[100],
      padding: const EdgeInsets.symmetric(vertical: 12),
      minimumSize: const Size(300, 1),
    )),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Colors.deepPurpleAccent),
    cardTheme: const CardTheme(
      color: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.dark(),
  );
  static final darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 11, 17, 29),
    primaryColor: const Color(0xFF335C81),
    primaryColorLight: Colors.white,
    primaryColorDark: Colors.grey[400],
    secondaryHeaderColor: const Color(0xFF274060),
    disabledColor: const Color.fromARGB(255, 55, 101, 141),
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF274060)),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF274060),
      disabledBackgroundColor: const Color.fromARGB(255, 25, 41, 62),
      padding: const EdgeInsets.symmetric(vertical: 12),
      minimumSize: const Size(300, 1),
    )),
    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(backgroundColor: Color(0xFF274060)),
    cardTheme: const CardTheme(
      color: Color(0xFF111A2C),
    ),
    iconTheme: const IconThemeData(color: Colors.white),
    colorScheme: const ColorScheme.light(),
  );
}
