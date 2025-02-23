import 'dart:io';

import 'package:image/image.dart';

class FileUtils {
  static Future<Image?> getImage(String imagePath) async{
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    return decodeImage(imageBytes);
  }
}
