import 'dart:collection';

import 'package:bmff/bmff.dart';
import 'package:bmff/src/factory/box_factory.dart';

/// {@template bmff.async_bmff}
///
/// ```dart
/// import 'package:bmff/bmff.dart';
/// import 'package:http/http.dart' as http;
///
/// Future<void> main(List<String> args) async {
///   // final uri = Uri.parse('https://www.w3school.com.cn/i/movie.mp4');
///   final uri = Uri.parse(
///       'http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4');
///   final bmff = await Bmff.asyncContext(AsyncBmffContextHttp(uri));
///   for (final box in bmff.childBoxes) {
///     showBoxInfo(0, box);
///   }
/// }
///
/// void showBoxInfo(int level, AsyncBmffBox box) {
///   final levelPrefix = '    ' * level;
///   print('$levelPrefix${box.type} ${box.realSize}');
///
///   for (final child in box.childBoxes) {
///     showBoxInfo(level + 1, child);
///   }
/// }
///
/// // part download http context
/// class AsyncBmffContextHttp extends AsyncBmffContext {
///   final Uri uri;
///
///   const AsyncBmffContextHttp(this.uri);
///
///   @override
///   Future<List<int>> getRangeData(int start, int end) async {
///     final response = await http.get(uri, headers: {
///       'Range': 'bytes=$start-${end - 1}',
///     });
///     if (response.statusCode != 206) {
///       throw Exception(
///           'Current http status code is ${response.statusCode}, not 206, not support range download');
///     }
///     final bytes = response.bodyBytes;
///     return bytes;
///   }
///
///   @override
///   Future<int> lengthAsync() async {
///     final response = await http.head(uri);
///     final contentLength = response.headers['content-length'];
///     if (contentLength != null) {
///       return int.parse(contentLength);
///     } else {
///       throw Exception('content-length not found');
///     }
///   }
/// }
/// ```
///
/// {@endtemplate}
class AsyncBmff extends UnmodifiableMapBase<String, AsyncBmffBox> {
  AsyncBmff(this.context);

  /// Context for async bmff.
  final AsyncBmffContext context;

  /// Init child boxes.
  Future<void> init() async {
    _values = await AsyncBoxFactory().decodeAsyncBoxes(this);
  }

  List<AsyncBmffBox> _values = [];

  /// Get child boxes.
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
