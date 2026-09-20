import '../../../../core/services/database_helper.dart';
import '../../../system_apps/data/datasources/app_datasource.dart';
import '../models/search_result.dart';

class GlobalSearchDatasource {
  final AppDatasource _appDatasource = AppDatasource();

  /// স্টোরেজ ফাইল এবং সিস্টেম অ্যাপসের মধ্যে একসাথে FTS5 গ্লোবাল সার্চ চালায়
  Future<List<SearchResult>> executeGlobalSearch(String query) async {
    if (query.trim().isEmpty) return [];

    final List<SearchResult> results = [];

    // Parallel Execution for Storage Search and System Apps Search
    final futures = await Future.wait([
      DatabaseHelper.instance.searchFiles(query),
      _appDatasource.getInstalledApps(),
    ]);

    final fileResults = futures[0] as List<Map<String, dynamic>>;
    final appResults = futures[1];

    // File Search Results Process
    for (final map in fileResults) {
      results.add(SearchResult.fromFileMap(map));
    }

    // App Search Results Process & Filter
    final lowerQuery = query.toLowerCase();
    for (final app in appResults) {
      if (app.appName.toLowerCase().contains(lowerQuery) ||
          app.packageName.toLowerCase().contains(lowerQuery)) {
        results.add(SearchResult.fromAppMap(app.toMap()));
      }
    }

    return results;
  }
}