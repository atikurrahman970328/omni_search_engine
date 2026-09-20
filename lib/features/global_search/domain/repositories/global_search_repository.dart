import '../../data/models/search_result.dart';

abstract class GlobalSearchRepository {
  /// ফাইল, অ্যাপস এবং সিস্টেম অ্যাকশন একসাথে সার্চ করার মেথড
  Future<List<SearchResult>> searchAll(String query);

  /// ফিল্টার টাইপ (File, App, System) অনুযায়ী সার্চ রেজাল্ট ফিল্টার করার মেথড
  Future<List<SearchResult>> searchByType(String query, SearchResultType type);
}