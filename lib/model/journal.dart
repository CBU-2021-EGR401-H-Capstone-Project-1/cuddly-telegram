import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';

part 'journal.g.dart';

var uuid = const Uuid();

/// A model of a journal entry, containing an identifier, title, document body, date-created timestamp.
/// Optionally, these models may include a latitude/longitude as well as a list of reminders.
@JsonSerializable()
@_QuillDocumentConverter()
class Journal {
  String id = uuid.v4();
  String title;
  quill.Document document;
  late DateTime dateCreated = DateTime.now();
  // TODO Latitude/longitude
  double? latitude;
  double? longitude;
  // TODO Reminders/notifications
  DateTime? calendarDate;

  Journal({required this.title, required this.document});

  factory Journal.fromJson(Map<String, dynamic> json) =>
      _$JournalFromJson(json);

  Map<String, dynamic> toJson() => _$JournalToJson(this);

  @override
  String toString() {
    return 'Journal id=$id title=$title document=$document dateCreated=$dateCreated latitude=$latitude longitude=$longitude';
  }
}

class _QuillDocumentConverter
    implements JsonConverter<quill.Document, List<dynamic>> {
  const _QuillDocumentConverter();

  @override
  quill.Document fromJson(List<dynamic> json) => quill.Document.fromJson(json);

  @override
  List<dynamic> toJson(quill.Document document) => document.toDelta().toJson();
}
