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
