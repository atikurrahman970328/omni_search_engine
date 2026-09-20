import '../../data/models/app_info_model.dart';

abstract class AppRepository {
  /// ডিভাইসের সমস্ত ইনস্টলড (সিস্টেম এবং ইউজার) অ্যাপসের তালিকা নিয়ে আসার মেথড
  Future<List<AppInfoModel>> fetchAllApps();

  /// নির্দিষ্ট কি-ওয়ার্ড দিয়ে অ্যাপ সার্চ করার মেথড
  Future<List<AppInfoModel>> searchApps(String query);

  /// শিজুকুর মাধ্যমে কোনো নির্দিষ্ট অ্যাপকে ব্যাকগ্রাউন্ডে ডিজেবল বা ফ্রিজ করার মেথড
  Future<bool> disableApp(String packageName);

  /// শিজুকুর মাধ্যমে ডিজেবল করা অ্যাপ পুনরায় এনাবল বা আনফ্রিজ করার মেথড
  Future<bool> enableApp(String packageName);
}