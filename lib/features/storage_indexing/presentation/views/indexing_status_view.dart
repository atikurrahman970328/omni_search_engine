import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/indexing_provider.dart';

class IndexingStatusView extends ConsumerWidget {
  const IndexingStatusView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(indexingProvider);
    final notifier = ref.read(indexingProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Storage Indexing Status'),
        backgroundColor: AppColors.cardSurface,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: AppColors.cardSurface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Icon(
                      state.isIndexing
                          ? Icons.sync_sharp
                          : Icons.storage_rounded,
                      size: 48,
                      color: state.isIndexing
                          ? AppColors.accentSecondary
                          : AppColors.statusSuccess,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.isIndexing
                          ? 'Scanning & Indexing Storage...'
                          : 'Storage Engine Ready',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Total Indexed Files: ${state.totalFiles}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    if (state.isIndexing) ...[
                      const SizedBox(height: 16),
                      LinearProgressIndicator(
                        backgroundColor: AppColors.backgroundDark,
                        color: AppColors.accentPrimary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Processed: ${state.scannedCount} files',
                        style: const TextStyle(
                          color: AppColors.accentSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: state.isIndexing
                    ? AppColors.statusDanger
                    : AppColors.accentPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                if (state.isIndexing) {
                  notifier.stopIndexing();
                } else {
                  notifier.startIndexing();
                }
              },
              icon: Icon(
                state.isIndexing ? Icons.stop_rounded : Icons.play_arrow_rounded,
                color: Colors.white,
              ),
              label: Text(
                state.isIndexing ? 'Stop Indexing' : 'Start Re-Indexing',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}