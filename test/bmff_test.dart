import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:test/test.dart';

void main() {
  group('Test sync bmff', () {
    final assetFilePath = 'example/assets/compare_still_1.heic';
    late Bmff bmff = Bmff.file(assetFilePath);

    test('Test box count', () {
      final boxes = bmff.childBoxes;
      expect(boxes.length, equals(3));
    });

    test('Test box type', () {
      final boxes = bmff.childBoxes;
      expect(boxes[0].type, equals('ftyp'));
      expect(boxes[1].type, equals('meta'));
      expect(boxes[2].type, equals('mdat'));
    });

    test('Test box realSize', () {
      expect(bmff['ftyp'].realSize, equals(24));
      expect(bmff['meta'].realSize, equals(315));
      expect(bmff['mdat'].realSize, equals(37933));
    });
  });

  group('Test async bmff', () {
    final assetFilePath = 'example/assets/compare_still_1.heic';
    final bytes = File(assetFilePath).readAsBytesSync();
    late AsyncBmff bmff;
    setUp(() async {
      bmff = await Bmff.asyncContext(MemoryAsyncBmffContext.memory(bytes));
    });

    test('Test box count', () async {
      expect(bmff.length, equals(3));
    });

    test('Test box type', () async {
      final boxes = bmff.childBoxes;
      expect(boxes[0].type, equals('ftyp'));
      expect(boxes[1].type, equals('meta'));
      expect(boxes[2].type, equals('mdat'));
    });

    test('Test box realSize', () async {
      expect((bmff['ftyp'].realSize), equals(24));
      expect((bmff['meta'].realSize), equals(315));
      expect((bmff['mdat'].realSize), equals(37933));
    });
  });
}
