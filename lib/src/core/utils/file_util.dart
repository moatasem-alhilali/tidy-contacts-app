import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class FileUtil {
  static Future<String> get tempDir async {
    final dir = await path_provider.getTemporaryDirectory();
    return dir.path;
  }

  static String getFileName(String filePath) {
    final uri = Uri.parse(filePath);
    return uri.pathSegments.isNotEmpty ? uri.pathSegments.last : '';
  }

  static Future<void> openFile(String filePath) async {
    if (filePath.isNotEmpty) {
      final result = await OpenFile.open(filePath);

      if (result.type != ResultType.done) {
        return;
      }
    } else {
      return;
    }
  }
}
