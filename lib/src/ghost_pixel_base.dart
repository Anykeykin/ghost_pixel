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
    required bool compressFileBytes,
  }) async {
    /// Base image bytes
    final Uint8List imageBytes = await FileUtils.getFileBytes(imagePath);

    /// Base file bytes
    final fileBytes = await FileUtils.getFileBytes(filePath);

    /// Encrypting file bytes with image bytes
    final encryptedFileBytes = await hideBytesInImageBytes(
      imageBytes: imageBytes,
      fileBytes: fileBytes,
      compressFileBytes: compressFileBytes,
    );

    /// Write encrypting file bytes on image path
    await FileUtils.writeFile(outputImagePath, encryptedFileBytes);
  }

  /// Extracting File from Image
  static Future<void> extractFileFromImage({
    required String imagePath,
    required String outputFilePath,
    required int fileSize,
    required bool decompressFileBytes,
  }) async {
    /// Encrypted image bytes
    final Uint8List imageBytes = await FileUtils.getFileBytes(imagePath);

    /// Get decrypted file bytes from image bytes
    final List<int> decryptedfileBytes = await extractBytesFromImageBytes(
      encryptedImageBytes: imageBytes,
      fileSize: fileSize,
      decompressFileBytes: decompressFileBytes,
    );

    /// Write decrypting file bytes on file path
    await FileUtils.writeFile(outputFilePath, decryptedfileBytes);
  }

  /// Hide Bytes in Image
  static Future<List<int>> hideBytesInImageBytes({
    required List<int> imageBytes,
    required List<int> fileBytes,
    required bool compressFileBytes,
  }) async {
    /// Get image class from bytes
    final image = await FileUtils.getImage(Uint8List.fromList(imageBytes));
    if (compressFileBytes) {
      fileBytes = FileUtils.compressBytes(fileBytes);
    }

    /// Сheck file bytes length
    if (fileBytes.length * 5.1 > imageBytes.length) {
      throw Exception('The file is too big to hide in this image.');
    }

    if (image != null) {
      /// Encrypting image pixels
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
    required bool decompressFileBytes,
  }) async {
    /// Get image class from encrypted bytes
    final image =
        await FileUtils.getImage(Uint8List.fromList(encryptedImageBytes));

    if (image != null) {
      /// Decrypting image pixels
      List<int> fileBytes = ImageCrypto.imageDecrypt(image, fileSize);
      return decompressFileBytes
          ? FileUtils.decompressBytes(fileBytes)
          : fileBytes;
    }
    if (image == null) {
      throw Exception('image not decoded');
    }
    return [];
  }
}
