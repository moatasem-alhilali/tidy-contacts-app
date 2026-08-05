import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

/// أنواع الملفات المدعومة
enum FileType {
  pdf,
  image,
  document,
  audio,
  video,
  other,
}

/// خيارات الحفظ
class SaveOptions {
  const SaveOptions({
    this.fileType = FileType.other,
    this.publicVisible = true,
    this.overwrite = false,
    this.createSubfolder = true,
    this.customFolderName,
    this.customFileName,
    this.metadata,
  });

  final FileType fileType;
  final bool publicVisible; // هل الملف يظهر للمستخدم في المعرض/التنزيلات؟
  final bool overwrite; // هل يتم استبدال الملف إذا كان موجود؟
  final bool createSubfolder; // هل يتم إنشاء مجلد فرعي؟
  final String? customFolderName; // اسم مجلد مخصص
  final String? customFileName; // اسم ملف مخصص
  final Map<String, String>? metadata; // بيانات إضافية
}

/// نتيجة الحفظ المحسنة
class SaveResult {
  const SaveResult({
    required this.success,
    required this.message,
    this.publicVisible = false,
    this.publicUri,
    this.appFile,
    this.fileSize,
    this.filePath,
    this.error,
  }); // رسالة الخطأ إذا فشل الحفظ

  /// إنشاء نتيجة نجاح
  factory SaveResult.success({
    required String message,
    bool publicVisible = true,
    Uri? publicUri,
    File? appFile,
    int? fileSize,
    String? filePath,
  }) {
    return SaveResult(
      success: true,
      message: message,
      publicVisible: publicVisible,
      publicUri: publicUri,
      appFile: appFile,
      fileSize: fileSize,
      filePath: filePath,
    );
  }

  /// إنشاء نتيجة فشل
  factory SaveResult.failure({
    required String message,
    String? error,
  }) {
    return SaveResult(
      success: false,
      message: message,
      error: error,
    );
  }

  final bool success; // نجح الحفظ أم لا
  final bool publicVisible; // هل الملف في Downloads/Pictures ويظهر للمستخدم؟
  final Uri? publicUri; // URI عند الحفظ العام عبر MediaStore (content://)
  final File? appFile; // ملف داخل مساحة التطبيق عند fallback
  final String message; // رسالة مختصرة للعرض للمستخدم
  final int? fileSize; // حجم الملف بالبايت
  final String? filePath; // مسار الملف
  final String? error;
}

/// خدمة محسنة لحفظ الملفات باستخدام MediaStore
class MediaStorePlusService {
  MediaStorePlusService._({String appFolder = 'EtqanApp'})
      : appFolder = appFolder {
    MediaStore.appFolder = appFolder;
  }

  static MediaStorePlusService? _instance;
  static MediaStorePlusService get instance =>
      _instance ??= MediaStorePlusService._();

  final String appFolder;

  /// حفظ ملف مع خيارات مخصصة
  Future<SaveResult> saveFile({
    required String fileName,
    required Uint8List fileBytes,
    SaveOptions options = const SaveOptions(),
  }) async {
    try {
      await MediaStore.ensureInitialized();

      // التحقق من صحة البيانات
      if (fileBytes.isEmpty) {
        return SaveResult.failure(
          message: 'الملف فارغ',
          error: 'File bytes are empty',
        );
      }

      // تحديد نوع الملف تلقائياً إذا لم يتم تحديده
      final fileType = options.fileType == FileType.other
          ? _detectFileType(fileName)
          : options.fileType;

      // إعداد اسم الملف
      final finalFileName = _prepareFileName(fileName, fileType, options);

      // محاولة الحفظ العام أولاً
      if (options.publicVisible) {
        final publicResult = await _saveToPublicStorage(
          finalFileName,
          fileBytes,
          fileType,
          options,
        );
        if (publicResult.success) {
          return publicResult;
        }
      }

      // الحفظ في مساحة التطبيق كبديل
      return await _saveToAppStorage(
        finalFileName,
        fileBytes,
        fileType,
        options,
      );
    } catch (e) {
      if (kDebugMode) {
        print('MediaStorePlusService Error: $e');
      }
      return SaveResult.failure(
        message: 'فشل في حفظ الملف',
        error: e.toString(),
      );
    }
  }

