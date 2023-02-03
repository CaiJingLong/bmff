import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/box_factory.dart';

/// {@template bmff.bmff_context}
///
/// The context of a BMFF file.
///
/// The context contains the boxes.
///
/// User need to implement [getRangeData], and [length].
///
/// {@endtemplate}
abstract class BmffContext {
  /// The boxes of the context.
  final boxes = <BmffBox>[];

  /// The all boxes of the context. All of boxes have been decoded.
  late List<BmffBox> allBox = _allBox(this);

  /// The FTYP box of the context.
  late FtypeBox ftypeBox;

  /// The length of the context.
  int get length;

  /// Get the data of the context.
  List<int> getRangeData(
    int start,
    int end,
  );

  /// Release the context.
  void close();

  /// {@macro bmff.box_factory}
  final _boxFactory = BoxFactory();

  void resgiterBox(BmffBox box) {
    boxes.add(box);
  }

  /// Decode [BmffBox] from [startIndex].
  BmffBox makeBox({required int startIndex, BmffBox? parent}) {
    return _boxFactory.makeBox(this, startIndex, parent: parent);
  }

  static List<BmffBox> _allBox(BmffContext context) {
    final result = <BmffBox>[];
    final bmff = Bmff(context);
    final allBox = bmff.decodeBox();
    for (final box in allBox) {
      result.add(box);
      result.addAll(_decodeBox(box));
    }
    return result;
  }

  static Iterable<BmffBox> _decodeBox(BmffBox box) {
    final result = <BmffBox>[];
    for (final child in box.childBoxes) {
      result.add(child);
      result.addAll(_decodeBox(child));
    }
    return result;
  }

  late Bmff bmff = Bmff(this);
}

/// {@template bmff.BmffMemoryContext}
///
/// The context of a BMFF file in memory.
///
/// {@endtemplate}
class BmffMemoryContext extends BmffContext {
  /// {@macro bmff.BmffMemoryContext}
  BmffMemoryContext(this.bytes);

  /// The bytes of the context.
  final List<int> bytes;

  @override
  int get length => bytes.length;

  @override
  List<int> getRangeData(
    int start,
    int end,
  ) {
    return bytes.sublist(start, end);
  }

  @override
  void close() {}
}
