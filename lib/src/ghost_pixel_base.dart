import 'dart:io';
import 'dart:typed_data';

import 'package:ghost_pixel/src/image_crypto.dart';
import 'package:image/image.dart';

class GhostPixel {
  /// Hide File in Image
  static Future<void> hideFileInImage({
    required String imagePath,
    required String filePath,
    required String outputImagePath,
  }) async {
    final imageFile = File(imagePath);
    final imageBytes = await imageFile.readAsBytes();
    final image = decodeImage(imageBytes)!;

    final file = File(filePath);
    final fileBytes = await file.readAsBytes();
  
    if (fileBytes.length * 5.1 > imageBytes.length) {
      throw Exception('Файл слишком большой для скрытия в этом изображении');
    }

    ImageCrypto.imageEncrypt(image, fileBytes);

    final outputImageFile = File(outputImagePath);
    await outputImageFile.writeAsBytes(encodePng(image));
  }

  /// Hide Bytes in Image
  static Future<List<int>> hideBytesInImageBytes({
    required List<int> imageBytes,
    required List<int> fileBytes,
  }) async {
    final image = decodeImage(Uint8List.fromList(imageBytes))!;

    if (fileBytes.length * 5.1 > imageBytes.length) {
      throw Exception('Файл слишком большой для скрытия в этом изображении');
    }

    ImageCrypto.imageEncrypt(image, Uint8List.fromList(fileBytes));

    return encodePng(image);
  }

  /// Extracting Bytes from Image
  static Future<List<int>> extractBytesFromImageBytes({
    required List<int> encryptedImageBytes,
    required int fileSize,
  }) async {
    final image = decodeImage(Uint8List.fromList(encryptedImageBytes))!;

    final fileBytes = ImageCrypto.imageDecrypt(image, fileSize);

    return fileBytes;
  }

  /// Extracting File from Image
  static Future<void> extractFileFromImage({
    required String imagePath,
    required String outputFilePath,
    required int fileSize,
  }) async {
    final imageFile = File(imagePath);
    final image = decodeImage(await imageFile.readAsBytes())!;

    final fileBytes = ImageCrypto.imageDecrypt(image, fileSize);

    final outputFile = File(outputFilePath);
    await outputFile.writeAsBytes(fileBytes);
  }
}
