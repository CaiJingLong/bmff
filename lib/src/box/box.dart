import 'dart:typed_data';

import 'package:bmff/bmff.dart';

/// {@template bmff.bmff_box}
///
/// A base class for all BMFF boxes.
///
/// Some boxes are not defined in the standard.
///
/// {@endtemplate}
class BmffBox with BoxContainer {
  /// {@macro bmff.bmff_box}
  BmffBox({
    required this.context,
    required this.size,
    required this.type,
    required this.extendedSize,
    required this.startOffset,
    this.extendInfoSize = 0,
  });

  /// {@macro bmff.bmff_context}
  final BmffContext context;

  /// The parent box of this box, or null if this box is the root box.
  BmffBox? parent;

  /// The size of the box. Contains the header size.
  final int size;

  /// The type of the box.
  final String type;

  /// If the box is full box, it contains the extended size. Otherwise, it is 0.
  final int extendedSize;

  /// Whether the box is full box.
  bool get isFullBox => size == 1;

  /// The box real size;
  int get realSize {
    if (isFullBox) {
      return extendedSize;
    } else {
      return size;
    }
  }

  /// The start offset of the box.
  final int startOffset;

  /// The end offset of the box.
  late int endOffset = _getEndOffset();

  /// See [endOffset].
  int _getEndOffset() {
    if (size == 0) {
      return startOffset + 8;
    }
    if (size == 1) {
      // full box, read the extended size, from the next 8 bytes
      return startOffset + extendedSize;
    }

    if (size < 8) {
      throw Exception('Invalid size');
    }

    return startOffset + size;
  }

  /// The header size of the box.
  int get headerSize {
    if (size == 0) {
      return 8;
    }
    if (size == 1) {
      // full box, read the extended size, from the next 8 bytes
      return 16;
    }

    return 8;
  }

  /// Some boxes have some extended data.
  /// For example, meta of heic have 4 bytes extended data.
  int extendInfoSize;

  /// The child boxes of the box.
  @override
  late List<BmffBox> childBoxes = _decodeChildBoxes();

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
      return [];
    }
  }

  /// The data size of the box.
  int get dataSize {
    return endOffset - startOffset - headerSize - extendInfoSize;
  }

  late int dataStartOffset = _dataStartOffset();

  int _dataStartOffset() {
    return startOffset + headerSize + extendInfoSize;
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

  @override
  String toString() {
    final realSize = extendedSize != 0 ? extendedSize : size;

    return '$type (len = $realSize)';
  }
}
