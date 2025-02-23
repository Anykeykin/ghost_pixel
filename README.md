# GhostPixel 🕵️‍♂️
GhostPixel is a powerful and easy-to-use library for hiding files inside images using steganography. With GhostPixel, you can seamlessly embed data into image pixels while preserving visual quality and ensuring complete confidentiality.

## ✨ Features
- Data Hiding in Pixels: Embed files and messages directly into images using the least significant bits (LSBs) of pixels.
- Complete Confidentiality: Data remains invisible to the human eye and third-party tools.
- Support for Any File Type: Hide text files, documents, images, audio, and video.
- Ease of Use: Minimal code required for hiding and extracting data.
- High Performance: Fast processing even for large files and high-resolution images.
- Cross-Platform: Works on all platforms supported by Dart (Windows, macOS, Linux, iOS, Android).

## 🚀 Quick Start

### Installation
Add GhostPixel to your pubspec.yaml:

```yaml
dependencies:
  ghost_pixel: ^1.0.5
```

Then run:

```bash
flutter pub get
```

### Usage
Hiding a File in an Image

```dart
import 'package:ghost_pixel/ghost_pixel.dart';

void main() async {
  await GhostPixel.hideFileInImage(
    imagePath: 'input_image.png',
    filePath: 'secret_file.txt',
    outputImagePath: 'output_image.png',
  );
  print('File successfully hidden in the image!');
}
```

Extracting a File from an Image

```dart
import 'package:ghost_pixel/ghost_pixel.dart';

void main() async {
  await GhostPixel.extractFileFromImage(
    imagePath: 'output_image.png',
    outputFilePath: 'extracted_file.txt',
    fileSize: 1024, // File size in bytes
  );
  print('File successfully extracted from the image!');
}
```

## 🎯 Benefits
- Invisibility: Changes to the image are invisible to the human eye.
- Security: Data is protected from accidental detection.
- Flexibility: Supports any file type and image formats (PNG, JPEG, BMP).
- Simplicity: Minimal code required for integration into your application.

## 📦 Supported Formats
- Images: PNG, JPEG, BMP.
- Files: Text files, documents, images, audio, video, and other binary data.

