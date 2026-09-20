import '../../../../core/constants/shell_commands.dart';
import '../../../../core/services/shizuku_service.dart';
import '../models/app_info_model.dart';

class AppDatasource {
  /// শিজুকুর মাধ্যমে ডিভাইসের ইনস্টলড অ্যাপসের পার্সড লিস্ট নিয়ে আসে
  Future<List<AppInfoModel>> getInstalledApps() async {
    final List<AppInfoModel> appList = [];
    final bool hasPermission = await ShizukuService.checkPermission();

    if (!hasPermission) {
      return appList;
    }

    // List all packages via Shizuku ADB Shell
    final String output = await ShizukuService.executeCommand(ShellCommands.listAllPackages);
    final List<String> lines = output.split('\n');

    for (final line in lines) {
      if (line.startsWith('package:')) {
        // Line format: package:/data/app/.../base.apk=com.example.app
        final parts = line.replaceFirst('package:', '').split('=');
        if (parts.length >= 2) {
          final apkPath = parts[0];
          final packageName = parts.sublist(1).join('=').trim();
          final isSystem = apkPath.startsWith('/system') || apkPath.startsWith('/product');

          appList.add(
            AppInfoModel(
              packageName: packageName,
              appName: packageName.split('.').last, // Fallback name
              versionName: '1.0',
              versionCode: 1,
              isSystemApp: isSystem,
              isEnabled: true,
            ),
          );
        }
      }
    }

    return appList;
  }
}