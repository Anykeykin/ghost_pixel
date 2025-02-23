import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

class FileUtils {
  static Future<Image?> getImage(String imagePath) async{
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    return decodeImage(imageBytes);
  }

  static Future<Uint8List> getFileBytes(String imagePath) async{
    final imageFile = File(imagePath);
    return  await imageFile.readAsBytes();
  }
}
