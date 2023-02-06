import 'dart:collection';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/box_factory.dart';
import 'package:bmff/src/box_base.dart';

class AsyncBmff extends UnmodifiableMapBase<String, AsyncBmffBox> {
  AsyncBmff(this.context);

  final AsyncBmffContext context;

  Future<void> init() async {
    _values = await AsyncBoxFactory().decodeAsyncBoxes(this);
  }

  List<AsyncBmffBox> _values = [];

  List<AsyncBmffBox> get childBoxes => _values;

  @override
  AsyncBmffBox operator [](Object? key) {
    if (key is String) {
      return childBoxes.firstWhere(
        (element) => element.type == key,
        orElse: () => throw NotFoundException(
          'Not found AsyncBmffBox with $key.',
        ),
      );
    }
    throw NotFoundException('Not found AsyncBmffBox with $key.');
  }

  @override
  Iterable<String> get keys => childBoxes.map((e) => e.type);
}
