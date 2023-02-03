import 'dart:typed_data';

import 'package:bmff/bmff.dart';

void main(List<String> args) {
  final bmff = Bmff.file('assets/compare_still_1.heic');

  final buffer = bmff['meta']['iprp']['ipco']['ispe'].getByteBuffer();

  final width = buffer.getUint32(1, Endian.big);
  final height = buffer.getUint32(2, Endian.big);

  print('width: $width, height: $height');
}
