import 'dart0io';
import 'package:flutter/foundation.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

class DocumentParser {
  /// সাধারণ টেক্সট ফাইল (TXT, MD, JSON, LOG, CSV) থেকে টেক্সট এক্সট্র্যাক্ট করে
  static Future<String> parsePlainText(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return '';
      
      // ফাইল বেশি বড় হলে পারফর্ম্যান্স রক্ষার জন্য প্রথম ১ মেগাবাইট পর্যন্ত টেক্সট রিড করে
      final length = await file.length();
      if (length > 1024 * 1024) {
        final Stream<List<int>> stream = file.openRead(0, 1024 * 1024);
        final List<int> bytes = await stream.reduce((a, b) => a..addAll(b));
        return String.fromCharCodes(bytes);
      }
      
      return await file.readAsString();
    } catch (e) {
      debugPrint("PlainText Parsing Error ($filePath): $e");
      return '';
    }
  }

  /// PDF ফাইল থেকে টেক্সট এক্সট্র্যাক্ট করে
  static Future<String> parsePdf(String filePath) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) return '';

      final List<int> bytes = await file.readAsBytes();
      final PdfDocument document = PdfDocument(inputBytes: bytes);
      
      final String text = PdfTextExtractor(document).extractText();
      document.dispose();
      
      return text;
    } catch (e) {
      debugPrint("PDF Parsing Error ($filePath): $e");
      return '';
    }
  }

  /// ফাইল টাইপ অনুযায়ী উপযুক্ত পার্সার নির্বাচন করে
  static Future<String> extractText(String filePath, String extension) async {
    final ext = extension.toLowerCase().replaceAll('.', '');
    
    if (ext == 'pdf') {
      return await parsePdf(filePath);
    } else if (['txt', 'md', 'json', 'xml', 'log', 'csv', 'yaml', 'yml', 'dart', 'kt', 'java', 'py', 'js', 'html', 'css'].contains(ext)) {
      return await parsePlainText(filePath);
    }
    
    return '';
  }
}