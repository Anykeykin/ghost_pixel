import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

class FileUtils {
  static Future<Image?> getImage(Uint8List imageBytes) async{
    return decodeImage(imageBytes);
  }

  static Future<Uint8List> getFileBytes(String imagePath) async{
    final imageFile = File(imagePath);
    return  await imageFile.readAsBytes();
  }
}
