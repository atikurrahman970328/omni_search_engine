import '../../../../core/services/shizuku_service.dart';
import '../datasources/app_datasource.dart';
import '../models/app_info_model.dart';
import '../../domain/repositories/app_repository.dart';

class AppRepositoryImpl implements AppRepository {
  final AppDatasource datasource;

  AppRepositoryImpl({required this.datasource});

  @override
  Future<List<AppInfoModel>> fetchAllApps() async {
    return await datasource.getInstalledApps();
  }

  @override
  Future<List<AppInfoModel>> searchApps(String query) async {
    final apps = await fetchAllApps();
    final lowerQuery = query.toLowerCase();
    return apps.where((app) {
      return app.appName.toLowerCase().contains(lowerQuery) ||
          app.packageName.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  @override
  Future<bool> disableApp(String packageName) async {
    final result = await ShizukuService.executeCommand('pm disable-user --user 0 $packageName');
    return result.contains('new state: disabled-user') || result.contains('disabled');
  }

  @override
  Future<bool> enableApp(String packageName) async {
    final result = await ShizukuService.executeCommand('pm enable $packageName');
    return result.contains('new state: enabled') || result.contains('enabled');
  }
}