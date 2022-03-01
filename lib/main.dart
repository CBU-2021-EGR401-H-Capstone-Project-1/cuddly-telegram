import 'package:cuddly_telegram/screens/calendar_events_screen.dart';
import 'package:cuddly_telegram/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:cell_calendar/cell_calendar.dart';
import 'package:cuddly_telegram/screens/sample_events.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/calendar/v3.dart' as v3;
import 'package:cuddly_telegram/utility/configuration.dart' as config
    show calendar_api;

import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/file_browser_screen.dart';

void main() {
  runApp(const MyApp());
  var _credentials;

  if (kIsWeb) {
    _credentials = ClientId(config.calendar_api, "");
    //"804561888193-af21salp37sst6u2gimg58ci7jfuu2rb.apps.googleusercontent.com",
    //"");
  }

  var _scopes = [v3.CalendarApi.calendarScope];

  try {
    var _clientID;
    if (kIsWeb) {
      _clientID = ClientId(config.calendar_api, "");
    } else if (Platform.isIOS) {
      _clientID = ClientId(config.calendar_api, "");
    }
    clientViaUserConsent(_clientID, _scopes, prompt).then((AuthClient client) {
      var calendar = v3.CalendarApi(client);
      print(calendar.calendarList.list());
    });
  } catch (e) {
    print('Error creating event $e');
  }
}

void prompt(String url) async {
  print("Please go to the following URL and grant access:");
  print("  => $url");
  print("");

  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
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
      MyHomePage.routeName: (ctx) => const MyHomePage(),
    };

    return ChangeNotifierProvider(
      create: (context) => JournalStore({}),
      child: MaterialApp(
        title: 'Journal',
        theme: theme,
        routes: routes,
        initialRoute: FileBrowserScreen.routeName,
      ),
    );
  }
}
