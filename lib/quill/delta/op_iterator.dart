import 'op.dart';

// https://github.com/quilljs/delta/blob/main/src/OpIterator.ts
class OpIterator {
  List<Op> _ops;
  int index;
  int offset;

  OpIterator(this._ops, {this.index = 0, this.offset = 0});

  bool hasNext() {
    // TODO: Implement
    return false;
  }

  Op next(int? length) {
    // TODO: Implement
    return Op(key: OperationKey.insert);
  }

  Op peek() {
    // TODO: Implement
    return Op(key: OperationKey.insert);
  }

  int peekLength() {
    // TODO: Implement
    return 0;
  }

  OperationKey peekType() {
    // TODO: Implement
    return OperationKey.insert;
  }

  List<Op> rest() {
    // TODO: Implement
    return [];
  }
}
