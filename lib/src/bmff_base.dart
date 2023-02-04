import 'dart:collection';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';

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
class Bmff extends BoxContainer {
  /// {@macro bmff.bmff_example}
  Bmff(this.context);

  /// Create [Bmff] from file path.
  ///
  /// {@macro bmff.bmff_for_web}
  ///
  /// {@macro bmff.bmff_example}
  factory Bmff.file(String path) {
    return createBmffFromFile(path);
  }

  /// Create [Bmff] from [bytes].
  ///
  /// {@macro bmff.bmff_example}
  factory Bmff.memory(List<int> bytes) {
    return Bmff(BmffMemoryContext(bytes));
  }

  /// The context of the BMFF file.
  ///
  /// {@macro bmff.bmff_context}
  final BmffContext context;

  /// Type box
  FtypBox get typeBox => this['ftyp'] as FtypBox;

  /// Type of the BMFF file.
  String get type => typeBox.type;

  /// Decode file to [BmffBox]s.
  ///
  /// The method will add the [BmffBox]s to the [BmffContext.boxes].
  ///
  /// The box:
  /// {@macro bmff.bmff_box}
  List<BmffBox> decodeBox() {
    context.boxes.clear();

    final length = context.length;

    // decode the data
    var startIndex = 0;

    while (startIndex < length) {
      final box = context.makeBox(startIndex: startIndex, parent: null);
      context.boxes.add(box);
      startIndex += box.realSize;
    }

    final firstBox = context.boxes.first;

    if (firstBox is FtypBox) {
      context.ftypeBox = firstBox;
    }

    return context.boxes;
  }

  @override
  late List<BmffBox> childBoxes = decodeBox();
}

/// Container of [BmffBox].
///
/// use [childBoxes] to get the [List] of [BmffBox].
abstract class BoxContainer extends UnmodifiableMapBase<String, BmffBox> {
  /// The [BmffBox]s.
  List<BmffBox> get childBoxes;

  @override
  late int length = childBoxes.length;

  @override
  BmffBox operator [](Object? key) {
    if (key is String) {
      for (final box in childBoxes) {
        if (box.type == key) {
          return box;
        }
      }
    }
    throw NotFoundException('Not found BmffBox with $key.');
  }

  @override
  Iterable<String> get keys => childBoxes.map((e) => e.type);
}

/// Convert [bytes] to display text or number.
extension BmffListExtension on List<int> {
  // ignore: unused_element
  /// Convert [bytes] to [String]. and display as hex.
  String toHexString() {
    return map((i) => i.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Convert [bytes] to [String]. and display as ascii.
  String toAsciiString() {
    return map((i) => String.fromCharCode(i)).join();
  }

  /// Convert [bytes] to [int] with big endian. The number is unsigned.
  int toBigEndian([int? byteCount]) {
    byteCount ??= length;

    var result = 0;
    for (var i = 0; i < byteCount; i++) {
      result = result << 8 | this[i];
    }
    return result;
  }

  /// Convert [bytes] to [int] with little endian. The number is unsigned.
  int toLittleEndian([int? byteCount]) {
    byteCount ??= length;

    var result = 0;
    for (var i = byteCount - 1; i >= 0; i--) {
      result = result << 8 | this[i];
    }
    return result;
  }

  /// Convert [bytes] to [int]. The number is unsigned.
  ///
  /// The [endian] is the endian of the [bytes].
  ///
  /// The [count] is the number of bytes to convert.
  int toUint(int count, Endian endian) {
    if (endian == Endian.big) {
      return toBigEndian(count);
    } else {
      return toLittleEndian(count);
    }
  }
}

/// Not found exception.
class NotFoundException implements Exception {
  /// Create [NotFoundException] with [message].
  NotFoundException(this.message);

  /// The message of the exception.
  final String message;

  @override
  String toString() {
    return message;
  }
}
