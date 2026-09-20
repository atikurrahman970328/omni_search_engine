import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/app_info_model.dart';
import '../providers/app_provider.dart';

class AppListView extends ConsumerWidget {
  const AppListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appNotifierProvider);
    final notifier = ref.read(appNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('System & User Apps'),
        backgroundColor: AppColors.cardSurface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: () => notifier.loadApps(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              onChanged: (value) => notifier.search(value),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search app by name or package...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.accentPrimary),
                filled: true,
                fillColor: AppColors.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accentPrimary),
                  )
                : state.filteredApps.isEmpty
                    ? const Center(
                        child: Text(
                          'No applications found',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: state.filteredApps.length,
                        itemBuilder: (context, index) {
                          final app = state.filteredApps[index];
                          return _AppTile(app: app, notifier: notifier);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _AppTile extends StatelessWidget {
  final AppInfoModel app;
  final AppNotifier notifier;

  const _AppTile({
    Key? key,
    required this.app,
    required this.notifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: app.isSystemApp
              ? AppColors.statusWarning.withOpacity(0.2)
              : AppColors.accentPrimary.withOpacity(0.2),
          child: Icon(
            app.isSystemApp ? Icons.android : Icons.apps,
            color: app.isSystemApp
                ? AppColors.statusWarning
                : AppColors.accentPrimary,
          ),
        ),
        title: Text(
          app.appName,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          app.packageName,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: Switch(
          value: app.isEnabled,
          activeColor: AppColors.statusSuccess,
          inactiveThumbColor: AppColors.statusDanger,
          onChanged: (bool value) async {
            final success = await notifier.toggleAppStatus(app);
            if (!success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Failed to update app state. Check Shizuku permissions.'),
                  backgroundColor: AppColors.statusDanger,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}