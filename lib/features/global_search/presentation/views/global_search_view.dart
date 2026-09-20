import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../data/models/search_result.dart';
import '../providers/global_search_provider.dart';

class GlobalSearchView extends ConsumerStatefulWidget {
  const GlobalSearchView({Key? key}) : super(key: key);

  @override
  ConsumerState<GlobalSearchView> createState() => _GlobalSearchViewState();
}

class _GlobalSearchViewState extends ConsumerState<GlobalSearchView> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(globalSearchNotifierProvider);
    final searchNotifier = ref.read(globalSearchNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('OmniSearch Engine'),
        backgroundColor: AppColors.cardSurface,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search Input Bar
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => searchNotifier.performSearch(val),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: InputDecoration(
                hintText: 'Search files, OCR text, apps...',
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.accentPrimary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                        onPressed: () {
                          _searchController.clear();
                          searchNotifier.clearSearch();
                        },
                      )
                    : null,
                filled: true,
                fillColor: AppColors.cardSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // Category Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              children: [
                _buildFilterChip(
                  label: 'All Results',
                  selected: searchState.selectedFilter == null,
                  onSelected: (_) => searchNotifier.setFilter(null),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Files',
                  selected: searchState.selectedFilter == SearchResultType.file,
                  onSelected: (_) => searchNotifier.setFilter(SearchResultType.file),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: 'Apps',
                  selected: searchState.selectedFilter == SearchResultType.app,
                  onSelected: (_) => searchNotifier.setFilter(SearchResultType.app),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Search Results Area
          Expanded(
            child: searchState.isSearching
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.accentPrimary),
                  )
                : searchState.results.isEmpty && searchState.query.isNotEmpty
                    ? const Center(
                        child: Text(
                          'No matching files or apps found',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.builder(
                        itemCount: searchState.results.length,
                        itemBuilder: (context, index) {
                          final item = searchState.results[index];
                          return _SearchResultTile(item: item);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool selected,
    required Function(bool) onSelected,
  }) {
    return ChoiceChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : AppColors.textSecondary,
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedColor: AppColors.accentPrimary,
      backgroundColor: AppColors.cardSurface,
      onSelected: onSelected,
    );
  }
}

class _SearchResultTile extends StatelessWidget {
  final SearchResult item;

  const _SearchResultTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    IconData leadingIcon = Icons.insert_drive_file;
    Color iconColor = AppColors.accentSecondary;

    if (item.type == SearchResultType.app) {
      leadingIcon = Icons.android;
      iconColor = AppColors.statusSuccess;
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.15),
          child: Icon(leadingIcon, color: iconColor),
        ),
        title: Text(
          item.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          item.subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        onTap: () {
          // Action mapping based on result type
        },
      ),
    );
  }
}