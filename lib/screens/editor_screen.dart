import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class EditorScreen extends StatelessWidget {
  EditorScreen({Key? key}) : super(key: key);

  static const routeName = '/editor';

  final quill.QuillController _controller = quill.QuillController(
    document: quill.Document(),
    selection: const TextSelection.collapsed(offset: 0),
    keepStyleOnNewLine: false,
  );
  final FocusNode _focusNode = FocusNode();
  final String journalName = "";

  Widget get body {
    return Padding(
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(journalName),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(Icons.more_vert_rounded,
                  color: Theme.of(context).primaryIconTheme.color),
              onChanged: (newValue) {
                if (newValue == 'calendar') {
                  print('Calendar pressed');
                }
                if (newValue == 'delete') {
                  print('Delete pressed');
                }
                if (newValue == 'debug') {
                  print(_controller.document.toDelta().toJson().toString());
                }
              },
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(
                        width: 8,
                      ),
                      Text('Add to Calendar',
                          style: Theme.of(context).textTheme.button),
                    ],
                  ),
                  value: 'calendar',
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Theme.of(context).primaryColor),
                      const SizedBox(
                        width: 8,
                      ),
                      Text('Delete', style: Theme.of(context).textTheme.button),
                    ],
                  ),
                  value: 'delete',
                ),
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(Icons.bug_report,
                          color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text('Print JSON',
                          style: Theme.of(context).textTheme.button),
                    ],
                  ),
                  value: 'debug',
                )
              ],
            ),
          )
        ],
      ),
      body: SafeArea(child: body),
    );
  }
}
