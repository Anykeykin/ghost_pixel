import 'dart:io';

import 'package:ghost_pixel/ghost_pixel.dart';

void main() async {
  final imagePath = 'yourPath.jpg'; 
  final filePath = 'yourPath2.txt';
  final outputImagePath = 'yourPath3.jpg'; 
  final extractedFilePath = 'yourPath4.txt';

  await GhostPixel.hideFileInImage(
    imagePath: imagePath,
    filePath: filePath,
    outputImagePath: outputImagePath,
  );

  await GhostPixel.extractFileFromImage(
    imagePath: outputImagePath,
    outputFilePath: extractedFilePath,
    fileSize: File(filePath).lengthSync(),
  );
}