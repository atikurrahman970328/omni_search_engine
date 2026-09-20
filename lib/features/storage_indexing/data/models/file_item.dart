class FileItem {
  final int? id;
  final String path;
  final String name;
  final String extension;
  final int size;
  final int lastModified;
  final String mimeType;

  FileItem({
    this.id,
    required this.path,
    required this.name,
    required this.extension,
    required this.size,
    required this.lastModified,
    required this.mimeType,
  });

  /// SQLite DB থেকে আসা Map অবজেক্টকে FileItem এ রূপান্তর করে
  factory FileItem.fromMap(Map<String, dynamic> map) {
    return FileItem(
      id: map['id'] as int?,
      path: map['path'] as String,
      name: map['name'] as String,
      extension: map['extension'] as String,
      size: map['size'] as int,
      lastModified: map['lastModified'] ?? map['last_modified'] as int,
      mimeType: map['mimeType'] ?? map['mime_type'] as String,
    );
  }

  /// FileItem কে SQLite DB এ ইনসার্ট করার জন্য Map এ রূপান্তর করে
  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'path': path,
      'name': name,
      'extension': extension,
      'size': size,
      'last_modified': lastModified,
      'mime_type': mimeType,
    };
  }
}