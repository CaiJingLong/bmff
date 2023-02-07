import 'package:bmff/bmff.dart';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  final urls = [
    'http://zuoye.free.fr/files/compare_still_1.heic.jpg',
    // 'http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4',
    // 'https://www.w3school.com.cn/i/movie.mp4',
    // 'https://cdn.jsdelivr.net/gh/ExampleAssets/ExampleAsset@master/preview_0.heic',
  ];

  for (final url in urls) {
    await showHttpBoxInfo(url);
  }
}

Future<void> showHttpBoxInfo(String url) async {
  print('------------------ $url ------------------');

  final uri = Uri.parse(url);
  final bmff = await Bmff.asyncContext(AsyncBmffContextHttp(uri));
  for (final box in bmff.childBoxes) {
    showBoxInfo(0, box);
  }

  print('\n');
}

void showBoxInfo(int level, AsyncBmffBox box) {
  final levelPrefix = '    ' * level;
  print('$levelPrefix${box.type} ${box.realSize}');

  for (final child in box.childBoxes) {
    showBoxInfo(level + 1, child);
  }
}

// part download http context
class AsyncBmffContextHttp extends AsyncBmffContext {
  final Uri uri;
  final int maxCacheLength;

  AsyncBmffContextHttp(
    this.uri, {
    this.maxCacheLength = 1024 * 1024 * 1,
  });

  List<int>? _bytes;

  @override
  Future<List<int>> getRangeData(int start, int end) async {
    if (_bytes != null) {
      return _bytes!.sublist(start, end);
    }

    final response = await http.get(uri, headers: {
      'Range': 'bytes=$start-${end - 1}',
    });
    if (response.statusCode != 206) {
      throw Exception(
          'Current http status code is ${response.statusCode}, not 206. '
          'The server not support range download');
    }
    final bytes = response.bodyBytes;
    return bytes;
  }

  @override
  Future<int> lengthAsync() async {
    final response = await http.head(uri, headers: {
      'User-Agent': 'curl/7.79.1',
      'Accept': '*/*',
      'Host': uri.host,
    });
    final contentLengthList = response.headers.entries
        .where((element) => element.key.toLowerCase() == 'content-length');
    if (contentLengthList.isNotEmpty) {
      final contentLength = int.parse(contentLengthList.first.value);
      if (contentLength < maxCacheLength) {
        final response = await http.get(uri);
        _bytes = response.bodyBytes;
      }
      return contentLength;
    } else {
      final response = await http.get(uri);
      _bytes = response.bodyBytes;
      return response.bodyBytes.length;
    }
  }
}
