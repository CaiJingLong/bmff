import 'dart:convert';

import 'package:bmff/bmff.dart';

/// {@template bmff.box_factory}
///
/// The factory of [BmffBox].
///
/// {@endtemplate}
class BoxFactory {
  BmffBox makeBox(BmffContext context, int startIndex, {BmffBox? parent}) {
    final box = _makeBox(context, startIndex);
    box.parent = parent;
    if (parent != null && box.endOffset > parent.endOffset) {
      throw Exception('Invalid box, end offset is larger than parent');
    }
    return box;
  }

  BmffBox _makeBox(BmffContext context, int startIndex) {
    final size =
        context.getRangeData(startIndex, startIndex + 4).toBigEndian(4);
    final typeData = context.getRangeData(startIndex + 4, startIndex + 8);
    // print('type: ${typeData.toAsciiString()}');
    // print('size: $size');
    _checkType(typeData);

    final type = typeData.toAsciiString();

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
          context.getRangeData(startIndex + 8, startIndex + 16).toBigEndian(8);

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
      return FtypBox(
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

  void _checkType(List<int> typeData) {
    // type data must a-zA-Z0-9
    for (final value in typeData) {
      if (!((value >= 0x41 && value <= 0x5a) ||
          (value >= 0x61 && value <= 0x7a) ||
          (value >= 0x30 && value <= 0x39))) {
        throw Exception(
            'Invalid box type, the type char list is ${ascii.decode(typeData)}');
      }
    }
  }
}
