import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hive_manager/src/core/services/notifications/notification_payload.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class NotificationImageHelper {
  static const Uuid _uuid = Uuid();

  static Future<String?> downloadAndCacheImage(
    String url, {
    String? fileName,
  }) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/${fileName ?? _uuid.v4()}';
        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);
        return filePath;
      }
    } catch (e) {
      debugPrint('Error downloading notification image: $e');
    }
    return null;
  }

  static Future<void> preloadImages(NotificationPayload payload) async {
    try {
      await Future.wait([
        if (payload.largeIconUrl != null)
          downloadAndCacheImage(payload.largeIconUrl!, fileName: 'large_icon'),
        if (payload.bigPictureUrl != null)
          downloadAndCacheImage(
            payload.bigPictureUrl!,
            fileName: 'big_picture',
          ),
        if (payload.thumbnailUrl != null)
          downloadAndCacheImage(payload.thumbnailUrl!, fileName: 'thumbnail'),
      ]);
    } catch (e) {
      debugPrint('Error preloading notification images: $e');
    }
  }

  static Future<void> clearCache() async {
    try {
      final directory = await getTemporaryDirectory();
      if (await directory.exists()) {
        final files = await directory.list().toList();
        for (final file in files) {
          if (file is File) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Error clearing notification image cache: $e');
    }
  }
}
