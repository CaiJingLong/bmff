import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:example/utils.dart';

Future<void> main(List<String> args) async {
  final file = File('assets/compare_still_1.heic');
  _showFileBoxInfo(file);

  print('-' * 60);

  final mp4File = await getNetworkMp4Url();
  // final mp4File = await getLocalMp4();
  _showFileBoxInfo(mp4File);
}

Future<File> getLocalMp4() async {
  final file = File(
      '/Users/jinglongcai/Documents/下载-视频/田馥甄 Hebe Tien《懸日 Let It…》Official Music Video.mp4');
  if (file.existsSync()) {
    return file;
  } else {
    throw Exception('File not found: ${file.path}');
  }
}

void _showFileBoxInfo(File file) {
  print('show file: ${file.absolute.path} box info: ');

  final bmff = Bmff.file(file.absolute.path);

  final boxes = bmff.decodeBox();

  for (final box in boxes) {
    showBox(box, 0);
  }
}

void showBox(BmffBox box, int level) {
  final isFullBox = box.isFullBox;
  final fullBoxSuffix = isFullBox ? '(fullbox)' : '';

  if (level != 0) {
    final space = '｜    ' * (level - 1);
    print('$space|---- ${box.type} (${box.size}) $fullBoxSuffix');
  } else {
    print('${box.type} (${box.size}) $fullBoxSuffix');
  }
  for (final child in box.childBoxes) {
    showBox(child, level + 1);
  }
}
