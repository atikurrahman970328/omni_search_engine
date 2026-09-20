class AppInfoModel {
  final String packageName;
  final String appName;
  final String versionName;
  final int versionCode;
  final bool isSystemApp;
  final bool isEnabled;

  AppInfoModel({
    required this.packageName,
    required this.appName,
    required this.versionName,
    required this.versionCode,
    required this.isSystemApp,
    required this.isEnabled,
  });

  /// Map অবজেক্ট থেকে AppInfoModel ক্রিয়েট করে
  factory AppInfoModel.fromMap(Map<String, dynamic> map) {
    return AppInfoModel(
      packageName: map['packageName'] as String,
      appName: map['appName'] as String,
      versionName: map['versionName'] ?? '1.0.0',
      versionCode: map['versionCode'] ?? 1,
      isSystemApp: map['isSystemApp'] ?? false,
      isEnabled: map['isEnabled'] ?? true,
    );
  }

  /// AppInfoModel কে Map এ রূপান্তর করে
  Map<String, dynamic> toMap() {
    return {
      'packageName': packageName,
      'appName': appName,
      'versionName': versionName,
      'versionCode': versionCode,
      'isSystemApp': isSystemApp,
      'isEnabled': isEnabled,
    };
  }
}