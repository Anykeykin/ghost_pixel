import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';

class GhostPixel {
  /// Hide File in Image
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

        final a = pixel.a.toInt();
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        if (byteIndex < fileBytes.length) {
          final bit = (fileBytes[byteIndex] >> (7 - bitIndex)) & 1;

          final newR = (r & 0xFE) | bit;
          bitIndex++;

          if (bitIndex == 8) {
            bitIndex = 0;
            byteIndex++;
          }

          image.setPixel(x, y, ColorFloat64.rgba(newR, g, b, a));
        }
      }
    }

    final outputImageFile = File(outputImagePath);
    await outputImageFile.writeAsBytes(encodePng(image));
  }

  /// Hide Bytes in Image
  static Future<List<int>> hideBytesInImageBytes({
    required List<int> imageBytes,
    required List<int> fileBytes,
  }) async {
    final image = decodeImage(Uint8List.fromList(imageBytes))!;

    if (fileBytes.length * 8 > image.width * image.height * 3) {
      throw Exception('Файл слишком большой для скрытия в этом изображении');
    }

    int byteIndex = 0;
    int bitIndex = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final pixel = image.getPixel(x, y);

        final a = pixel.a.toInt();
        final r = pixel.r.toInt();
        final g = pixel.g.toInt();
        final b = pixel.b.toInt();

        if (byteIndex < fileBytes.length) {
          final bit = (fileBytes[byteIndex] >> (7 - bitIndex)) & 1;

          final newR = (r & 0xFE) | bit;
          bitIndex++;

          if (bitIndex == 8) {
            bitIndex = 0;
            byteIndex++;
          }

          image.setPixel(x, y, ColorFloat64.rgba(newR, g, b, a));
        }
      }
    }

    return encodePng(image);
  }

  /// Extracting File from Image
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

        final r = pixel.r.toInt();

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
