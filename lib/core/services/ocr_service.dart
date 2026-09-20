import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrService {
  static final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  /// ইমেজ ফাইল প্রসেস করে ভেতরের টেক্সট স্ট্রিপ করে বের করে
  static Future<String> extractTextFromImage(String imagePath) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) return '';

      final inputImage = InputImage.fromFilePath(imagePath);
      final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

      final StringBuffer extractedTextBuffer = StringBuffer();
      for (TextBlock block in recognizedText.blocks) {
        extractedTextBuffer.writeln(block.text);
      }

      return extractedTextBuffer.toString();
    } catch (e) {
      debugPrint("OCR Processing Error ($imagePath): $e");
      return '';
    }
  }

  /// রিসোর্স রিলিজ করার জন্য মেমোরি ক্লিনআপ
  static Future<void> dispose() async {
    await _textRecognizer.close();
  }
}