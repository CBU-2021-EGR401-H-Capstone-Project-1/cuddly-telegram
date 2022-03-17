import 'package:cuddly_telegram/model/local_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalizedStyle extends StatefulWidget {
  final Widget? child;

  const LocalizedStyle({Key? key, this.child}) : super(key: key);

  @override
  State<LocalizedStyle> createState() => _LocalizedStyleState();
}

class _LocalizedStyleState extends State<LocalizedStyle> {
  bool loaded = false;
  LocalStyle? style;

  loadStyle() {
    LocalStyle.loadPackaged().then(
      (stl) => setState(() {
        style = stl;
        loaded = true;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!loaded) loadStyle();
    return !loaded
        ? const Center(child: CircularProgressIndicator())
        : ChangeNotifierProvider(
            create: (ctx) => style!,
            child: widget.child,
          );
  }
}
