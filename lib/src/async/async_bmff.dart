import 'dart:collection';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/box_factory.dart';
import 'package:bmff/src/box_base.dart';

class AsyncBmff extends UnmodifiableMapBase<String, AsyncBmffBox> {
  AsyncBmff(this.context);

  final AsyncBmffContext context;

  Future<void> init() async {
    _values = await AsyncBoxFactory().decodeAsyncBoxes(this);
  }

  List<AsyncBmffBox> _values = [];

  List<AsyncBmffBox> get childBoxes => _values;

  @override
  AsyncBmffBox operator [](Object? key) {
    if (key is String) {
      return childBoxes.firstWhere(
        (element) => element.type == key,
        orElse: () => throw NotFoundException(
          'Not found AsyncBmffBox with $key.',
        ),
      );
    }
    throw NotFoundException('Not found AsyncBmffBox with $key.');
  }

  @override
  Iterable<String> get keys => childBoxes.map((e) => e.type);
}

class AsyncBmffBox extends BmffBoxBase {
  AsyncBmffBox({
    required this.context,
    required int size,
    required String type,
    required int realSize,
    required int startOffset,
  }) : super(
          size: size,
          type: type,
          realSize: realSize,
          startOffset: startOffset,
        );

  final AsyncBmffContext context;

  final List<AsyncBmffBox> childBoxes = [];

  void addChild(AsyncBmffBox box) {
    childBoxes.add(box);
  }

  /// Get data of the box.
  Future<ByteBuffer> getByteBuffer() async {
    final list = await context.getRangeData(dataStartOffset, endOffset);
    return Uint8List.fromList(list).buffer;
  }

  /// Get the box data from the start offset to the end offset.
  ///
  /// Ignore the header and extended data.
  Future<List<int>> getRangeData(int start, int end) {
    return context.getRangeData(dataStartOffset + start, dataStartOffset + end);
  }

  /// Get the box data from the [start] offset and [length].
  ///
  /// Ignore the header and extended data.
  Future<List<int>> getRangeDataByLength(int start, int length) {
    return context.getRangeData(
        dataStartOffset + start, dataStartOffset + start + length);
  }
}
