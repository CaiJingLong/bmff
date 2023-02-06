import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/box_factory.dart';

class ContextBmffImpl extends Bmff {
  /// {@macro bmff.bmff_example}
  ContextBmffImpl(this.context);

  /// The context of the BMFF file.
  ///
  /// {@macro bmff.bmff_context}
  final BmffContext context;

  /// The FTYP box of the context.
  late FtypBox ftypeBox;

  final _valueList = <BmffBox>[];

  /// Decode file to [BmffBox]s.
  ///
  /// The method will add the [BmffBox]s to the [BmffContext.boxes].
  ///
  /// The box:
  /// {@macro bmff.bmff_box}
  List<BmffBox> decodeBox() {
    _valueList.clear();

    final length = context.length;

    // decode the data
    var startIndex = 0;

    final factory = BoxFactory();

    while (startIndex < length) {
      final box = factory.makeBox(context, startIndex);
      _valueList.add(box);
      startIndex += box.realSize;
    }

    final firstBox = _valueList.first;

    if (firstBox is FtypBox) {
      ftypeBox = firstBox;
    }

    return _valueList;
  }

  @override
  List<BmffBox> get childBoxes => decodeBox();
}
