
import 'dart:io';

import 'package:image/image.dart';

class GhostPixel {
  static Future<void> hideFileInImage({
    required String imagePath,
    required String filePath,
    required String outputImagePath,
  }) async {
    final imageFile = File(imagePath);
    final image = decodeImage(await imageFile.readAsBytes())!;

    final file = File(filePath);
    final fileBytes = await file.readAsBytes();

    if (fileBytes.length * 8 > image.width * image.height * 3) {
      throw Exception('Файл слишком большой для скрытия в этом изображении');
    }

    int byteIndex = 0;
    int bitIndex = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final a = getAlpha(pixel);
        final r = getRed(pixel);
        final g = getGreen(pixel);
        final b = getBlue(pixel);

        if (byteIndex < fileBytes.length) {
          final bit = (fileBytes[byteIndex] >> (7 - bitIndex)) & 1;

          final newR = (r & 0xFE) | bit;
          bitIndex++;

          if (bitIndex == 8) {
            bitIndex = 0;
            byteIndex++;
          }

          image.setPixel(x, y, getColor(newR, g, b, a));
        }
      }
    }

    final outputImageFile = File(outputImagePath);
    await outputImageFile.writeAsBytes(encodePng(image));
  }

  static Future<void> extractFileFromImage({
    required String imagePath,
    required String outputFilePath,
    required int fileSize,
  }) async {
    final imageFile = File(imagePath);
    final image = decodeImage(await imageFile.readAsBytes())!;

    final fileBytes = <int>[];
    int byte = 0;
    int bitIndex = 0;

    outerLoop:
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final r = getRed(pixel);

        if (fileBytes.length < fileSize) {
          final bit = r & 1;

          byte = (byte << 1) | bit;
          bitIndex++;

          if (bitIndex == 8) {
            fileBytes.add(byte);
            byte = 0;
            bitIndex = 0;
          }
        } else {
          break outerLoop;
        }
      }
    }

    final outputFile = File(outputFilePath);
    await outputFile.writeAsBytes(fileBytes);
  }
}

