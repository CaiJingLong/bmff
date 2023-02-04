import 'dart:collection';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';

import 'stub.dart'
    if (dart.library.io) 'io_impl.dart'
    if (dart.library.html) 'web_impl.dart';

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
class Bmff extends BoxContainer {
  /// {@macro bmff.bmff_example}
  Bmff(this.context);

  factory Bmff.file(String path) {
    return createBmffFromFile(path);
  }

  factory Bmff.memory(List<int> bytes) {
    return Bmff(BmffMemoryContext(bytes));
  }

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
    throw NotFoundException('not found $key');
  }

  @override
  Iterable<String> get keys => childBoxes.map((e) => e.type);
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

  int toBigEndian([int? byteCount]) {
    byteCount ??= length;

    var result = 0;
    for (var i = 0; i < byteCount; i++) {
      result = result << 8 | this[i];
    }
    return result;
  }

  int toLittleEndian([int? byteCount]) {
    byteCount ??= length;

    var result = 0;
    for (var i = byteCount - 1; i >= 0; i--) {
      result = result << 8 | this[i];
    }
    return result;
  }

  int toUint(int count, Endian endian) {
    if (endian == Endian.big) {
      return toBigEndian(count);
    } else {
      return toLittleEndian(count);
    }
  }
}

class NotFoundException implements Exception {
  NotFoundException(this.message);

  final String message;

  @override
  String toString() {
    return message;
  }
}
