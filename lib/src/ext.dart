import 'dart:typed_data';

import 'package:bmff/bmff.dart';

/// Extension for [ByteBuffer].
extension ByteBufferExtension on ByteBuffer {
  /// Get the unsigned [int] value from the [offset] for 8bit(1bytes).
  int getUint8(int offset) {
    return asUint8List().elementAt(offset);
  }

  /// Get the unsigned [int] value from the [offset] for 16bit(2bytes).
  int getUint16(int offset, Endian endian) {
    final list = asUint8List(offset * 2);
    return list.toUint(2, endian);
  }

  /// Get the unsigned [int] value from the [offset] for 32bit(4bytes).
  int getUint32(int offset, Endian endian) {
    final list = asUint8List(offset * 4);
    return list.toUint(4, endian);
  }

  /// Get the unsigned [int] value from the [offset] for 64bit(8bytes).
  int getUint64(int offset, Endian endian) {
    final list = asUint8List(offset * 8);
    return list.toUint(8, endian);
  }
}
