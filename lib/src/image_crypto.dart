import 'dart:typed_data';

import 'package:image/image.dart';

class ImageCrypto {
  static void imageEncrypt(Image image, Uint8List fileBytes) {
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
  }

  static List<int> imageDecrypt(Image image, int fileSize) {
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

    return fileBytes;
  }
}
