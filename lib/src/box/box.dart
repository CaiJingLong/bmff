import 'dart:developer';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';
import 'package:bmff/src/box_base.dart';

/// {@template bmff.bmff_box}
///
/// A base class for all BMFF boxes.
///
/// Some boxes are not defined in the standard.
///
/// {@endtemplate}
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
  late List<BmffBox> childBoxes = _decodeChildBoxes();

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
    try {
      final result = <BmffBox>[];

      var currentIndex = startOffset + headerSize + extendInfoSize;

      while (currentIndex < endOffset) {
        final box = context.makeBox(startIndex: currentIndex, parent: this);
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
    return '$type (len = $realSize)';
  }
}
