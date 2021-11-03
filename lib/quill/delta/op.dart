///
/// op.dart
///
/// Copyright (c) 2021 David Barsamian.
///

// https://github.com/quilljs/delta/blob/main/src/Op.ts
enum OperationKey {
  insert,
  delete,
  retain,
}

/// An operation performed on a document.
class Op {
  final OperationKey key;
  int? length;
  Object? data;
  Map<String, dynamic>? attributeMap;

  Op({
    required this.key,
    this.length,
    this.data,
    this.attributeMap,
  });
}
