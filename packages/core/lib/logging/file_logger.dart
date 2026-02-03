// ignore_for_file: avoid_print

import 'dart:io';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

/// 文件日志输出器
/// 将日志写入本地文件，支持文件大小限制和自动清理
class AppFileOutput extends LogOutput {
  final int maxFileSizeBytes;
  final int maxFileCount;
  final String fileNamePrefix;

  File? _currentFile;
  int _currentFileSize = 0;

  AppFileOutput({
    this.maxFileSizeBytes = 5 * 1024 * 1024, // 默认 5MB
    this.maxFileCount = 5, // 默认保留 5 个日志文件
    this.fileNamePrefix = 'app_log',
  });

  @override
  void output(OutputEvent event) {
    _writeToFile(event.lines);
  }

  Future<void> _writeToFile(List<String> lines) async {
    try {
      final file = await _getLogFile();
      final content = '${lines.join('\n')}\n';

      await file.writeAsString(content, mode: FileMode.append);
      _currentFileSize += content.length;

      // 检查文件大小，如果超过限制则创建新文件
      if (_currentFileSize >= maxFileSizeBytes) {
        await _rotateLogFile();
      }
    } catch (e) {
      // 静默失败，避免日志系统本身抛出异常
      print('Failed to write log to file: $e');
    }
  }

  Future<File> _getLogFile() async {
    if (_currentFile != null && await _currentFile!.exists()) {
      return _currentFile!;
    }

    final dir = await getApplicationDocumentsDirectory();
    final logDir = Directory('${dir.path}/logs');

    if (!await logDir.exists()) {
      await logDir.create(recursive: true);
    }

    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    _currentFile = File('${logDir.path}/${fileNamePrefix}_$timestamp.log');
    _currentFileSize = 0;

    return _currentFile!;
  }

  Future<void> _rotateLogFile() async {
    // 清理旧文件
    await _cleanOldLogFiles();

    // 重置当前文件
    _currentFile = null;
    _currentFileSize = 0;
  }

  Future<void> _cleanOldLogFiles() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/logs');

      if (!await logDir.exists()) {
        return;
      }

      final files = await logDir
          .list()
          .where((entity) => entity is File && entity.path.contains(fileNamePrefix))
          .cast<File>()
          .toList();

      // 按修改时间排序
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      // 删除超过限制的旧文件
      if (files.length > maxFileCount) {
        for (var i = maxFileCount; i < files.length; i++) {
          await files[i].delete();
        }
      }
    } catch (e) {
      print('Failed to clean old log files: $e');
    }
  }

  /// 获取所有日志文件
  static Future<List<File>> getAllLogFiles() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/logs');

      if (!await logDir.exists()) {
        return [];
      }

      final files = await logDir
          .list()
          .where((entity) => entity is File && entity.path.endsWith('.log'))
          .cast<File>()
          .toList();

      // 按修改时间排序（最新的在前）
      files.sort((a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()));

      return files;
    } catch (e) {
      print('Failed to get log files: $e');
      return [];
    }
  }

  /// 清除所有日志文件
  static Future<void> clearAllLogs() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final logDir = Directory('${dir.path}/logs');

      if (await logDir.exists()) {
        await logDir.delete(recursive: true);
      }
    } catch (e) {
      print('Failed to clear logs: $e');
    }
  }

  /// 获取日志目录总大小（字节）
  static Future<int> getLogDirectorySize() async {
    try {
      final files = await getAllLogFiles();
      int totalSize = 0;

      for (var file in files) {
        totalSize += await file.length();
      }

      return totalSize;
    } catch (e) {
      print('Failed to get log directory size: $e');
      return 0;
    }
  }
}
