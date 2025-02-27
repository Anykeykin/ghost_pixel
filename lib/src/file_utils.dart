import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

class FileUtils {
  /// get image from bytes method
  static Future<Image?> getImage(Uint8List imageBytes) async {
    return decodeImage(imageBytes);
  }

  /// get file bytes from file path
  static Future<Uint8List> getFileBytes(String imagePath) async {
    final imageFile = File(imagePath);
    return await imageFile.readAsBytes();
  }

  /// write file bytes on file path
  static Future<void> writeFile(String filePath, List<int> fileBytes) async {
    if (fileBytes.isNotEmpty) {
      final outputFile = File(filePath);
      await outputFile.writeAsBytes(fileBytes);
    }
  }

  static List<int> compressBytes(List<int> fileBytes){
    return gzip.encode(fileBytes);
  }

   static List<int> decompressBytes(List<int> fileBytes){
    return gzip.decode(fileBytes);
  }
}