  /// حفظ PDF
  Future<SaveResult> savePdf(String fileName, Uint8List pdfBytes) async {
    return saveFile(
      fileName: fileName,
      fileBytes: pdfBytes,
      options: const SaveOptions(fileType: FileType.pdf),
    );
  }

  /// حفظ صورة
  Future<SaveResult> saveImage(String fileName, Uint8List imageBytes) async {
    return saveFile(
      fileName: fileName,
      fileBytes: imageBytes,
      options: const SaveOptions(fileType: FileType.image),
    );
  }

  /// حفظ مستند
  Future<SaveResult> saveDocument(
    String fileName,
    Uint8List documentBytes,
  ) async {
    return saveFile(
      fileName: fileName,
      fileBytes: documentBytes,
      options: const SaveOptions(fileType: FileType.document),
    );
  }

  /// حفظ ملف صوتي
  Future<SaveResult> saveAudio(String fileName, Uint8List audioBytes) async {
    return saveFile(
      fileName: fileName,
      fileBytes: audioBytes,
      options: const SaveOptions(fileType: FileType.audio),
    );
  }

  /// حفظ ملف فيديو
  Future<SaveResult> saveVideo(String fileName, Uint8List videoBytes) async {
    return saveFile(
      fileName: fileName,
      fileBytes: videoBytes,
      options: const SaveOptions(fileType: FileType.video),
    );
  }

  /// حفظ عدة ملفات دفعة واحدة
  Future<List<SaveResult>> saveMultipleFiles({
    required List<Map<String, dynamic>> files,
    SaveOptions defaultOptions = const SaveOptions(),
  }) async {
    final results = <SaveResult>[];

    for (final fileData in files) {
      final fileName = fileData['fileName'] as String;
      final fileBytes = fileData['bytes'] as Uint8List;
      final options = fileData['options'] as SaveOptions? ?? defaultOptions;

      final result = await saveFile(
        fileName: fileName,
        fileBytes: fileBytes,
        options: options,
      );

      results.add(result);
    }

    return results;
  }

  // ===== Helper Methods =====

  /// تحديد نوع الملف من الامتداد
  FileType _detectFileType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;

