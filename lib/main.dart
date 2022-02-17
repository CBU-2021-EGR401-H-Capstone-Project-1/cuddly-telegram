import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cuddly_telegram/model/local_style.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/file_browser_screen.dart';
<<<<<<< HEAD
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/screens/file_browser_screen.dart';
import 'package:cuddly_telegram/widgets/localized_style.dart';
=======
>>>>>>> ecee9aacc2a3087f23cc28899bddd5df5b1a00b6

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const TextTheme textTheme = TextTheme(
      displayLarge: TextStyle(fontSize: 57.0, fontFamily: 'Abril Fatface'),
      displayMedium: TextStyle(fontSize: 45, fontFamily: 'Abril Fatface'),
      displaySmall: TextStyle(fontSize: 36, fontFamily: 'Abril Fatface'),
      headlineLarge: TextStyle(fontSize: 32, fontFamily: 'Fira Sans Condensed'),
      headlineMedium:
          TextStyle(fontSize: 28, fontFamily: 'Fira Sans Condensed'),
      headlineSmall: TextStyle(fontSize: 24, fontFamily: 'Fira Sans Condensed'),
      titleLarge: TextStyle(
          fontSize: 22, fontWeight: FontWeight.w500, fontFamily: 'Fira Sans'),
      titleMedium: TextStyle(
          fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Fira Sans'),
      titleSmall: TextStyle(
          fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Fira Sans'),
      labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Fira Sans Condensed'),
      labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          fontFamily: 'Fira Sans Condensed'),
      labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          fontFamily: 'Fira Sans Condensed'),
      bodyLarge: TextStyle(fontSize: 16, fontFamily: 'Fira Sans'),
      bodyMedium: TextStyle(fontSize: 14, fontFamily: 'Fira Sans'),
      bodySmall: TextStyle(fontSize: 12, fontFamily: 'Fira Sans'),
    );

    final ThemeData theme = ThemeData(
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      fontFamily: 'Fira Sans',
      textTheme: textTheme,
    );

    var routes = {
      FileBrowserScreen.routeName: (ctx) => const FileBrowserScreen(),
      MapScreen.routeName: (ctx) => const MapScreen(),
    };

    return LocalizedStyle(
      child: Consumer<LocalStyle>(
        builder: (ctx, style, wdgt) {
          return ChangeNotifierProvider(
            create: (context) => JournalStore({}),
            child: MaterialApp(
              title: 'Journal',
              theme: ThemeData.from(
                colorScheme: const ColorScheme.light().copyWith(
                  background: style.backgroundColor,
                  surface: style.backgroundColor,
                  onSecondary: style.foregroundColor,
                  onBackground: style.foregroundColor,
                  onSurface: style.foregroundColor,
                  onError: style.foregroundColor,
                ),
              ),
              routes: routes,
              initialRoute: FileBrowserScreen.routeName,
            ),
          );
        },
      ),
    );
  }
}
