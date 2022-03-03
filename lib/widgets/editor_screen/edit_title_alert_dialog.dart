import 'package:cuddly_telegram/model/journal.dart';
import 'package:flutter/material.dart';

class EditTitleAlertDialog extends StatelessWidget {
  const EditTitleAlertDialog(
      {Key? key, required this.journal, required this.onSavePressed})
      : super(key: key);

  final Journal journal;
  final Function(String) onSavePressed;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: journal.title);
    return AlertDialog(
      title: Text(
        'Edit Title',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: TextField(
        autocorrect: false,
        controller: controller,
        maxLength: 20,
        maxLines: 1,
        textCapitalization: TextCapitalization.sentences,
      ),
      elevation: 6,
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context, 'Cancel'),
        ),
        TextButton(
          child: const Text('OK'),
          onPressed: () {
            onSavePressed(controller.text);
            Navigator.pop(context, 'OK');
          },
        )
      ],
    );
  }
}
