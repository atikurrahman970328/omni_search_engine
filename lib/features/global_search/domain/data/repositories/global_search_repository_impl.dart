import '../datasources/global_search_datasource.dart';
import '../models/search_result.dart';
import '../../domain/repositories/global_search_repository.dart';

class GlobalSearchRepositoryImpl implements GlobalSearchRepository {
  final GlobalSearchDatasource datasource;

  GlobalSearchRepositoryImpl({required this.datasource});

  @override
  Future<List<SearchResult>> searchAll(String query) async {
    return await datasource.executeGlobalSearch(query);
  }

  @override
  Future<List<SearchResult>> searchByType(String query, SearchResultType type) async {
    final allResults = await datasource.executeGlobalSearch(query);
    return allResults.where((item) => item.type == type).toList();
  }
}