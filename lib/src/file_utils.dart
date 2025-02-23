import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

class FileUtils {
  static Future<Image?> getImage(Uint8List imageBytes) async {
    return decodeImage(imageBytes);
  }

  static Future<Uint8List> getFileBytes(String imagePath) async {
    final imageFile = File(imagePath);
    return await imageFile.readAsBytes();
  }

  static Future<void> writeFile(String filePath, List<int> fileBytes) async {
    if (fileBytes.isNotEmpty) {
      final outputFile = File(filePath);
      await outputFile.writeAsBytes(fileBytes);
    }
  }
}
