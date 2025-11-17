import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as img;

class FileHelper {

  static Future<String> saveFilePermanently(PlatformFile file) async {
    final appStorage = await getApplicationDocumentsDirectory();
    final newFile = File('${appStorage.path}/${file.name}');

    final originalBytes = await File(file.path!).readAsBytes();
    final originalImage = img.decodeImage(originalBytes);

    if (originalImage != null) {
      final resizedImage = img.copyResize(
        originalImage,
        width: 200,
        height: 200,
        interpolation: img.Interpolation.cubic,
      );
      final resizedBytes = img.encodePng(resizedImage);
      await File(newFile.path).writeAsBytes(resizedBytes);
      return newFile.path;
    }

    return await File(file.path!).copy(newFile.path).then((f) => f.path);
  }

  static Future<PlatformFile?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'png'],
    );
    if (result == null) return null;
    return result.files.first;
  }
}
