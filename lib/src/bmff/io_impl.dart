import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/full_box_type.dart';

/// {@macro bmff.createBmffFromFile}
Bmff createBmffFromFile(
  String path, {
  List<String> fullBoxTypes = fullBoxType,
}) {
  return BmffIoContext(File(path), fullBoxTypes: fullBoxTypes).bmff;
}

/// {@template bmff.BmffIoContext}
///
/// The context for dart:io.
///
/// The inner [File] is used to read the data.
///
///
/// {@endtemplate}
///
/// {@macro bmff.bmff_example}
class BmffIoContext extends BmffContext {
  /// {@macro bmff.BmffIoContext}
  ///
  /// {@macro bmff.bmff_example}
  BmffIoContext(
    this.file, {
    List<String> fullBoxTypes = fullBoxType,
  }) : super(fullBoxTypes: fullBoxTypes);

  /// The file of the context.
  final File file;

  /// The [_randomAccessFile] is used to read the data of range.
  late final RandomAccessFile _randomAccessFile = _getRandomAccessFile();

  /// See [_randomAccessFile]
  RandomAccessFile _getRandomAccessFile() {
    final randomAccessFile = file.openSync(mode: FileMode.read);
    randomAccessFile.setPositionSync(0);
    return randomAccessFile;
  }

  @override
  List<int> getRangeData(int start, int end) {
    _randomAccessFile.setPositionSync(start);
    final data = _randomAccessFile.readSync(end - start);
    return data;
  }

  @override
  void close() {
    _randomAccessFile.closeSync();
  }

  @override
  int get length => file.lengthSync();
}
