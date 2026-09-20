import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/file_system_datasource.dart';
import '../../data/repositories/indexing_repository_impl.dart';
import '../../domain/repositories/indexing_repository.dart';

// Datasource & Repository Providers
final fileSystemDatasourceProvider = Provider<FileSystemDatasource>((ref) {
  return FileSystemDatasource();
});

final indexingRepositoryProvider = Provider<IndexingRepository>((ref) {
  final datasource = ref.watch(fileSystemDatasourceProvider);
  return IndexingRepositoryImpl(datasource: datasource);
});

// State Model for Indexing Process
class IndexingState {
  final bool isIndexing;
  final int scannedCount;
  final int totalFiles;

  IndexingState({
    required this.isIndexing,
    required this.scannedCount,
    required this.totalFiles,
  });

  IndexingState copyWith({
    bool? isIndexing,
    int? scannedCount,
    int? totalFiles,
  }) {
    return IndexingState(
      isIndexing: isIndexing ?? this.isIndexing,
      scannedCount: scannedCount ?? this.scannedCount,
      totalFiles: totalFiles ?? this.totalFiles,
    );
  }
}

// Indexing State Notifier
class IndexingNotifier extends StateNotifier<IndexingState> {
  final IndexingRepository _repository;

  IndexingNotifier(this._repository)
      : super(IndexingState(isIndexing: false, scannedCount: 0, totalFiles: 0)) {
    loadIndexedCount();
  }

  Future<void> loadIndexedCount() async {
    final count = await _repository.getTotalIndexedFilesCount();
    state = state.copyWith(totalFiles: count);
  }

  Future<void> startIndexing() async {
    state = state.copyWith(isIndexing: true, scannedCount: 0);

    await _repository.startIndexing(
      onProgress: (scanned) {
        state = state.copyWith(scannedCount: scanned);
      },
    );

    await loadIndexedCount();
    state = state.copyWith(isIndexing: false);
  }

  Future<void> stopIndexing() async {
    await _repository.stopIndexing();
    state = state.copyWith(isIndexing: false);
  }
}

final indexingProvider = StateNotifierProvider<IndexingNotifier, IndexingState>((ref) {
  final repository = ref.watch(indexingRepositoryProvider);
  return IndexingNotifier(repository);
});