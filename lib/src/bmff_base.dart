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
class Bmff {
  /// {@macro bmff.bmff_example}
  const Bmff(this.context);

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
      final box = context.makeBox(startIndex);
      context.boxes.add(box);
      startIndex += box.size;
    }

    final firstBox = context.boxes.first;

    if (firstBox is FtypeBox) {
      context.ftypeBox = firstBox;
    }

    return context.boxes;
  }
}

/// Convert [bytes] to display text or number.
extension BmffListExtension on List<int> {
  int toBigEndian() {
    return this[0] << 24 | this[1] << 16 | this[2] << 8 | this[3];
  }

  // ignore: unused_element
  int toLittleEndian() {
    return this[3] << 24 | this[2] << 16 | this[1] << 8 | this[0];
  }

  // ignore: unused_element
  String toHexString() {
    return map((i) => i.toRadixString(16).padLeft(2, '0')).join();
  }

  String toAsciiString() {
    return map((i) => String.fromCharCode(i)).join();
  }
}
