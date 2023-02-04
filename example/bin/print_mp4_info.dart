import 'dart:convert';
import 'dart:typed_data';

import 'package:bmff/bmff.dart';
import 'package:example/utils.dart';

Future<void> main(List<String> args) async {
  final mp4File = await getNetworkMp4Url();
  final bmff = Bmff.file(mp4File.path);

  print('show box: ${mp4File.absolute.path}');

  printDate(bmff);
  showVideoSize(bmff);
}

void printDate(Bmff bmff) {
  final data = bmff['moov']['udta'];
  final dtStr = ascii.decode(data.getByteBuffer().asUint8List().sublist(8));
  print('date: $dtStr');
}

void showVideoSize(Bmff bmff) {
  final tkhd = bmff['moov']['trak']['tkhd'];
  final width = tkhd.getRangeDataByLength(76, 2).toUint(2, Endian.big);
  final height = tkhd.getRangeDataByLength(80, 2).toUint(2, Endian.big);
  print('video size: $width x $height');
}
