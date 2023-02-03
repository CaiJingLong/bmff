import 'package:bmff/bmff.dart';

///
/// The BMFF library.
///
/// {@template bmff.bmff_example}
///
/// ```dart
/// import 'package:bmff/bmff.dart';
/// import 'package:bmff/bmff_io.dart';
///
/// void main() {
///   final file = File('assets/compare_still_1.heic');
///   final context = BmffIoContext(file); // or BmffMemoryContext(bytes);
///   final bmff = Bmff(context);
///   final box = bmff.decodeBox();
/// }
/// ```
///
/// {@endtemplate}
class Bmff with BoxContainer {
  /// {@macro bmff.bmff_example}
  Bmff(this.context);

  /// The context of the BMFF file.
  ///
  /// {@macro bmff.bmff_context}
  final BmffContext context;

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

    if (firstBox is FtypeBox) {
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
mixin BoxContainer {
  /// The [BmffBox]s.
  List<BmffBox> get childBoxes;

  /// Get the [BmffBox] by [type].
  BmffBox operator [](String type) {
    return childBoxes.firstWhere((element) => element.type == type);
  }
}

/// Convert [bytes] to display text or number.
extension BmffListExtension on List<int> {
  // ignore: unused_element
  String toHexString() {
    return map((i) => i.toRadixString(16).padLeft(2, '0')).join();
  }

  String toAsciiString() {
    return map((i) => String.fromCharCode(i)).join();
  }

  int toBigEndian(int byteCount) {
    var result = 0;
    for (var i = 0; i < byteCount; i++) {
      result = result << 8 | this[i];
    }
    return result;
  }

  int toLittleEndian(int byteCount) {
    var result = 0;
    for (var i = byteCount - 1; i >= 0; i--) {
      result = result << 8 | this[i];
    }
    return result;
  }
}
