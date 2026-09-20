enum SearchResultType { file, app, systemAction }

class SearchResult {
  final String id;
  final String title;
  final String subtitle;
  final String pathOrPackage;
  final SearchResultType type;
  final String? iconPath;
  final Map<String, dynamic>? metadata;

  SearchResult({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.pathOrPackage,
    required this.type,
    this.iconPath,
    this.metadata,
  });

  factory SearchResult.fromFileMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['id']?.toString() ?? map['path'],
      title: map['name'] ?? '',
      subtitle: map['path'] ?? '',
      pathOrPackage: map['path'] ?? '',
      type: SearchResultType.file,
      metadata: map,
    );
  }

  factory SearchResult.fromAppMap(Map<String, dynamic> map) {
    return SearchResult(
      id: map['packageName'] ?? '',
      title: map['appName'] ?? '',
      subtitle: map['packageName'] ?? '',
      pathOrPackage: map['packageName'] ?? '',
      type: SearchResultType.app,
      metadata: map,
    );
  }
}