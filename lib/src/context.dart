import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/impl/bmff_impl.dart';

import 'box/full_box_type.dart';

/// Some base configurations.
abstract class BaseBmffContext {
  /// Some base configurations.
  const BaseBmffContext([
    this.fullBoxTypes = fullBoxType,
  ]);

  /// You can use your own full box types.
  ///
  /// Because some boxes are not defined in the standard.
  ///
  ///
  final List<String> fullBoxTypes;

  /// Whether the box is a full box.
  bool isFullBox(String type) {
    return fullBoxTypes.contains(type);
  }
}

/// {@template bmff.bmff_context}
///
/// The context of a BMFF file.
///
/// The context contains the boxes.
///
/// User need to implement [getRangeData], and [length].
///
/// {@endtemplate}
abstract class BmffContext extends BaseBmffContext {
  /// The length of the context.
  int get length;

  /// Get the data of the context.
  List<int> getRangeData(
    int start,
    int end,
  );

  /// Release the context.
  void close();

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

/// {@template bmff.AsyncBmffContext}
///
/// The async context of a BMFF file.
///
/// {@endtemplate}
abstract class AsyncBmffContext extends BaseBmffContext {
  const AsyncBmffContext();

  /// The length of the context.
  Future<int> lengthAsync();

  /// Get the data from [start] to [end].
  Future<List<int>> getRangeData(int start, int end);

  /// Create a [AsyncBmffContext] from [bytes].
  factory AsyncBmffContext.memory(List<int> bytes) {
    return MemoryAsyncBmffContext(
      () async => bytes.length,
      (start, end) async => bytes.sublist(start, end),
    );
  }
}

/// {@template bmff.MemoryAsyncBmffContext}
///
/// The context of a BMFF file in memory.
///
/// {@endtemplate}
class MemoryAsyncBmffContext extends AsyncBmffContext {
  /// {@macro bmff.MemoryAsyncBmffContext}
  const MemoryAsyncBmffContext(this.lengthAsyncGetter, this.rangeDataGetter);

  /// Get the length of the context.
  final LengthGetter lengthAsyncGetter;

  /// Get the data of the context.
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
