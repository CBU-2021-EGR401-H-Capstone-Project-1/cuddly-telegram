import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:provider/provider.dart';

class EditorScreen extends StatefulWidget {
  const EditorScreen({Key? key}) : super(key: key);

  static const routeName = '/editor';

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
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
                  IOHelper.writeJournalStore(
                      Provider.of<JournalStore>(context, listen: false));
                }
                if (newValue == 'calendar') {
                  print('Calendar pressed');
                }
                if (newValue == 'delete') {
                  Provider.of<JournalStore>(context, listen: false)
                      .remove(journal);
                  IOHelper.writeJournalStore(
                      Provider.of<JournalStore>(context, listen: false));
                  Navigator.of(context).pop();
                }
                if (newValue == 'editTitle') {
                  final titleEditorController =
                      TextEditingController(text: journal.title);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    useSafeArea: true,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Edit Title',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        content: TextField(
                          autocorrect: false,
                          controller: titleEditorController,
                          maxLength: 20,
                          maxLines: 1,
                          textCapitalization: TextCapitalization.sentences,
                        ),
                        elevation: 6,
                        actions: [
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                          ),
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              setState(() {
                                journal.title = titleEditorController.text;
                              });
                              final journalStore = Provider.of<JournalStore>(
                                  context,
                                  listen: false);
                              journalStore.update(journal);
                              IOHelper.writeJournalStore(journalStore);
                              Navigator.pop(context, 'OK');
                            },
                          )
                        ],
                      );
                    },
                  );
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
                      Icon(Icons.edit, color: Theme.of(context).primaryColor),
                      const SizedBox(width: 8),
                      Text('Edit Title',
                          style: Theme.of(context).textTheme.button),
                    ],
                  ),
                  value: 'editTitle',
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
