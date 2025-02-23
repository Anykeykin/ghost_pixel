import 'dart:typed_data';

import 'package:image/image.dart';

class ImageCrypto {
  /// image encrypt method
  static void imageEncrypt(Image image, Uint8List fileBytes) {
    int byteIndex = 0;
    int bitIndex = 0;

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final Pixel pixel = image.getPixel(x, y);

        final int a = pixel.a.toInt();
        final int r = pixel.r.toInt();
        final int g = pixel.g.toInt();
        final int b = pixel.b.toInt();

        if (byteIndex < fileBytes.length) {
          final int bit = (fileBytes[byteIndex] >> (7 - bitIndex)) & 1;

          final int newR = (r & 0xFE) | bit;
          bitIndex++;

          if (bitIndex == 8) {
            bitIndex = 0;
            byteIndex++;
          }

          image.setPixel(x, y, ColorFloat64.rgba(newR, g, b, a));
        } else {
          break;
        }
      }
    }
  }

  /// image decrypt method
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
