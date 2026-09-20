import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'database_helper.dart';

class WebServerService {
  HttpServer? _server;
  bool _isRunning = false;

  bool get isRunning => _isRunning;
  int? get port => _server?.port;

  /// লোকাল ওয়েব সার্ভার চালু করার মেথড
  Future<String?> startServer({int port = 8080}) async {
    if (_isRunning) return 'Server already running on port ${_server?.port}';

    final router = Router();

    // Health Check Endpoint
    router.get('/api/status', (Request request) {
      return Response.ok(
        jsonEncode({'status': 'online', 'app': 'OmniSearch Engine'}),
        headers: {'content-type': 'application/json'},
      );
    });

    // Cross-Platform Web Search API Endpoint
    router.get('/api/search', (Request request) async {
      final query = request.url.queryParameters['q'];
      if (query == null || query.isEmpty) {
        return Response.badRequest(
          body: jsonEncode({'error': 'Query parameter "q" is required'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final results = await DatabaseHelper.instance.searchFiles(query);
      return Response.ok(
        jsonEncode({'query': query, 'count': results.length, 'results': results}),
        headers: {'content-type': 'application/json'},
      );
    });

    // Direct File Download API Endpoint
    router.get('/api/file', (Request request) async {
      final filePath = request.url.queryParameters['path'];
      if (filePath == null) {
        return Response.badRequest(
          body: jsonEncode({'error': 'File path parameter "path" is required'}),
          headers: {'content-type': 'application/json'},
        );
      }

      final file = File(filePath);
      if (!await file.exists()) {
        return Response.notFound(
          jsonEncode({'error': 'File not found on device'}),
          headers: {'content-type': 'application/json'},
        );
      }

      return Response.ok(
        file.openRead(),
        headers: {
          'content-type': 'application/octet-stream',
          'content-disposition': 'attachment; filename="${file.uri.pathSegments.last}"',
        },
      );
    });

    final handler = const Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    try {
      _server = await shelf_io.serve(handler, InternetAddress.anyIPv4, port);
      _isRunning = true;
      debugPrint('OmniSearch Web Server running on port ${_server!.port}');
      return 'http://${_server!.address.host}:${_server!.port}';
    } catch (e) {
      debugPrint('Failed to start Web Server: $e');
      return null;
    }
  }

  /// ওয়েব সার্ভার বন্ধ করার মেথড
  Future<void> stopServer() async {
    if (_server != null) {
      await _server!.close(force: true);
      _server = null;
      _isRunning = false;
      debugPrint('OmniSearch Web Server stopped');
    }
  }
}