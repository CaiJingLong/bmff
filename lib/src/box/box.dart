import 'dart:developer';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';
import 'package:bmff/src/box_base.dart';

import '../factory/box_factory.dart';

/// {@template bmff.bmff_box}
///
/// A base class for all BMFF boxes.
///
/// Some boxes are not defined in the standard.
///
/// {@endtemplate}
///
/// See also [AsyncBmffBox].
class BmffBox extends BmffBoxBase {
  /// {@macro bmff.bmff_box}
  BmffBox({
    required this.context,
    required int startOffset,
    required int size,
    required String type,
    required int realSize,
  }) : super(
          realSize: realSize,
          startOffset: startOffset,
          size: size,
          type: type,
        );

  /// {@macro bmff.bmff_context}
  final BmffContext context;

  /// The parent box of this box, or null if this box is the root box.
  BmffBox? parent;

  /// The child boxes of the box.
  List<BmffBox> get childBoxes => _decodeChildBoxes();

  List<BmffBox>? _values;

  @override
  set forceFullBox(bool? forceFullBox) {
    super.forceFullBox = forceFullBox;
    _values = null;
  }

  BmffBox operator [](Object? key) {
    if (key is String) {
      return childBoxes.firstWhere(
        (element) => element.type == key,
        orElse: () => throw NotFoundException(
          'Not found BmffBox with $key.',
        ),
      );
    }
    throw NotFoundException('Not found BmffBox with $key.');
  }

  /// See [childBoxes].
  List<BmffBox> _decodeChildBoxes() {
    if (_values != null) {
      return _values!;
    }

    try {
      final result = <BmffBox>[];

      var currentIndex = startOffset + headerSize + extendInfoSize;

      final factory = BoxFactory();

      while (currentIndex < endOffset) {
        final box = factory.makeBox(context, currentIndex, parent: this);
        result.add(box);
        currentIndex = box.endOffset;
      }

      return result;
    } catch (e) {
      // Here, all data is directly parsed as a box. When an error occurs,
      // it is regarded as no sub box.
      log('Error occurred when decoding child boxes: $e');
      return [];
    }
  }

  /// Get data of the box.
  ByteBuffer getByteBuffer() {
    final list = context.getRangeData(dataStartOffset, endOffset);
    return Uint8List.fromList(list).buffer;
  }

  /// Get the box data from the start offset to the end offset.
  ///
  /// Ignore the header and extended data.
  List<int> getRangeData(int start, int end) {
    return context.getRangeData(dataStartOffset + start, dataStartOffset + end);
  }

  /// Get the box data from the [start] offset and [length].
  ///
  /// Ignore the header and extended data.
  List<int> getRangeDataByLength(int start, int length) {
    return context.getRangeData(
        dataStartOffset + start, dataStartOffset + start + length);
  }

  @override
  String toString() {
    return '$type (len = $realSize, start = $startOffset, end = $endOffset)';
  }

  @override
  BaseBmffContext get baseContext => context;
}

/// {@template bmff.async_bmff_box}
///
/// An asynchronous version of BMFF box.
///
/// {@endtemplate}
///
/// See also [BmffBox].
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

  Future<void> init() async {
    final children = await AsyncBoxFactory().decodeChildBoxes(this);
    childBoxes.addAll(children);

    for (final child in children) {
      await child.init();
    }
  }

  Future<void> updateForceFullBox(bool? forceFullBox) async {
    super.forceFullBox = forceFullBox;
    await _updateChildBoxes();
  }

  Future<void> _updateChildBoxes() async {
    childBoxes.clear();
    await init();
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

  AsyncBmffBox operator [](Object? key) {
    if (key is String) {
      return childBoxes.firstWhere(
        (element) => element.type == key,
        orElse: () => throw NotFoundException(
          'Not found BmffBox with $key.',
        ),
      );
    }
    throw NotFoundException('Not found BmffBox with $key.');
  }

  @override
  String toString() {
    return '$type (len = $realSize, start = $startOffset, end = $endOffset)';
  }

  @override
  BaseBmffContext get baseContext => context;
}
