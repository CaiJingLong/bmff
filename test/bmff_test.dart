import 'package:bmff/bmff.dart';
import 'package:test/test.dart';

void main() {
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

  test('Test box size', () {
    expect(bmff['ftyp'].size, equals(24));
    expect(bmff['meta'].size, equals(315));
    expect(bmff['mdat'].size, equals(37933));
  });
}
