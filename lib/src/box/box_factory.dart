import 'package:bmff/bmff.dart';

/// {@template bmff.box_factory}
///
/// The factory of [BmffBox].
///
/// {@endtemplate}
class BoxFactory {
  BmffBox makeBox(BmffContext context, int startIndex, {BmffBox? parent}) {
    final size = context.getRangeData(startIndex, startIndex + 4).toBigEndian();
    final type =
        context.getRangeData(startIndex + 4, startIndex + 8).toAsciiString();

    if (size == 0) {
      return BmffBox(
        context: context,
        size: size,
        type: type,
        extendedSize: 0,
        startOffset: startIndex,
      );
    }
    if (size == 1) {
      // Full box, read the extended size, from the next 8 bytes
      final extendedSize =
          context.getRangeData(startIndex + 8, startIndex + 16).toBigEndian();

      return BmffBox(
        context: context,
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
        context: context,
        size: size,
        type: type,
        dataSize: size - 8,
        startOffset: startIndex,
      );
    }

    return BmffBox(
      context: context,
      size: size,
      type: type,
      extendedSize: 0,
      startOffset: startIndex,
    );
  }
}
