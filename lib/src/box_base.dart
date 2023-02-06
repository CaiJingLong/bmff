import 'box/full_box_type.dart';

class BmffBoxBase {
  /// The size of the box. Contains the header size.
  final int size;

  /// The type of the box.
  final String type;

  /// The box real size;
  final int realSize;

  /// The start offset of the box.
  final int startOffset;

  BmffBoxBase({
    required this.size,
    required this.type,
    required this.realSize,
    required this.startOffset,
  });

  /// Whether the box is large box.
  bool get isLargeBox => size == 1;

  /// Whether the box is a full box.
  bool get isFullBox {
    return fullBoxType.contains(type);
  }

  /// The end offset of the box.
  late int endOffset = _getEndOffset();

  /// See [endOffset].
  int _getEndOffset() {
    return startOffset + realSize;
  }

  late int dataStartOffset = startOffset + headerSize + extendInfoSize;

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
  int get extendInfoSize => isFullBox ? 4 : 0;
}