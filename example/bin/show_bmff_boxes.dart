import 'dart:io';

import 'package:bmff/bmff.dart';
import 'package:bmff/bmff_io.dart';
import 'package:http/http.dart';

Future<void> main(List<String> args) async {
  // final file = File('assets/compare_still_1.heic');
  // _showFileBoxInfo(file);

  // print('-' * 60);

  final mp4File = await getNetworkMp4Url();
  _showFileBoxInfo(mp4File);
}

// ignore: unused_element
void _showDecodeBox(File mp4file) {
  final context = BmffIoContext(mp4file);
  final allBox = context.allBox;
  for (final box in allBox) {
    print(box);
  }
}

Future<File> getNetworkMp4Url() async {
  final path = 'video123/mp4/720/big_buck_bunny_720p_1mb.mp4';
  final file = File('${Directory.systemTemp.path}/$path');
  if (file.existsSync()) {
    return file;
  } else if (!file.parent.existsSync()) {
    file.parent.createSync(recursive: true);
  }
  final url = 'https://www.sample-videos.com/$path';
  final response = await get(Uri.parse(url));
  await file.writeAsBytes(response.bodyBytes);
  print('Downloaded file: ${file.path} successfully.');
  print('The file size is ${file.lengthSync()} bytes.');
  return file;
}

void _showFileBoxInfo(File file) {
  print('Show file: ${file.absolute.path} bmff box info.');
  final context = BmffIoContext(file);

  final bmff = Bmff(context);

  final boxes = bmff.decodeBox();

  for (final box in boxes) {
    showBox(box, 0);
  }
}

void showBox(BmffBox box, int level) {
  if (level != 0) {
    final space = '｜    ' * (level - 1);
    print('$space|---- ${box.type} (${box.size})');
  } else {
    print('${box.type} (${box.size})');
  }
  for (final child in box.childBoxes) {
    showBox(child, level + 1);
  }
}
