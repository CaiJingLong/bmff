import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:bmff/bmff.dart';

List<int> makeList(String str) {
  return str.split(' ').map((e) => int.parse(e, radix: 16)).toList();
}

void main() {
  group('Test BmffListExtension', () {
    test('toUint', () {
      expect(makeList('03 8A').toUint(2, Endian.big), equals(906));
      expect(makeList('07 78').toUint(2, Endian.big), equals(1912));
    });
  });
}
