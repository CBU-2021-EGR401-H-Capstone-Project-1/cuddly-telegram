import 'package:cuddly_telegram/model/journal.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class EditNotificationAlertDialog extends StatelessWidget {
  const EditNotificationAlertDialog(
      {Key? key, required this.journal, required this.onSavePressed})
      : super(key: key);

  final Journal journal;
  final Function(Tuple4 metadata) onSavePressed;

  double toDouble(TimeOfDay myTime) => myTime.hour + myTime.minute / 60.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final detailController = TextEditingController();
    TimeOfDay? time;
    DateTime? date;
    return Form(
      key: formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: AlertDialog(
        title: Text(
          'Set Reminder',
          style: theme.textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
          ),
          ElevatedButton(
            child: const Text('Save'),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.of(context)
                    .pop<Tuple4<String, String, TimeOfDay, DateTime>>(Tuple4(
                        titleController.text,
                        detailController.text,
                        time!,
                        date!));
              }
            },
          )
        ],
        actionsAlignment: MainAxisAlignment.spaceBetween,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => titleController.text.isNotEmpty
                      ? null
                      : 'Please enter a title.',
                  builder: (formContext) {
                    return TextField(
                      controller: titleController,
                      maxLines: 1,
                      maxLength: 40,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        hintText: 'Enter the reminder\'s title',
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                FormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => detailController.text.isNotEmpty
                      ? null
                      : 'Please enter a description.',
                  builder: (formContext) {
                    return TextField(
                      controller: detailController,
                      maxLines: 2,
                      maxLength: 100,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        hintText: 'Enter some details',
                        border: OutlineInputBorder(),
                      ),
                    );
                  },
                ),
                FormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) => (time != null &&
                          toDouble(time!) > toDouble(TimeOfDay.now()))
                      ? null
                      : 'Please set a time.',
                  builder: (formContext) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.schedule_rounded),
                            label: Text(
                                time != null ? time.toString() : 'Set a time'),
                            onPressed: () => showTimePicker(
                              context: context,
                              initialTime: time ?? TimeOfDay.now(),
                            ).then((value) {
                              setState(() {
                                time = value;
                              });
                            }),
                          ),
                        )
                      ],
                    );
                  },
                ),
                FormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) =>
                      date != null ? null : 'Please pick a date.',
                  builder: (formContext) {
                    return Row(
                      children: [
                        Expanded(
                          child: TextButton.icon(
                            icon: const Icon(Icons.calendar_today_rounded),
                            label: Text(
                                date != null ? date.toString() : 'Pick a date'),
                            onPressed: () => showDatePicker(
                              initialDatePickerMode: DatePickerMode.day,
                              context: context,
                              initialDate: date ?? DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.utc(3000),
                            ).then((value) {
                              setState(() {
                                date = value;
                              });
                            }),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
