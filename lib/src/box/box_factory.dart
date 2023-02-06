import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bmff/bmff.dart';

void _checkType(List<int> typeData) {
  // type data must a-zA-Z0-9
  for (final value in typeData) {
    if (!((value >= 0x41 && value <= 0x5a) ||
        (value >= 0x61 && value <= 0x7a) ||
        (value >= 0x30 && value <= 0x39))) {
      final hex = typeData.map((e) => e.toRadixString(16)).join(' ');
      final errorLog =
          'Invalid box type, the type char list is ${ascii.decode(typeData)}, hex: $hex';
      log(errorLog);
      throw Exception(errorLog);
    }
  }
}

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

    var realSize = size;
    if (size == 1) {
      realSize =
          context.getRangeData(startIndex + 8, startIndex + 16).toBigEndian(8);
    }

    return _createBmffBox(typeData, size, context, startIndex, realSize);
  }

  BmffBox _createBmffBox(
    List<int> typeData,
    int size,
    BmffContext context,
    int startIndex,
    int realSize,
  ) {
    final type = typeData.toAsciiString();

    if (size == 0) {
      return BmffBox(
        context: context,
        size: size,
        type: type,
        realSize: realSize,
        startOffset: startIndex,
      );
    }

    if (size < 8 && size != 1) {
      final paramLog =
          'size: $size, type: $type, startIndex: $startIndex, realSize: $realSize';
      throw Exception('Invalid size, size must be greater than 8, $paramLog');
    }

    if (type == 'ftyp') {
      return FtypBox(
        context: context,
        size: size,
        type: type,
        realSize: realSize,
        startOffset: startIndex,
      );
    }

    return BmffBox(
      context: context,
      size: size,
      type: type,
      realSize: realSize,
      startOffset: startIndex,
    );
  }
}

class AsyncBoxFactory {
  FutureOr<AsyncBmff> createBmffByAsync(AsyncBmffContext context) async {
    final bmff = AsyncBmff(context);

    await bmff.init();

    for (final child in bmff.childBoxes) {
      await child.init();
    }

    return bmff;
  }

  Future<List<AsyncBmffBox>> decodeAsyncBoxes(AsyncBmff bmff) async {
    final context = bmff.context;
    final length = await context.lengthAsync();
    try {
      final boxes = <AsyncBmffBox>[];

      var startOffset = 0;
      while (startOffset < length) {
        final box = await _makeBox(context, startOffset);
        boxes.add(box);
        startOffset += box.realSize;
      }

      return boxes;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<AsyncBmffBox>> decodeChildBoxes(AsyncBmffBox parent) async {
    final context = parent.context;
    try {
      final boxes = <AsyncBmffBox>[];

      var startOffset = parent.dataStartOffset;

      while (startOffset < parent.endOffset) {
        final box = await _makeBox(context, startOffset);
        if (box.endOffset > parent.endOffset) {
          throw Exception('Invalid box, end offset is larger than parent');
        }
        boxes.add(box);
        startOffset += box.realSize;
      }

      return boxes;
    } catch (e) {
      return [];
    }
  }

  Future<AsyncBmffBox> _makeBox(
      AsyncBmffContext context, int startOffset) async {
    final size = (await context.getRangeData(startOffset, startOffset + 4))
        .toBigEndian();

    final typeData =
        (await context.getRangeData(startOffset + 4, startOffset + 8))
            .toAsciiString();

    var realSize = size;
    if (size == 1) {
      realSize = (await context.getRangeData(startOffset + 8, startOffset + 16))
          .toBigEndian();
    }

    return _createBmffBox(typeData, size, context, startOffset, realSize);
  }

  AsyncBmffBox _createBmffBox(
    String type,
    int size,
    AsyncBmffContext context,
    int startOffset,
    int realSize,
  ) {
    // print('------------------------------------');
    // print('create box:');
    // print('type: $type');
    // print('size: $size');
    // print('realSize: $realSize');
    // print('startOffset: $startOffset');

    if (size == 0) {
      return AsyncBmffBox(
        context: context,
        size: size,
        type: type,
        realSize: realSize,
        startOffset: startOffset,
      );
    }

    if (size < 8 && size != 1) {
      final paramsLog = 'size: $size, type: $type, startOffset: $startOffset, '
          'realSize: $realSize';
      throw Exception('Invalid size, current params: $paramsLog');
    }

    if (type == 'ftyp') {
      return AsyncFtypBox(
        context: context,
        size: size,
        type: type,
        realSize: realSize,
        startOffset: startOffset,
      );
    }

    return AsyncBmffBox(
      context: context,
      size: size,
      type: type,
      realSize: realSize,
      startOffset: startOffset,
    );
  }
}
