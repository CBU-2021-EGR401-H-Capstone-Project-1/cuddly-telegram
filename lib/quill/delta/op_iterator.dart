import 'op.dart';

// https://github.com/quilljs/delta/blob/main/src/OpIterator.ts
class OpIterator {
  final List<Op> _ops;
  int index;
  int offset;

  OpIterator(this._ops, {this.index = 0, this.offset = 0});

  bool hasNext() {
    return peekLength() < _ops.length;
  }

  Op next(int? length) {
    length ??= _ops.length; // If null, set equal to _ops.length
    final nextOp = _ops[index];
    final opLength = nextOp.length ??= 0;
    if (length >= opLength - offset) {
      length = opLength - offset;
      index += 1;
      offset = 0;
    } else {
      offset += length;
    }
    switch (nextOp.key) {
      case OperationKey.delete:
        return Op(key: OperationKey.delete, data: length);
      case OperationKey.retain:
        Op op = Op(key: OperationKey.retain, data: length);
        if (nextOp.attributeMap != null) {
          op.attributeMap = nextOp.attributeMap;
        }
        return op;
      case OperationKey.insert:
        Op op = Op(key: OperationKey.insert);
        if (nextOp.attributeMap != null) {
          op.attributeMap = nextOp.attributeMap;
        }
        if (nextOp.data is String) {
          op.data = (nextOp.data as String).substring(offset, length);
        } else {
          op.data = nextOp.data;
        }
        return op;
    }
  }

  Op peek() {
    return _ops[index];
  }

  int peekLength() {
    final op = _ops[index];
    if (op.length != null) {
      return op.length! - offset;
    }
    return _ops.length;
  }

  OperationKey peekType() {
    return _ops[index].key;
  }

  List<Op> rest() {
    if (!hasNext()) {
      return [];
    } else if (offset == 0) {
      return _ops;
    } else {
      return _ops.getRange(offset, _ops.length - 1).toList();
    }
  }
}
