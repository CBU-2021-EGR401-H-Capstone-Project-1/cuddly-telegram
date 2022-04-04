import 'package:cell_calendar/cell_calendar.dart';
import 'package:cuddly_telegram/model/journal_store.dart';
import 'package:cuddly_telegram/screens/editor_screen.dart';
import 'package:cuddly_telegram/utility/calendar_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  static const routeName = '/calendar';

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final cellCalendarPageController = CellCalendarPageController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar"),
      ),
      body: Consumer<JournalStore>(builder: (context, journalStore, child) {
        final events = calendarEvents(context);
        return CellCalendar(
          cellCalendarPageController: cellCalendarPageController,
          events: events,
          daysOfTheWeekBuilder: (dayIndex) {
            final labels = ["S", "M", "T", "W", "T", "F", "S"];
            return Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                labels[dayIndex],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            );
          },
          monthYearLabelBuilder: (datetime) {
            final year = datetime!.year.toString();
            final month = datetime.month.monthName;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const SizedBox(width: 16),
                  Text(
                    "$month  $year",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () {
                      cellCalendarPageController.animateToDate(
                        DateTime.now(),
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
                  )
                ],
              ),
            );
          },
          onCellTapped: (date) {
            final eventsOnTheDate = events.where((event) {
              final eventDate = event.eventDate;
              return eventDate.year == date.year &&
                  eventDate.month == date.month &&
                  eventDate.day == date.day;
            }).toList();
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text(date.month.monthName + " " + date.day.toString()),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: eventsOnTheDate
                      .map(
                        (event) => Material(
                          child: Ink(
                            decoration: BoxDecoration(
                              color: event.eventBackgroundColor,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: InkWell(
                              onTap: () => {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditorScreen(
                                        journal: journalStore.journals
                                            .firstWhere((element) =>
                                                element.calendarDate ==
                                                event.eventDate))))
                              },
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                child: Text(
                                  event.eventName,
                                  style: TextStyle(
                                    color: event.eventTextColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          },
          onPageChanged: (firstDate, lastDate) {
            /// Called when the page was changed
            /// Fetch additional events by using the range between [firstDate] and [lastDate] if you want
          },
        );
      }),
    );
  }
}
