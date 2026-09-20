import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/global_search_datasource.dart';
import '../../data/models/search_result.dart';
import '../../data/repositories/global_search_repository_impl.dart';
import '../../domain/repositories/global_search_repository.dart';

// Global Search Datasource & Repository Providers
final globalSearchDatasourceProvider = Provider<GlobalSearchDatasource>((ref) {
  return GlobalSearchDatasource();
});

final globalSearchRepositoryProvider = Provider<GlobalSearchRepository>((ref) {
  final datasource = ref.watch(globalSearchDatasourceProvider);
  return GlobalSearchRepositoryImpl(datasource: datasource);
});

// State Model for Global Search
class GlobalSearchState {
  final bool isSearching;
  final String query;
  final List<SearchResult> results;
  final SearchResultType? selectedFilter;

  GlobalSearchState({
    required this.isSearching,
    required this.query,
    required this.results,
    this.selectedFilter,
  });

  GlobalSearchState copyWith({
    bool? isSearching,
    String? query,
    List<SearchResult>? results,
    SearchResultType? selectedFilter,
  }) {
    return GlobalSearchState(
      isSearching: isSearching ?? this.isSearching,
      query: query ?? this.query,
      results: results ?? this.results,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

// State Notifier for Managing Search Execution
class GlobalSearchNotifier extends StateNotifier<GlobalSearchState> {
  final GlobalSearchRepository _repository;

  GlobalSearchNotifier(this._repository)
      : super(GlobalSearchState(
          isSearching: false,
          query: '',
          results: [],
        ));

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      state = state.copyWith(isSearching: false, query: '', results: []);
      return;
    }

    state = state.copyWith(isSearching: true, query: query);

    List<SearchResult> searchResults;
    if (state.selectedFilter != null) {
      searchResults = await _repository.searchByType(query, state.selectedFilter!);
    } else {
      searchResults = await _repository.searchAll(query);
    }

    state = state.copyWith(isSearching: false, results: searchResults);
  }

  void setFilter(SearchResultType? filter) {
    state = GlobalSearchState(
      isSearching: state.isSearching,
      query: state.query,
      results: state.results,
      selectedFilter: filter,
    );
    if (state.query.isNotEmpty) {
      performSearch(state.query);
    }
  }

  void clearSearch() {
    state = GlobalSearchState(
      isSearching: false,
      query: '',
      results: [],
      selectedFilter: state.selectedFilter,
    );
  }
}

final globalSearchNotifierProvider =
    StateNotifierProvider<GlobalSearchNotifier, GlobalSearchState>((ref) {
  final repository = ref.watch(globalSearchRepositoryProvider);
  return GlobalSearchNotifier(repository);
});