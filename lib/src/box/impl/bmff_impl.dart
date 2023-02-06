import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/box_factory.dart';

class ContextBmffImpl extends Bmff {
  /// {@macro bmff.bmff_example}
  ContextBmffImpl(this.context);

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

    if (firstBox is FtypBox) {
      context.ftypeBox = firstBox;
    }

    return context.boxes;
  }

  @override
  List<BmffBox> get childBoxes => decodeBox();
}

class AsyncBmffImpl extends Bmff {
  AsyncBmffImpl(this.context);

  final AsyncBmffContext context;

  Future<void> init() async {
    _boxes.clear();
    final factory = BoxFactory();
    // factory.createBmffByAsync(context);
  }

  List<BmffBox> _boxes = [];

  @override
  List<BmffBox> get childBoxes => throw UnimplementedError();
}
