import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/box_factory.dart';
import 'package:bmff/src/box/impl/bmff_impl.dart';

/// {@template bmff.bmff_context}
///
/// The context of a BMFF file.
///
/// The context contains the boxes.
///
/// User need to implement [getRangeData], and [length].
///
/// {@endtemplate}
abstract class BmffContext {
  /// The boxes of the context.
  final boxes = <BmffBox>[];

  /// The FTYP box of the context.
  late FtypBox ftypeBox;

  /// The length of the context.
  int get length;

  /// Get the data of the context.
  List<int> getRangeData(
    int start,
    int end,
  );

  /// Release the context.
  void close();

  /// {@macro bmff.box_factory}
  final _boxFactory = BoxFactory();

  void resgiterBox(BmffBox box) {
    boxes.add(box);
  }

  /// Decode [BmffBox] from [startIndex].
  BmffBox makeBox({required int startIndex, BmffBox? parent}) {
    return _boxFactory.makeBox(this, startIndex, parent: parent);
  }

  late Bmff bmff = ContextBmffImpl(this);
}

/// {@template bmff.BmffMemoryContext}
///
/// The context of a BMFF file in memory.
///
/// {@endtemplate}
class BmffMemoryContext extends BmffContext {
  /// {@macro bmff.BmffMemoryContext}
  BmffMemoryContext(this.bytes);

  /// The bytes of the context.
  final List<int> bytes;

  @override
  int get length => bytes.length;

  @override
  List<int> getRangeData(
    int start,
    int end,
  ) {
    return bytes.sublist(start, end);
  }

  @override
  void close() {}
}

typedef LengthGetter = Future<int> Function();
typedef RangeDataGetter = Future<List<int>> Function(int start, int end);

abstract class AsyncBmffContext {
  const AsyncBmffContext();

  Future<int> lengthAsync();

  Future<List<int>> getRangeData(int start, int end);
}

class MemoryAsyncBmffContext extends AsyncBmffContext {
  MemoryAsyncBmffContext(this.lengthAsyncGetter, this.rangeDataGetter);

  final LengthGetter lengthAsyncGetter;
  final RangeDataGetter rangeDataGetter;

  @override
  Future<int> lengthAsync() {
    return lengthAsyncGetter();
  }

  @override
  Future<List<int>> getRangeData(int start, int end) {
    return rangeDataGetter.call(start, end);
  }
}
