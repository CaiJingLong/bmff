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
      final context = AsyncBmffContext.bytes(
        bytes,
        fullBoxTypes: [
          'meta',
          'iinf',
        ],
      );
      bmff = await Bmff.asyncContext(context);
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

    group('Test box child boxes', () {
      test('box length and level 1', () async {
        final meta = bmff['meta'];
        expect(meta.childBoxes.length, equals(6));
        expect(meta.childBoxes[0].type, equals('hdlr'));
        expect(meta.childBoxes[1].type, equals('pitm'));
        expect(meta.childBoxes[2].type, equals('iloc'));
        expect(meta.childBoxes[3].type, equals('iinf'));
        expect(meta.childBoxes[4].type, equals('iref'));
        expect(meta.childBoxes[5].type, equals('iprp'));
      });

      // test('iinf', () async {
      //   final iinf = bmff['meta']['iinf'];
      //   expect(iinf.childBoxes.length, equals(1));
      //   expect(iinf.childBoxes[0].type, equals('infe'));
      // });

      test('iprp', () async {
        final iprp = bmff['meta']['iprp'];
        expect(iprp.childBoxes.length, equals(2));
        expect(iprp.childBoxes[0].type, equals('ipco'));
        expect(iprp.childBoxes[1].type, equals('ipma'));
      });
    });
  });
}
