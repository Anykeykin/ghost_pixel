import 'dart:io';

import 'package:ghost_pixel/ghost_pixel.dart';
import 'package:image/image.dart';

void main() async {
  final imagePath = 'yourPath.jpg';
  final filePath = 'yourPath2.txt';
  final outputImagePath = 'yourPath3.jpg';
  final extractedFilePath = 'yourPath4.txt';

  await GhostPixel.hideFileInImage(
    imagePath: imagePath,
    filePath: filePath,
    outputImagePath: outputImagePath,
    imageFormat: ImageFormat.png,
    compressFileBytes: true,
  );

  await GhostPixel.extractFileFromImage(
    imagePath: outputImagePath,
    outputFilePath: extractedFilePath,
    fileSize: File(filePath).lengthSync(),
    decompressFileBytes: true,
  );

  final encryptedImageBytes = await GhostPixel.hideBytesInImageBytes(
    imageBytes: await File(imagePath).readAsBytes(),
    fileBytes: await File(filePath).readAsBytes(),
    imageFormat: ImageFormat.png,
    compressFileBytes: true,
  );
  File(outputImagePath).writeAsBytes(encryptedImageBytes);

  final decryptedFileBytes = await GhostPixel.extractBytesFromImageBytes(
    encryptedImageBytes: encryptedImageBytes,
    fileSize: File(filePath).readAsBytesSync().length,
    decompressFileBytes: true,
  );
  File(extractedFilePath).writeAsBytes(decryptedFileBytes);
}
