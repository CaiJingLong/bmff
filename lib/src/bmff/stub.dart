import 'package:bmff/bmff.dart';
import 'package:bmff/src/box/full_box_type.dart';

///
/// {@template bmff.createBmffFromFile}
///
/// Create [Bmff] from file path. The method is not available on web.
///
/// For code compatibility, the web can call this method, but an error will be reported.
///
/// {@endtemplate}
Bmff createBmffFromFile(String path,
    {List<String> fullBoxTypes = fullBoxType}) {
  throw UnimplementedError();
}
