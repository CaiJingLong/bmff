import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:example/utils.dart';

Future<void> main(List<String> args) async {
  String path;
  if (args.isEmpty) {
    path = 'assets/compare_still_1.heic';
  } else {
    path = args[0];
  }

  final file = File(path);
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

  final boxes = bmff.childBoxes;

  for (final box in boxes) {
    showBox(box, 0);
  }
}

void showBox(BmffBox box, int level) {
  final largeBoxSuffix = box.isLargeBox ? ' (large box)' : '';
  final fullBoxSuffix = box.isFullBox ? ' (full box)' : '';

  final boxSuffix = largeBoxSuffix + fullBoxSuffix;

  if (level != 0) {
    final space = '｜    ' * (level - 1);
    print('$space|---- ${box.type} (${box.realSize}) $boxSuffix');
  } else {
    print('${box.type} (${box.realSize}) $boxSuffix');
  }
  for (final child in box.childBoxes) {
    showBox(child, level + 1);
  }
}
