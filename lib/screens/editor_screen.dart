import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorScreen extends StatelessWidget {
  EditorScreen({Key? key}) : super(key: key);
  static const routeName = '/';
  final quill.QuillController _controller = quill.QuillController(
    document: quill.Document(),
    selection: const TextSelection.collapsed(offset: 0),
    keepStyleOnNewLine: false,
  );
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    var body = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: quill.QuillToolbar.basic(
              controller: _controller,
              locale: const Locale('en', 'US'),
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: quill.QuillEditor(
              controller: _controller,
              padding: const EdgeInsets.all(0),
              readOnly: false,
              scrollController: ScrollController(),
              scrollable: true,
              expands: false,
              focusNode: _focusNode,
              autoFocus: true,
            ),
          )
        ],
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(
              middle: Text('Editor'),
            ),
            child: SafeArea(child: body),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Editor'),
            ),
            body: SafeArea(child: body),
          );
  }
}
