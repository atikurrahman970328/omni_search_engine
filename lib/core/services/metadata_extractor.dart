import 'dart:io';
import 'package:ffmpeg_kit_flutter_full/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_full/media_information_json_parser.dart';

class MediaMetadata {
  final double duration;
  final int bitrate;
  final String codec;
  final int width;
  final int height;

  MediaMetadata({
    required this.duration,
    required this.bitrate,
    required this.codec,
    required this.width,
    required this.height,
  });
}

class MetadataExtractor {
  /// অডিও ও ভিডিও ফাইলের FFmpeg মেটাডেটা প্রসেস করে
  static Future<MediaMetadata?> extractMediaMetadata(String filePath) async {
    try {
      final session = await FFprobeKit.getMediaInformation(filePath);
      final information = session.getMediaInformation();

      if (information == null) return null;

      final jsonMap = information.getAllProperties();
      if (jsonMap == null) return null;

      final parsedInfo = MediaInformationJsonParser.fromMap(jsonMap);
      final format = parsedInfo.getFormat();
      final streams = parsedInfo.getStreams();

      double duration = double.tryParse(format?.getDuration() ?? '0') ?? 0.0;
      int bitrate = int.tryParse(format?.getBitrate() ?? '0') ?? 0;
      
      String codec = 'Unknown';
      int width = 0;
      int height = 0;

      if (streams.isNotEmpty) {
        final videoStream = streams.firstWhere(
          (s) => s.getCodecType() == 'video',
          orElse: () => streams.first,
        );
        codec = videoStream.getCodecName() ?? 'Unknown';
        width = videoStream.getWidth() ?? 0;
        height = videoStream.getHeight() ?? 0;
      }

      return MediaMetadata(
        duration: duration,
        bitrate: bitrate,
        codec: codec,
        width: width,
        height: height,
      );
    } catch (e) {
      print("Metadata Extraction Error: $e");
      return null;
    }
  }

  /// ছবি থেকে ফাইল সাইজ ও প্রাথমিক প্রপার্টিজ বের করে
  static Future<Map<String, dynamic>> extractImageProperties(String filePath) async {
    final file = File(filePath);
    if (!await file.exists()) return {};

    final stat = await file.stat();
    return {
      'size': stat.size,
      'lastModified': stat.modified.millisecondsSinceEpoch,
      'path': filePath,
    };
  }
}