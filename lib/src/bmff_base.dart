import 'dart:collection';

import 'package:bmff/bmff.dart';

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
