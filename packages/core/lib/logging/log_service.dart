import 'dart:io';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:api_client/client/api_client.dart';
import 'file_logger.dart' as app_logger;

part 'log_service.g.dart';

/// 日志服务
/// 提供日志管理和分享功能
class LogService {
  final Logger _logger;

  LogService(this._logger);

  /// 获取所有日志文件
  Future<List<LogFile>> getAllLogs() async {
    final files = await app_logger.AppFileOutput.getAllLogFiles();
    return files.map((file) => LogFile.fromFile(file)).toList();
  }

  /// 获取日志总大小（格式化字符串）
  Future<String> getLogSizeFormatted() async {
    final bytes = await app_logger.AppFileOutput.getLogDirectorySize();
    return _formatBytes(bytes);
  }

  /// 分享单个日志文件
  Future<void> shareLogFile(File file) async {
    try {
      final xFile = XFile(file.path);
      await Share.shareXFiles(
        [xFile],
        subject: 'App Log - ${DateFormat('yyyy-MM-dd HH:mm').format(file.lastModifiedSync())}',
      );
      _logger.i('Shared log file: ${file.path}');
    } catch (e) {
      _logger.e('Failed to share log file', error: e);
      rethrow;
    }
  }

  /// 分享所有日志文件
  Future<void> shareAllLogs() async {
    try {
      final files = await app_logger.AppFileOutput.getAllLogFiles();
      if (files.isEmpty) {
        throw Exception('No log files found');
      }

      final xFiles = files.map((file) => XFile(file.path)).toList();
      await Share.shareXFiles(
        xFiles,
        subject: 'App Logs - ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
      );
      _logger.i('Shared ${files.length} log files');
    } catch (e) {
      _logger.e('Failed to share all logs', error: e);
      rethrow;
    }
  }

  /// 清除所有日志
  Future<void> clearAllLogs() async {
    try {
      await app_logger.AppFileOutput.clearAllLogs();
      _logger.i('Cleared all log files');
    } catch (e) {
      _logger.e('Failed to clear logs', error: e);
      rethrow;
    }
  }

  /// 删除单个日志文件
  Future<void> deleteLogFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
        _logger.i('Deleted log file: ${file.path}');
      }
    } catch (e) {
      _logger.e('Failed to delete log file', error: e);
      rethrow;
    }
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  }
}

/// 日志文件信息
class LogFile {
  final File file;
  final String name;
  final DateTime lastModified;
  final int size;

  LogFile({
    required this.file,
    required this.name,
    required this.lastModified,
    required this.size,
  });

  factory LogFile.fromFile(File file) {
    return LogFile(
      file: file,
      name: file.path.split('/').last,
      lastModified: file.lastModifiedSync(),
      size: file.lengthSync(),
    );
  }

  String get sizeFormatted {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(2)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(2)} MB';
  }

  String get lastModifiedFormatted {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(lastModified);
  }
}

/// 日志服务 Provider
@riverpod
LogService logService(Ref ref) {
  final logger = ref.watch(loggerProvider);
  return LogService(logger);
}
