import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import 'package:cuddly_telegram/model/local_style.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/file_browser_screen.dart';
<<<<<<< HEAD
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/screens/file_browser_screen.dart';
=======
>>>>>>> 3b4e309ad7183e52131dfa56e99c13b8c432adad
import 'package:cuddly_telegram/widgets/localized_style.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    deviceInfo.androidInfo.then((androidInfo) {
      if (defaultTargetPlatform == TargetPlatform.android &&
          androidInfo.version.sdkInt != null &&
          androidInfo.version.sdkInt! >= 29) {
        // Enable hybrid composition if the device is
        // running Android 10 (Q) or greater.
        // Hybrid composition will run poorly on devices running
        // operating systems before 10 (Q).
        AndroidGoogleMapsFlutter.useAndroidViewSurface = true;
      }
    });

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

    var routes = {
      FileBrowserScreen.routeName: (ctx) => const FileBrowserScreen(),
      MapScreen.routeName: (ctx) => const MapScreen(),
    };

    return LocalizedStyle(
      child: Consumer<LocalStyle>(
        builder: (ctx, style, wdgt) {
          final ThemeData theme = ThemeData(
            brightness: Brightness.light,
            colorScheme: const ColorScheme.light().copyWith(
              background: style.backgroundColor,
              surface: style.backgroundColor,
              onSecondary: style.foregroundColor,
              onBackground: style.foregroundColor,
              onSurface: style.foregroundColor,
              onError: style.foregroundColor,
            ),
            fontFamily: 'Fira Sans',
            textTheme: textTheme,
          );

          return ChangeNotifierProvider(
            create: (context) => JournalStore({}),
            child: MaterialApp(
              title: 'Journal',
              theme: theme,
              routes: routes,
              initialRoute: FileBrowserScreen.routeName,
            ),
          );
        },
      ),
    );
  }
}
