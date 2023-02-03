import 'dart:io';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';
import 'package:bmff/bmff_io.dart';

void main(List<String> args) {
  final file = File('assets/compare_still_1.heic');
  final bmff = BmffIoContext(file).bmff;
  // final boxes = bmff.decodeBox();

  final buffer = bmff['meta']['iprp']['ipco']['ispe'].getByteBuffer();

  final width = buffer.getUint32(1, Endian.big);
  final height = buffer.getUint32(2, Endian.big);

  print('width: $width, height: $height');
}
