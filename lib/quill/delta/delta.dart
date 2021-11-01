//
// delta.dart
//
// Copyright (c) 2021 David Barsamian.
//

import 'op.dart';

class Delta {
  final List<Op> ops;

  /// Default constructor. Creates Delta with list of Ops.
  Delta._(this.ops);

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
}
