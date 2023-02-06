# bmff of dart

The package provides a library for reading ISO Base Media File Format (BMFF) files.

## Usage

```yaml
dependencies:
  bmff: any
```

```dart
import 'package:bmff/bmff.dart';
```

## Example

### Simple example

<details>

<summary>Click to show codes</summary>

```dart
import 'package:bmff/bmff.dart';

void main() {
  final assetPath = 'assets/compare_still_1.heic';
  final bmff =
      Bmff.file(assetPath); // The path is file path, not flutter asset path.

  final boxes = bmff.childBoxes;
  for (final box in boxes) {
    print(box);
  }

  showFtyp(bmff);
}

void useByteListSource(List<int> bytes) {
  final bmff = Bmff.memory(bytes);
  final boxes = bmff.childBoxes;
  for (final box in boxes) {
    print(box);
  }
}

void showFtyp(Bmff bmff) {
  final typeBox = bmff.typeBox;
  final type = typeBox.type;

  final majorBrand = typeBox.majorBrand;
  final minorVersion = typeBox.minorVersion;
  final compatibleBrands = typeBox.compatibleBrands;

  print('type: $type');
  print('majorBrand: $majorBrand');
  print('minorVersion: $minorVersion');
  print('compatibleBrands: $compatibleBrands');
}

```

```log
ftyp (len = 24, start = 0, end = 24)
meta (len = 315, start = 24, end = 339)
mdat (len = 37933, start = 339, end = 38272)
type: ftyp
majorBrand: mif1
minorVersion:
compatibleBrands: [mif1, heic]
```

</details>

### Async context example

<details>

<summary>Click to show codes</summary>

```dart
import 'package:bmff/bmff.dart';
import 'package:http/http.dart' as http;

Future<void> main(List<String> args) async {
  // final uri = Uri.parse('https://www.w3school.com.cn/i/movie.mp4');
  final uri = Uri.parse(
      'http://vfx.mtime.cn/Video/2019/03/18/mp4/190318231014076505.mp4');
  final bmff = await Bmff.asyncContext(AsyncBmffContextHttp(uri));
  for (final box in bmff.childBoxes) {
    showBoxInfo(0, box);
  }
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

  const AsyncBmffContextHttp(this.uri);

  @override
  Future<List<int>> getRangeData(int start, int end) async {
    final response = await http.get(uri, headers: {
      'Range': 'bytes=$start-${end - 1}',
    });
    if (response.statusCode != 206) {
      throw Exception(
          'Current http status code is ${response.statusCode},' +
          ' not 206, not support range download');
    }
    final bytes = response.bodyBytes;
    return bytes;
  }

  @override
  Future<int> lengthAsync() async {
    final response = await http.head(uri);
    final contentLength = response.headers['content-length'];
    if (contentLength != null) {
      return int.parse(contentLength);
    } else {
      throw Exception('content-length not found');
    }
  }
}

```

```log
ftyp 32
moov 44331
    mvhd 108
    trak 20456
    trak 23640
    udta 119
free 8
mdat 7538059
```

</details>

### All examples

See [example](https://github.com/CaiJingLong/bmff/blob/main/example).

## Other resources

[ISO Base Media File Format (BMFF)][isobmff]
[The project wiki][wiki]

## LICENSE

[BSD 3-Clause License](https://github.com/CaiJingLong/bmff/blob/main/LICENSE)

[isobmff]: https://mpeg.chiariglione.org/standards/mpeg-4/iso-base-media-file-format
[wiki]: https://github.com/CaiJingLong/bmff/wiki
