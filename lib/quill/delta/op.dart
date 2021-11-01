///
/// op.dart
///
/// Copyright (c) 2021 David Barsamian.
///

enum OperationKey {
  insert,
  delete,
  retain,
}

/// An operation performed on a document.
class Op {
  final OperationKey key;
  final int? length;
  final Object? data;
  final Map<String, dynamic>? attributeMap;

  Op({
    required this.key,
    this.length,
    this.data,
    this.attributeMap,
  });
}
