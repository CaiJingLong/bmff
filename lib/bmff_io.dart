import 'dart:io';

import 'bmff.dart';

class BmffIoContext extends BmffContext {
  BmffIoContext(this.file);

  final File file;

  late final RandomAccessFile _randomAccessFile = _getRandomAccessFile();

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
