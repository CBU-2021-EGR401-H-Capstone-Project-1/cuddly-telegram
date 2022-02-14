import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

enum TextDirection {
  ltr,
  rtl,
}

class LocalStyle extends ChangeNotifier {
  Color foregroundColor = Colors.black;
  Color backgroundColor = Colors.white;
  TextDirection direction = TextDirection.ltr;
  String language = "en_US";

  LocalStyle({
    required this.foregroundColor,
    required this.backgroundColor,
    required this.direction,
    required this.language,
  });

  LocalStyle.loadPackaged() {
    rootBundle.loadString('assets/locale.txt').then((str) {
      var lines = str.split('\n');
      for (var line in lines) {
        if (line.contains('lang')) {
          language = line.split(' ')[1];
        } else if (line.contains('foregroundColor')) {
          final hex = line.split(' ')[1];
          foregroundColor = Color(int.parse(
            hex.replaceFirst("#", ""),
            radix: 16,
          ));
        } else if (line.contains('backgroundColor')) {
          final hex = line.split(' ')[1];
          backgroundColor = Color(int.parse(
            hex.replaceFirst("#", ""),
            radix: 16,
          ));
        } else if (line.contains('direction')) {
          final dir = line.split(' ')[1];
          direction = TextDirection.values[int.parse(dir)];
        }
      }
    }).onError((error, stackTrace) => null);
  }
}
