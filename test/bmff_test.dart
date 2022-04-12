import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:bmff/bmff_io.dart';
import 'package:test/test.dart';

void main() {
  final assetFilePath = 'example/assets/compare_still_1.heic';
  late Bmff bmff;

  setUp(() {
    final file = File(assetFilePath);
    BmffIoContext context = BmffIoContext(file);
    bmff = Bmff(context);
  });

  test('Test box count', () {
    final box = bmff.decodeBox();
    expect(box.length, equals(3));
  });

  test('Test box type', () {
    final box = bmff.decodeBox();
    expect(box[0].type, equals('ftyp'));
    expect(box[1].type, equals('meta'));
    expect(box[2].type, equals('mdat'));
  });
}
