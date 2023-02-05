import 'dart:typed_data';

import 'package:bmff/bmff.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

void main() {
  group('Test heic', () {
    test('width and height', () {
      final bmff = Bmff.file('assets/compare_still_1.heic');

      final buffer = bmff['meta']['iprp']['ipco']['ispe'].getByteBuffer();

      final width = buffer.getUint32(1, Endian.big);
      final height = buffer.getUint32(2, Endian.big);

      expect(width, equals(1440));
      expect(height, equals(960));
    });
  });
}