    switch (extension) {
      case 'pdf':
        return FileType.pdf;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return FileType.image;
      case 'doc':
      case 'docx':
      case 'txt':
      case 'rtf':
        return FileType.document;
      case 'mp3':
      case 'wav':
      case 'aac':
      case 'ogg':
        return FileType.audio;
      case 'mp4':
      case 'avi':
      case 'mov':
      case 'mkv':
        return FileType.video;
      default:
        return FileType.other;
    }
  }

  /// إعداد اسم الملف النهائي
  String _prepareFileName(
    String fileName,
    FileType fileType,
    SaveOptions options,
  ) {
    var finalName = options.customFileName ?? fileName;

    // إضافة الطابع الزمني إذا لم يتم السماح بالاستبدال
    if (!options.overwrite) {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final nameWithoutExt = finalName.split('.').first;
      final extension = finalName.split('.').last;
      finalName = '${nameWithoutExt}_$timestamp.$extension';
    }

    return finalName;
  }

  /// الحفظ في التخزين العام (MediaStore)
  Future<SaveResult> _saveToPublicStorage(
    String fileName,
    Uint8List bytes,
    FileType fileType,
    SaveOptions options,
  ) async {
    try {
      final tmp = await _writeTemp(bytes, fileName);
      try {
        final dirConfig = _getDirectoryConfig(fileType, options);
        final folderName = options.customFolderName ?? appFolder;

        final info = await MediaStore().saveFile(
          tempFilePath: tmp.path,
          dirType: dirConfig.dirType,
          dirName: dirConfig.dirName,
          relativePath: options.createSubfolder ? folderName : null,
        );

        if (info?.uri != null) {
          return SaveResult.success(
            message: _getSuccessMessage(fileType, dirConfig.location),
            publicUri: info!.uri,
            fileSize: bytes.length,
            filePath: info.uri.toString(),
          );
        }

        return SaveResult.failure(
          message: 'فشل في الحفظ العام',
          error: 'MediaStore returned null URI',
        );
      } finally {
        _silentDelete(tmp);
      }
    } catch (e) {
      return SaveResult.failure(
        message: 'خطأ في الحفظ العام',
        error: e.toString(),
      );
    }
  }

  /// الحفظ في مساحة التطبيق
  Future<SaveResult> _saveToAppStorage(
    String fileName,
    Uint8List bytes,
    FileType fileType,
    SaveOptions options,
  ) async {
    try {
      final dir = await getExternalStorageDirectory();
      if (dir == null) {
        return SaveResult.failure(
          message: 'لا يمكن الوصول لمساحة التطبيق',
          error: 'External storage directory is null',
        );
      }

      var folderPath = dir.path;
      if (options.createSubfolder) {
        final folderName = options.customFolderName ?? appFolder;
        folderPath = '${dir.path}/$folderName';
        final folder = Directory(folderPath);
        if (!await folder.exists()) {
          await folder.create(recursive: true);
        }
      }

      final filePath = '$folderPath/$fileName';
      final file = File(filePath);

      // التحقق من وجود الملف إذا لم يتم السماح بالاستبدال
      if (!options.overwrite && await file.exists()) {
        return SaveResult.failure(
          message: 'الملف موجود بالفعل',
          error: 'File already exists and overwrite is disabled',
        );
      }

      await file.writeAsBytes(bytes, flush: true);

      return SaveResult.success(
        message: 'تم الحفظ داخل التطبيق',
        publicVisible: false,
        appFile: file,
        fileSize: bytes.length,
        filePath: filePath,
      );
    } catch (e) {
      return SaveResult.failure(
        message: 'فشل في الحفظ داخل التطبيق',
        error: e.toString(),
      );
    }
  }

  /// الحصول على إعدادات المجلد حسب نوع الملف
  ({DirType dirType, DirName dirName, String location}) _getDirectoryConfig(
    FileType fileType,
    SaveOptions options,
  ) {
    switch (fileType) {
      case FileType.pdf:
      case FileType.document:
        return (
          dirType: DirType.download,
          dirName: DirName.download,
          location: 'التنزيلات'
        );
      case FileType.image:
        return (
          dirType: DirType.photo,
          dirName: DirName.pictures,
          location: 'المعرض'
        );
      case FileType.audio:
        return (
          dirType: DirType.audio,
          dirName: DirName.music,
          location: 'الموسيقى'
        );
      case FileType.video:
        return (
          dirType: DirType.video,
          dirName: DirName.movies,
          location: 'الفيديوهات'
        );
      default:
        return (
          dirType: DirType.download,
          dirName: DirName.download,
          location: 'التنزيلات'
        );
    }
  }

  /// الحصول على رسالة النجاح
  String _getSuccessMessage(FileType fileType, String location) {
    switch (fileType) {
      case FileType.pdf:
        return 'تم حفظ PDF في $location';
      case FileType.image:
        return 'تم حفظ الصورة في $location';
      case FileType.document:
        return 'تم حفظ المستند في $location';
      case FileType.audio:
        return 'تم حفظ الملف الصوتي في $location';
      case FileType.video:
        return 'تم حفظ الفيديو في $location';
      default:
        return 'تم حفظ الملف في $location';
    }
  }

  /// كتابة ملف مؤقت
  Future<File> _writeTemp(Uint8List bytes, String fileName) async {
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  /// حذف ملف مؤقت بصمت
  void _silentDelete(File file) {
    try {
      if (file.existsSync()) {
        file.deleteSync();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Could not delete temp file ${file.path}: $e');
      }
    }
  }
}
