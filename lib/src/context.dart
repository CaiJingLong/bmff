import 'package:bmff/bmff.dart';

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
  final boxes = <BmffBox>[];

  int get length;

  List<int> getRangeData(
    int start,
    int end,
  );

  void close();
}
