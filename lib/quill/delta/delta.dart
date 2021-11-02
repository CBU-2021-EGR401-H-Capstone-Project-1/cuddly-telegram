//
// delta.dart
//
// Copyright (c) 2021 David Barsamian.
//

import 'op.dart';

class Delta {
  final List<Op> _ops;

  /// Default constructor. Creates Delta with list of Ops.
  Delta._(this._ops);

  // Empty constructor.
  factory Delta() => Delta._(<Op>[]);

  Delta insert(Map<String, dynamic> args, Map<String, dynamic> attributes) {
    // TODO: Implement
    return Delta();
  }

  Delta delete(int length) {
    // TODO: Implement
    return Delta();
  }

  Delta retain(int length, Map<String, dynamic> attributes) {
    // TODO: Implement
    return Delta();
  }

  Delta push(Op newOp) {
    // TODO: Implement
    return Delta();
  }

  Delta chop() {
    // TODO: Implement
    return Delta();
  }

  List<Op> where(bool Function(Op) predicate) {
    return _ops.where(predicate).toList();
  }

  void forEach(void Function(Op) predicate) {
    _ops.forEach(predicate);
  }

  
}
