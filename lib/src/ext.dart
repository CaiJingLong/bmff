import 'dart:typed_data';

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

/// Convert [bytes] to display text or number.
extension BmffListExtension on List<int> {
  // ignore: unused_element
  /// Convert [bytes] to [String]. and display as hex.
  String toHexString() {
    return map((i) => i.toRadixString(16).padLeft(2, '0')).join();
  }

  /// Convert [bytes] to [String]. and display as ascii.
  String toAsciiString() {
    return map((i) => String.fromCharCode(i)).join();
  }

  /// Convert [bytes] to [int] with big endian. The number is unsigned.
  int toBigEndian([int? byteCount]) {
    byteCount ??= length;

    var result = 0;
    for (var i = 0; i < byteCount; i++) {
      result = result << 8 | this[i];
    }
    return result;
  }

  /// Convert [bytes] to [int] with little endian. The number is unsigned.
  int toLittleEndian([int? byteCount]) {
    byteCount ??= length;

    var result = 0;
    for (var i = byteCount - 1; i >= 0; i--) {
      result = result << 8 | this[i];
    }
    return result;
  }

  /// Convert [bytes] to [int]. The number is unsigned.
  ///
  /// The [endian] is the endian of the [bytes].
  ///
  /// The [count] is the number of bytes to convert.
  int toUint(int count, Endian endian) {
    if (endian == Endian.big) {
      return toBigEndian(count);
    } else {
      return toLittleEndian(count);
    }
  }
}
