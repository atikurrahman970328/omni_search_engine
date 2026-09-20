import '../models/file_item.dart';

abstract class IndexingRepository {
  /// স্টোরেজ স্ক্যান শুরু করার মেথড
  Future<void> startIndexing({required Function(int scannedCount) onProgress});

  /// ইনডেক্সিং প্রক্রিয়া বন্ধ বা পজ করার মেথড
  Future<void> stopIndexing();

  /// স্টোরেজের মোট ফাইলের আনুমানিক হিসাব পাওয়ার মেথড
  Future<int> getTotalIndexedFilesCount();

  /// ফুল-টেক্সট সার্চের মাধ্যমে ফাইল খোঁজার মেথড
  Future<List<FileItem>> searchFiles(String query);
}