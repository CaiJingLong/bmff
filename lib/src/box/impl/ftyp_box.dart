import 'package:bmff/bmff.dart';

/// {@template bmff.ftyp_box}
///
/// The file type box.
///
/// The file type box contains the major brand and minor version of the file.
///
/// Some file type have more than one compatible versions, it may be empty.
///
/// {@endtemplate}
class FtypBox extends BmffBox {
  /// {@macro bmff.ftyp_box}
  FtypBox({
    required BmffContext context,
    required int size,
    required String type,
    required int dataSize,
    required int startOffset,
  }) : super(
          context: context,
          size: size,
          type: type,
          extendedSize: 0,
          startOffset: startOffset,
        );

  /// Major brand.
  late String majorBrand =
      context.getRangeData(startOffset + 8, startOffset + 12).toAsciiString();

  /// Minor version.
  late String minorVersion =
      context.getRangeData(startOffset + 12, startOffset + 16).toAsciiString();

  /// Compatible brands. it may be empty.
  late List<String> compatibleBrands = _getCompatibleVersions();

  /// See [compatibleBrands].
  List<String> _getCompatibleVersions() {
    final compatibleVersions = <String>[];
    var index = startOffset + 16;
    while (index < realSize) {
      compatibleVersions
          .add(context.getRangeData(index, index + 4).toAsciiString());
      index += 4;
    }
    return compatibleVersions;
  }
}
