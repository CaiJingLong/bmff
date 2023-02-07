import 'package:bmff/bmff.dart';
import 'package:bmff/src/factory/box_factory.dart';
import 'package:bmff/src/box/full_box_type.dart';
import 'package:bmff/src/box/impl/bmff_impl.dart';

import 'stub.dart'
    if (dart.library.io) 'io_impl.dart'
    if (dart.library.html) 'web_impl.dart';

///
/// The BMFF library.
///
/// Example:
///
/// {@template bmff.bmff_example}
///
/// ```dart
/// import 'package:bmff/bmff.dart';
///
/// void main() {
///   final assetPath = 'assets/compare_still_1.heic';
///   final bmff =
///       Bmff.file(assetPath); // The path is file path, not flutter asset path.
///
///   final boxes = bmff.childBoxes;
///   for (final box in boxes) {
///     print(box);
///   }
///
///   showFtyp(bmff);
/// }
///
/// void useByteListSource(List<int> bytes) {
///   final bmff = Bmff.memory(bytes);
///   final boxes = bmff.childBoxes;
///   for (final box in boxes) {
///     print(box);
///   }
/// }
///
/// void showFtyp(Bmff bmff) {
///   final typeBox = bmff.typeBox;
///   final type = typeBox.type;
///
///   final majorBrand = typeBox.majorBrand;
///   final minorVersion = typeBox.minorVersion;
///   final compatibleBrands = typeBox.compatibleBrands;
///
///   print('type: $type');
///   print('majorBrand: $majorBrand');
///   print('minorVersion: $minorVersion');
///   print('compatibleBrands: $compatibleBrands');
/// }
///
/// ```
/// {@endtemplate}
abstract class Bmff extends BoxContainer {
  Bmff();

  /// Create [Bmff] from file path.
  ///
  /// {@macro bmff.bmff_for_web}
  ///
  /// {@macro bmff.bmff_example}
  factory Bmff.file(
    String path, {
    List<String> fullBoxtypes = fullBoxType,
  }) {
    return createBmffFromFile(path);
  }

  /// Create [Bmff] from [bytes].
  ///
  /// {@macro bmff.bmff_example}
  factory Bmff.memory(
    List<int> bytes, {
    List<String> fullBoxTypes = fullBoxType,
  }) {
    return ContextBmffImpl(BmffMemoryContext(
      bytes,
      fullBoxTypes: fullBoxTypes,
    ));
  }

  /// Type box
  FtypBox get typeBox => this['ftyp'] as FtypBox;

  /// Type of the BMFF file.
  String get type => typeBox.type;

  @override
  late List<BmffBox> childBoxes;

  /// {@macro bmff.async_bmff}
  static Future<AsyncBmff> asyncContext(AsyncBmffContext context) async {
    return AsyncBoxFactory().createBmffByAsync(context);
  }
}
