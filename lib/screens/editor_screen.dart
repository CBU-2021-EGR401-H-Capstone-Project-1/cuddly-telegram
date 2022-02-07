import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';

class EditorScreen extends StatelessWidget {
  EditorScreen({Key? key}) : super(key: key);

  static const routeName = '/editor';
  final FocusNode _focusNode = FocusNode();

  Widget body(quill.QuillController controller) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            child: quill.QuillToolbar.basic(
              controller: controller,
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          Expanded(
            child: quill.QuillEditor(
              controller: controller,
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
    var journal = ModalRoute.of(context)?.settings.arguments as Journal;
    final controller = quill.QuillController(
        document: journal.document,
        selection: const TextSelection.collapsed(offset: 0),
        keepStyleOnNewLine: false,
      );
    return Scaffold(
      appBar: AppBar(
        title: Text(journal.title),
        actions: [
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(Icons.more_vert_rounded,
                  color: Theme.of(context).primaryIconTheme.color),
              onChanged: (newValue) {
                if (newValue == 'save') {
                  Provider.of<JournalStore>(context, listen: false)
                      .add(journal);
                }
                if (newValue == 'calendar') {
                  print('Calendar pressed');
                }
                if (newValue == 'delete') {
                  if (Provider.of<JournalStore>(context, listen: false)
                          .journals
                          .contains(controller.document) &&
                      Provider.of<JournalStore>(context)
                          .remove(journal)) {}
                  Navigator.of(context).pop();
                }
                if (newValue == 'debug') {
                  print(controller.document.toDelta().toJson().toString());
                }
              },
              items: [
                DropdownMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.save,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Save",
                        style: Theme.of(context).textTheme.button,
                      )
                    ],
                  ),
                  value: 'save',
                ),
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
      body: SafeArea(child: body(controller)),
    );
  }
}
