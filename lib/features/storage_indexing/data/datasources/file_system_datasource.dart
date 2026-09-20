import 'dart:io';
import 'package:flutter/foundation.dart';

class FileSystemDatasource {
  /// নির্দিষ্ট ডিরেক্টরির ভেতর হিডেন ও সাধারণ ফাইলসহ সব ফাইল রিকার্সিভলি স্ক্যান করে
  Stream<FileSystemEntity> scanDirectory(String rootPath) async* {
    final Directory directory = Directory(rootPath);

    if (await directory.exists()) {
      try {
        final Stream<FileSystemEntity> entityStream = directory.list(
          recursive: true,
          followLinks: false,
        );

        await for (final entity in entityStream) {
          yield entity;
        }
      } catch (e) {
        debugPrint("Error scanning directory ($rootPath): $e");
      }
    }
  }

  /// ফাইল সিস্টেম পারমিশন অনুযায়ী রুট স্টোরেজ পাথ রিটার্ন করে
  Future<List<String>> getStorageRoots() async {
    final List<String> roots = ['/sdcard', '/storage/emulated/0'];
    
    // সিস্টেম ক্যাশ ও অতিরিক্ত ব্যাকআপ পাথ
    const secondaryPath = '/storage/emulated/0/Android/data';
    if (await Directory(secondaryPath).exists()) {
      roots.add(secondaryPath);
    }

    return roots.toSet().toList();
  }
}