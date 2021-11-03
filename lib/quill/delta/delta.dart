//
// delta.dart
//
// Copyright (c) 2021 David Barsamian.
//

import 'op.dart';

import 'package:dart_numerics/dart_numerics.dart';

// https://github.com/quilljs/delta/blob/main/src/Delta.ts
class Delta {
  final List<Op> _ops;

  /// Default constructor. Creates Delta with list of Ops.
  Delta._(this._ops);

  /// Empty constructor.
  factory Delta() => Delta._(<Op>[]);

  Delta insert(dynamic arg, Map<String, dynamic>? attributes) {
    if (arg is String && arg.isEmpty) {
      return this;
    }
    Op newOp = Op(key: OperationKey.insert);
    newOp.data = arg;
    if (attributes != null && attributes.isNotEmpty) {
      newOp.attributeMap = attributes;
    }
    return push(newOp);
  }

  Delta delete(int length) {
    if (length <= 0) {
      return this;
    }
    return push(Op(key: OperationKey.delete, data: length));
  }

  Delta retain(int length, Map<String, dynamic>? attributes) {
    if (length <= 0) {
      return this;
    }
    Op newOp = Op(key: OperationKey.retain);
    if (attributes != null && attributes.isNotEmpty) {
      newOp.attributeMap = attributes;
    }
    return push(newOp);
  }

  Delta push(Op newOp) {
    // TODO: Implement
    return Delta();
  }

  Delta chop() {
    Op lastOp = _ops[_ops.length - 1];
    if (lastOp.key == OperationKey.retain && lastOp.attributeMap == null) {
      _ops.removeLast();
    }
    return this;
  }

  List<Op> where(bool Function(Op) predicate) {
    return _ops.where(predicate).toList();
  }

  void forEach(void Function(Op) predicate) {
    _ops.forEach(predicate);
  }

  List<T> map<T>(T Function(Op) predicate) {
    return _ops.map(predicate).toList();
  }

  Delta slice({int start = 0, int end = int64MaxValue}) {
    // TODO: Implement
    return Delta();
  }

  Delta compose(Delta other) {
    // TODO: Implement
    return Delta();
  }

  Delta concat(Delta other) {
    // TODO: Implement
    return Delta();
  }

  Delta diff(Delta other) {
    // TODO: Implement
    return Delta();
  }

  void eachLine(
      Function(Delta line, Map<String, dynamic> attributes, int index)
          predicate,
      {String newline = '\n'}) {
    // TODO: Implement
  }

  Delta invert(Delta base) {
    // TODO: Implement
    return Delta();
  }

  Delta transform(Delta other, bool priority) {
    // TODO: Implement
    return other;
  }

  int transformPosition(int index, bool priority) {
    // TODO: Implement
    return index;
  }
}
