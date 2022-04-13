import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:bmff/bmff_io.dart';
import 'package:http/http.dart';

Future<void> main(List<String> args) async {
  final file = File('assets/compare_still_1.heic');
  _showFileBoxInfo(file);

  final mp4File = await getNetworkMp4Url();
  _showFileBoxInfo(mp4File);
}

Future<File> getNetworkMp4Url() async {
  final url =
      'https://www.sample-videos.com/video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
  final file = File('${Directory.systemTemp.path}/bmff_example.mp4');
  final response = await get(Uri.parse(url));
  await file.writeAsBytes(response.bodyBytes);
  print('Downloaded file: ${file.path} successfully.');
  print('The file size is ${file.lengthSync()} bytes.');
  return file;
}

void _showFileBoxInfo(File file) {
  final context = BmffIoContext(file);

  final bmff = Bmff(context);

  final boxes = bmff.decodeBox();

  for (final box in boxes) {
    showBox(box, 0);
  }
}

void showBox(BmffBox box, int level) {
  if (level != 0) {
    final indent = '-' * level * 2;
    print('|$indent ${box.type}');
  } else {
    print(box.type);
  }
  for (final child in box.childBoxes) {
    showBox(child, level + 1);
  }
}
