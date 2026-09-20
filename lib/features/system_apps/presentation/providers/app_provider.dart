import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/app_datasource.dart';
import '../../data/models/app_info_model.dart';
import '../../data/repositories/app_repository_impl.dart';
import '../../domain/repositories/app_repository.dart';

// App Datasource & Repository Providers
final appDatasourceProvider = Provider<AppDatasource>((ref) {
  return AppDatasource();
});

final appRepositoryProvider = Provider<AppRepository>((ref) {
  final datasource = ref.watch(appDatasourceProvider);
  return AppRepositoryImpl(datasource: datasource);
});

// App List State Model
class AppState {
  final bool isLoading;
  final List<AppInfoModel> allApps;
  final List<AppInfoModel> filteredApps;
  final String searchQuery;

  AppState({
    required this.isLoading,
    required this.allApps,
    required this.filteredApps,
    required this.searchQuery,
  });

  AppState copyWith({
    bool? isLoading,
    List<AppInfoModel>? allApps,
    List<AppInfoModel>? filteredApps,
    String? searchQuery,
  }) {
    return AppState(
      isLoading: isLoading ?? this.isLoading,
      allApps: allApps ?? this.allApps,
      filteredApps: filteredApps ?? this.filteredApps,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

// App State Notifier
class AppNotifier extends StateNotifier<AppState> {
  final AppRepository _repository;

  AppNotifier(this._repository)
      : super(AppState(isLoading: false, allApps: [], filteredApps: [], searchQuery: '')) {
    loadApps();
  }

  Future<void> loadApps() async {
    state = state.copyWith(isLoading: true);
    final apps = await _repository.fetchAllApps();
    state = state.copyWith(
      isLoading: false,
      allApps: apps,
      filteredApps: apps,
    );
  }

  void search(String query) {
    final lowerQuery = query.toLowerCase();
    final filtered = state.allApps.where((app) {
      return app.appName.toLowerCase().contains(lowerQuery) ||
          app.packageName.toLowerCase().contains(lowerQuery);
    }).toList();

    state = state.copyWith(searchQuery: query, filteredApps: filtered);
  }

  Future<bool> toggleAppStatus(AppInfoModel app) async {
    bool success = false;
    if (app.isEnabled) {
      success = await _repository.disableApp(app.packageName);
    } else {
      success = await _repository.enableApp(app.packageName);
    }

    if (success) {
      await loadApps();
    }
    return success;
  }
}

final appNotifierProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  final repository = ref.watch(appRepositoryProvider);
  return AppNotifier(repository);
});