import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:http/http.dart';

Future<File> getNetworkMp4Url() async {
  final path = 'preview/preview1.mp4';
  final tmpPath = 'build';
  final file = File('$tmpPath/$path');
  if (file.existsSync()) {
    return file;
  } else if (!file.parent.existsSync()) {
    file.parent.createSync(recursive: true);
  }

  final url =
      'https://cdn.jsdelivr.net/gh/ExampleAssets/ExampleAsset@master/preview1_mp4.tar';
  try {
    final response = await get(Uri.parse(url));
    final tmpFile = File('$tmpPath/preview1_mp4.tar');
    tmpFile.writeAsBytesSync(response.bodyBytes);
    await extractFileToDisk(tmpFile.path, file.parent.absolute.path);
    print('Downloaded file: ${file.path} successfully.');
    print('The file size is ${file.lengthSync()} bytes.');
    return file;
  } on Exception catch (e) {
    print('Failed to download file: $e, url: $url');
    rethrow;
  }
}
