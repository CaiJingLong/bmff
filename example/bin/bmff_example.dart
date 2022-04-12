import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:bmff/bmff_io.dart';

void main() {
  final assetPath = 'assets/compare_still_1.heic';
  final file = File(assetPath);
  final context = BmffIoContext(file);

  final boxes = Bmff(context).decodeBox();
  for (final box in boxes) {
    print(box);
  }
}
