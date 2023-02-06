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
  FtypBox({
    required BmffContext context,
    required int startOffset,
    required int size,
    required String type,
    required int realSize,
  }) : super(
          context: context,
          startOffset: startOffset,
          size: size,
          type: type,
          realSize: realSize,
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

class AsyncFtypBox extends AsyncBmffBox {
  AsyncFtypBox({
    required AsyncBmffContext context,
    required int startOffset,
    required int size,
    required String type,
    required int realSize,
  }) : super(
          context: context,
          startOffset: startOffset,
          size: size,
          type: type,
          realSize: realSize,
        );

  @override
  Future<void> init() async {
    majorBrand = await context
        .getRangeData(startOffset + 8, startOffset + 12)
        .then((value) => value.toAsciiString());
    minorVersion = await context
        .getRangeData(startOffset + 12, startOffset + 16)
        .then((value) => value.toAsciiString());
    compatibleBrands = await _getCompatibleVersions();
  }

  /// Major brand.
  late String majorBrand;

  /// Minor version.
  late String minorVersion;

  /// Compatible brands. it may be empty.
  late List<String> compatibleBrands;

  Future<List<String>> _getCompatibleVersions() async {
    final compatibleVersions = <String>[];
    var index = startOffset + 16;
    while (index < realSize) {
      compatibleVersions.add(await context
          .getRangeData(index, index + 4)
          .then((value) => value.toAsciiString()));
      index += 4;
    }
    return compatibleVersions;
  }
}
