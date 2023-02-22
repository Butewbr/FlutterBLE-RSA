import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:myapp/provider/theme_provider.dart';

class ChangeThemeButton extends StatelessWidget {
  const ChangeThemeButton({super.key});
  @override
  Widget build(BuildContext context) {
    IconData iconLight = Icons.wb_sunny;
    IconData iconDark = Icons.nights_stay;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<ThemeProvider>(
        builder: (context, notifier, child) => IconButton(
            onPressed: () {
              themeProvider.toggleTheme();
            },
            icon: Icon(themeProvider.isDarkMode ? iconDark : iconLight)));
  }
}
