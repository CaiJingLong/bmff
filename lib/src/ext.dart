import 'dart:typed_data';

extension ByteBufferExtension on ByteBuffer {
  int getUint8(int offset) {
    return asUint8List().elementAt(offset);
  }

  int getUint16(int offset, Endian endian) {
    final list = asUint8List(offset * 2);
    return list.toUint(2, endian);
  }

  int getUint32(int offset, Endian endian) {
    final list = asUint8List(offset * 4);
    return list.toUint(4, endian);
  }

  int getUint64(int offset, Endian endian) {
    final list = asUint8List(offset * 8);
    return list.toUint(8, endian);
  }
}

extension _BmffListExtension on List<int> {
  int toBigEndian(int count) {
    var result = 0;
    for (var i = 0; i < count; i++) {
      result = result << 8 | this[i];
    }
    return result;
  }

  int toLittleEndian(int count) {
    var result = 0;
    for (var i = count - 1; i >= 0; i--) {
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
