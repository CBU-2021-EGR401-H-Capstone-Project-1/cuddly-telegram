import 'package:cuddly_telegram/model/journal.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/utility/io_helper.dart';
import 'package:cuddly_telegram/widgets/editor_screen/edit_title_alert_dialog.dart';
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

  void onDropdownSelect(String? newValue, Journal journal) {
    switch (newValue) {
      case 'save':
        Provider.of<JournalStore>(context, listen: false).add(journal);
        IOHelper.writeJournalStore(
            Provider.of<JournalStore>(context, listen: false));
        break;
      case 'delete':
        Provider.of<JournalStore>(context, listen: false).remove(journal);
        IOHelper.writeJournalStore(
            Provider.of<JournalStore>(context, listen: false));
        Navigator.of(context).pop();
        break;
      case 'editTitle':
        showDialog(
          context: context,
          barrierDismissible: false,
          useSafeArea: true,
          builder: (context) {
            return EditTitleAlertDialog(
              journal: journal,
              onSavePressed: (newTitle) {
                setState(() {
                  journal.title = newTitle;
                });
                final journalStore =
                    Provider.of<JournalStore>(context, listen: false);
                journalStore.update(journal);
                IOHelper.writeJournalStore(journalStore);
              },
            );
          },
        );
        break;
      default:
        break;
      // TODO handle 'calendar' case
    }
  }

  List<DropdownMenuItem<String>> get dropdownItems {
    return [
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
            Icon(Icons.calendar_today, color: Theme.of(context).primaryColor),
            const SizedBox(
              width: 8,
            ),
            Text('Add to Calendar', style: Theme.of(context).textTheme.button),
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
            Text('Edit Title', style: Theme.of(context).textTheme.button),
          ],
        ),
        value: 'editTitle',
      )
    ];
  }

  PreferredSizeWidget appBar(Journal journal) {
    return AppBar(
      title: Text(journal.title),
      actions: [
        DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            icon: Icon(Icons.more_vert_rounded,
                color: Theme.of(context).primaryIconTheme.color),
            onChanged: (newValue) => onDropdownSelect(newValue, journal),
            items: dropdownItems,
          ),
        )
      ],
    );
  }

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
      appBar: appBar(journal),
      body: WillPopScope(
        onWillPop: () async {
          final journalStore =
              Provider.of<JournalStore>(context, listen: false);
          journalStore.add(journal);
          IOHelper.writeJournalStore(journalStore);
          Navigator.pop(context);
          return true;
        },
        child: SafeArea(
          child: body(controller),
        ),
      ),
    );
  }
}
