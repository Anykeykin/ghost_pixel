import 'dart:io';
import 'dart:typed_data';

import 'package:ghost_pixel/src/file_utils.dart';
import 'package:ghost_pixel/src/image_crypto.dart';
import 'package:image/image.dart';

class GhostPixel {
  /// Hide File in Image
  static Future<void> hideFileInImage({
    required String imagePath,
    required String filePath,
    required String outputImagePath,
  }) async {
    final Uint8List imageBytes = await FileUtils.getFileBytes(imagePath);
    final Image? image = await FileUtils.getImage(imageBytes);

    final fileBytes = await FileUtils.getFileBytes(filePath);

    if (fileBytes.length * 5.1 > imageBytes.length) {
      throw Exception('The file is too big to hide in this image.');
    }
    if (image != null) {
      ImageCrypto.imageEncrypt(image, fileBytes);
      final encryptedFileBytes = encodePng(image);
      final outputImageFile = File(outputImagePath);
      await outputImageFile.writeAsBytes(encryptedFileBytes);
    }
    if (image == null) {
      throw Exception('image not decoded');
    }
  }

  /// Hide Bytes in Image
  static Future<List<int>> hideBytesInImageBytes({
    required List<int> imageBytes,
    required List<int> fileBytes,
  }) async {
    final image = await FileUtils.getImage(Uint8List.fromList(imageBytes));

    if (fileBytes.length * 5.1 > imageBytes.length) {
      throw Exception('The file is too big to hide in this image.');
    }
    if (image != null) {
      ImageCrypto.imageEncrypt(image, Uint8List.fromList(fileBytes));
      return encodePng(image);
    }
    if (image == null) {
      throw Exception('image not decoded');
    }
    return [];
  }

  /// Extracting Bytes from Image
  static Future<List<int>> extractBytesFromImageBytes({
    required List<int> encryptedImageBytes,
    required int fileSize,
  }) async {
    final image =
        await FileUtils.getImage(Uint8List.fromList(encryptedImageBytes));

    if (image != null) {
      return ImageCrypto.imageDecrypt(image, fileSize);
    }
    if (image == null) {
      throw Exception('image not decoded');
    }
    return [];
  }

  /// Extracting File from Image
  static Future<void> extractFileFromImage({
    required String imagePath,
    required String outputFilePath,
    required int fileSize,
  }) async {
    final Uint8List imageBytes = await FileUtils.getFileBytes(imagePath);
    final List<int> decryptedfileBytes = await extractBytesFromImageBytes(
        encryptedImageBytes: imageBytes, fileSize: fileSize);
    if (decryptedfileBytes.isNotEmpty) {
      final outputFile = File(outputFilePath);
      await outputFile.writeAsBytes(decryptedfileBytes);
    }
  }
}
