import 'dart:io';

import 'package:bmff/bmff_io.dart';

void main() {
  final assetPath = 'assets/compare_still_1.heic';
  final file = File(assetPath);
  final bmff = BmffIoContext(file).bmff;

  final boxes = bmff.childBoxes;
  for (final box in boxes) {
    print(box);
  }
}
