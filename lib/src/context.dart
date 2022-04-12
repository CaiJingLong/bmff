import 'package:bmff/bmff.dart';

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
  late FtypeBox ftypeBox;

  /// The length of the context.
  int get length;

  /// Get the data of the context.
  List<int> getRangeData(
    int start,
    int end,
  );

  /// Release the context.
  void close();

  /// Decode [BmffBox] from [startIndex].
  BmffBox makeBox(int startIndex) {
    final size = getRangeData(startIndex, startIndex + 4).toBigEndian();
    final type = getRangeData(startIndex + 4, startIndex + 8).toAsciiString();

    if (size == 0) {
      return BmffBox(
        context: this,
        size: size,
        type: type,
        extendedSize: 0,
        startOffset: startIndex,
      );
    }
    if (size == 1) {
      // Full box, read the extended size, from the next 8 bytes
      final extendedSize =
          getRangeData(startIndex + 8, startIndex + 16).toBigEndian();

      return BmffBox(
        context: this,
        size: 1,
        type: type,
        extendedSize: extendedSize,
        startOffset: startIndex,
      );
    }

    if (size < 8) {
      throw Exception('Invalid size');
    }

    if (type == 'ftyp') {
      return FtypeBox(
        context: this,
        size: size,
        type: type,
        dataSize: size - 8,
        startOffset: startIndex,
      );
    }

    return BmffBox(
      context: this,
      size: size,
      type: type,
      extendedSize: 0,
      startOffset: startIndex,
    );
  }
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
