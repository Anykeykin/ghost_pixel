import 'dart:io';

import 'package:ghost_pixel/ghost_pixel.dart';
import 'package:ghost_pixel/src/file_utils.dart';

void main() async {
  final imagePath = 'yourPath.jpg';
  final filePath = 'yourPath2.txt';
  final outputImagePath = 'yourPath3.jpg';
  final extractedFilePath = 'yourPath4.txt';

  await GhostPixel.hideFileInImage(
    imagePath: imagePath,
    filePath: filePath,
    outputImagePath: outputImagePath,
    compressFileBytes: false,
  );

  await GhostPixel.extractFileFromImage(
    imagePath: outputImagePath,
    outputFilePath: extractedFilePath,
    fileSize: File(filePath).lengthSync(),
    decompressFileBytes: false,
  );

  final encryptedImageBytes = await GhostPixel.hideBytesInImageBytes(
    imageBytes: await FileUtils.getFileBytes(imagePath),
    fileBytes: await FileUtils.getFileBytes(filePath),
    compressFileBytes: true,
  );
  File(outputImagePath).writeAsBytes(encryptedImageBytes);

  final decryptedFileBytes = await GhostPixel.extractBytesFromImageBytes(
    encryptedImageBytes: encryptedImageBytes,
    fileSize: File(filePath).lengthSync(),
    decompressFileBytes: true,
  );
  File(extractedFilePath).writeAsBytes(decryptedFileBytes);
}
