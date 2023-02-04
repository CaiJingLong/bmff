import 'package:bmff/bmff.dart';

void main() {
  final assetPath = 'assets/compare_still_1.heic';
  final bmff =
      Bmff.file(assetPath); // The path is file path, not flutter asset path.

  final boxes = bmff.childBoxes;
  for (final box in boxes) {
    print(box);
  }

  showFtyp(bmff);
}

void useByteListSource(List<int> bytes) {
  final bmff = Bmff.memory(bytes);
  final boxes = bmff.childBoxes;
  for (final box in boxes) {
    print(box);
  }
}

void showFtyp(Bmff bmff) {
  final typeBox = bmff.typeBox;
  final type = typeBox.type;

  final majorBrand = typeBox.majorBrand;
  final minorVersion = typeBox.minorVersion;
  final compatibleBrands = typeBox.compatibleBrands;

  print('type: $type');
  print('majorBrand: $majorBrand');
  print('minorVersion: $minorVersion');
  print('compatibleBrands: $compatibleBrands');
}
