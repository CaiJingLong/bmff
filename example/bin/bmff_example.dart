import 'package:bmff/bmff.dart';

void main() {
  final assetPath = 'assets/compare_still_1.heic';
  final bmff = Bmff.file(assetPath);

  final boxes = bmff.childBoxes;
  for (final box in boxes) {
    print(box);
  }
}
