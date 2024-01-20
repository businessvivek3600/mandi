import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../utils/utils_index.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  LoggerService._internal();
  static LoggerService get instance => _instance;
  static const String folderName = 'errorLogs';
  static Future<File> logError(String logData, {String? extraData}) async {
    final DateTime now = DateTime.now();
    final String monthYearFolder = '${now.year}-${now.month}';

    final directory = await getApplicationDocumentsDirectory();
    final rootFolder = Directory('${directory.path}/$folderName');
    if (!rootFolder.existsSync()) {
      rootFolder.createSync();
    }
    final folder = Directory('${rootFolder.path}/$monthYearFolder');
    final file = File('${folder.path}/${_getFormattedDate(now)}.txt');
    logger.i('file path ${folder.existsSync()}',
        tag: 'LoggerService', error: file.path);

    if (!folder.existsSync()) {
      folder.createSync();
    }
    printErrorLog(file.path);
    final String timestamp = now.toLocal().toString();
    final String logEntry = '$timestamp, $extraData, $logData\n';

    // Check if file exists, if not, create it
    if (!await file.exists()) {
      await file.create(recursive: true);
    }

    // Open the file in append mode
    final fileSink = file.openSync(mode: FileMode.append);

    // Write the log data to the file
    fileSink.writeStringSync(logEntry);
    await fileSink.flush();
    await fileSink.close();
    return file;
  }

  static String _getFormattedDate(DateTime dateTime) => !kDebugMode
      ? '${dateTime.year}-${dateTime.month}-${dateTime.day}'
      : dateTime.toLocal().toString();

  Future<String> readErrorLog(String path) async {
    final file = File(path);

    if (file.existsSync()) {
      return file.readAsString();
    } else {
      return 'No errors logged.';
    }
  }

  Future<void> clearErrorLog() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/error_log.txt');
    if (file.existsSync()) {
      await file.delete();
    }
  }

  Future<void> shareErrorLog() async {
    final directory = await getApplicationDocumentsDirectory();
    final file = File('${directory.path}/error_log.txt');
    if (file.existsSync()) {
      await Share.shareFiles([file.path]);
    }
  }

  void deleteFolder(String folderPath) {
    Directory folder = Directory(folderPath);
    if (folder.existsSync()) folder.deleteSync(recursive: true);
  }

  /// get sub foder count and file count
  Map<String, int> getFolderFileCount(String folderPath) {
    Directory folder = Directory(folderPath);
    int subFolderCount = 0;
    int fileCount = 0;
    if (folder.existsSync()) {
      folder.listSync().forEach((element) {
        if (element is Directory) {
          subFolderCount++;
        } else if (element is File) {
          fileCount++;
        }
      });
    }
    return {'subFolderCount': subFolderCount, 'fileCount': fileCount};
  }

  Future<List<String>> getFolderList(String folderPath) async {
    Directory folder = Directory(folderPath);
    List<String> folderList = [];
    if (folder.existsSync()) {
      await folder.list().forEach((element) {
        if (element is Directory) {
          folderList.add(element.path);
        }
      });
    }
    return folderList;
  }

  Future<List<String>> getFileList(String folderPath) async {
    Directory folder = Directory(folderPath);
    List<String> fileList = [];
    if (folder.existsSync()) {
      await folder.list().forEach((element) {
        if (element is File) {
          fileList.add(element.path);
        }
      });
    }
    return fileList;
  }

  Future<void> deleteAllErrorLog() async {
    final directory = await getApplicationDocumentsDirectory();
    final rootFolder = Directory('${directory.path}/$folderName');
    if (rootFolder.existsSync()) {
      rootFolder.deleteSync(recursive: true);
    }
  }
}

saveErrorLog(error) async {
  try {
    await LoggerService.logError(error.toString())
        .then((value) => printErrorLog(value.path));
  } catch (e) {
    logger.e('saveErrorLog Error', error: e, tag: 'LoggerService');
  }
}

printErrorLog(String path) async {
  logger.f('printErrorLog on : $path',
      error: await LoggerService.instance.readErrorLog(path),
      tag: 'LoggerService');
}
