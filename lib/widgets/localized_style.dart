import 'package:cuddly_telegram/model/local_style.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocalizedStyle extends StatelessWidget {
  final Widget? child;

  const LocalizedStyle({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => LocalStyle.loadPackaged(),
      child: child,
    );
  }
}
