import 'package:bmff/bmff.dart';

/// {@template bmff.bmff_box}
///
/// A base class for all BMFF boxes.
///
/// Some boxes are not defined in the standard.
///
/// {@endtemplate}
class BmffBox {
  /// {@macro bmff.bmff_box}
  BmffBox({
    required this.context,
    required this.size,
    required this.type,
    required this.extendedSize,
    required this.startOffset,
  });

  /// {@macro bmff.bmff_context}
  final BmffContext context;

  /// The size of the box. Contains the header size.
  final int size;

  /// The type of the box.
  final String type;

  /// If the box is full box, it contains the extended size. Otherwise, it is 0.
  final int extendedSize;

  /// The start offset of the box.
  final int startOffset;

  /// The end offset of the box.
  late int endOffset = getEndOffset();

  /// See [endOffset].
  int getEndOffset() {
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

  @override
  String toString() {
    final realSize = extendedSize != 0 ? extendedSize : size;

    return '$type (len = $realSize)';
  }
}
