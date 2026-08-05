import 'dart:io';

import 'package:file_picker/file_picker.dart';

/// Data Transfer Object representing a picked file.
class PickedFile {
  // bytes

  PickedFile({
    required this.name,
    required this.path,
    this.extension,
    this.size,
  });

  /// Create from PlatformFile (file_picker)
  factory PickedFile.fromPlatformFile(PlatformFile file) => PickedFile(
        name: file.name,
        path: file.path ?? '',
        extension: file.extension,
        size: file.size,
      );
  final String name;
  final String path;
  final String? extension;
  final int? size;

  File asFile() => File(path);

  @override
  String toString() =>
      'PickedFile(name: $name, path: $path, ext: $extension, size: $size)';
}

/// Exception for file picking errors
class FilePickerException implements Exception {
  FilePickerException(this.message);
  final String message;
  @override
  String toString() => 'FilePickerException: $message';
}

/// Singleton Service for picking files safely and consistently.
class FilePickerService {
  FilePickerService._();
  static final FilePickerService instance = FilePickerService._();

  /// Pick a single file.
  /// [allowedExtensions] limits types, e.g. ['pdf', 'jpg'].
  /// Returns null if user cancels.
  Future<PickedFile?> pickSingle({
    List<String>? allowedExtensions,
    bool withData = false,
    bool throwError = true,
  }) async {
    try {
      final result = await FilePicker.pickFiles(
        type: allowedExtensions == null ? FileType.any : FileType.custom,
        allowedExtensions: allowedExtensions,
        withData: withData,
      );
      if (result == null || result.files.isEmpty) return null;
      final file = result.files.first;
      if (file.path == null) throw FilePickerException('File has no path');
      return PickedFile.fromPlatformFile(file);
    } catch (e) {
      if (throwError) throw FilePickerException(_getErrorMessage(e));
      return null;
    }
  }

  /// Pick multiple files.
  Future<List<PickedFile>> pickMultiple({
    List<String>? allowedExtensions,
    bool withData = false,
    bool throwError = true,
  }) async {
    try {
      final result = await FilePicker.pickFiles(
        type: allowedExtensions == null ? FileType.any : FileType.custom,
        allowedExtensions: allowedExtensions,
        allowMultiple: true,
        withData: withData,
      );
      if (result == null || result.files.isEmpty) return [];
      return result.files
          .where((file) => file.path != null)
          .map(PickedFile.fromPlatformFile)
          .toList();
    } catch (e) {
      if (throwError) throw FilePickerException(_getErrorMessage(e));
      return [];
    }
  }

  /// Pick directory path only (returns folder path).
  Future<String?> pickDirectory({
    bool throwError = true,
  }) async {
    try {
      return await FilePicker.getDirectoryPath();
    } catch (e) {
      if (throwError) throw FilePickerException(_getErrorMessage(e));
      return null;
    }
  }

  /// Validate access for storage (optional, implement if you want)
  /// Add permission_handler if you want robust checks on Android/iOS
  /// Call before pickSingle/pickMultiple if you require explicit permission.
  Future<void> ensureStoragePermission() async {
    // Optionally implement: See permission_handler plugin.
  }

  String _getErrorMessage(Object e) {
    if (e is FilePickerException) return e.message;
    if (e is Exception) return e.toString();
    return 'Unknown error: $e';
  }
}
