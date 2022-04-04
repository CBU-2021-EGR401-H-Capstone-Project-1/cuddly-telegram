import 'package:cell_calendar/cell_calendar.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

List<CalendarEvent> calendarEvents(BuildContext context) {
  var journals = Provider.of<JournalStore>(context, listen: true);

  var journalsJournals = journals.journals
      .where((element) => element.calendarDate != null)
      .map((e) => CalendarEvent(eventName: e.title, eventDate: e.calendarDate!))
      .toList();

  return journalsJournals;
}
