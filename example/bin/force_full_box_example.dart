import 'package:bmff/bmff.dart';

void main(List<String> args) {
  final bmff = Bmff.file('assets/compare_still_1.heic');

  final meta = bmff['meta'];

  print(meta.childBoxes);

  meta.forceFullBox = false;

  print(meta.childBoxes);
}
