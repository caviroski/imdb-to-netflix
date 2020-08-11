import 'dart:convert';
import 'dart:io';

import 'package:imdb_to_netflix/write.dart';
import 'package:imdb_to_netflix/process.dart';

class Read {

  bool isFirstLine = true;
  Write write = new Write();
  Process process = new Process();

  Future readFile(List<String> paths) async {
    if (paths.isEmpty) {
      stderr.writeln('error: please provide file');
    } else {
      for (var path in paths) {
        final lines = utf8.decoder
            .bind(File(path).openRead())
            .transform(const LineSplitter());
        try {
          await for (var line in lines) {
            if (isFirstLine) {
              process.getTitlePosition(line);
              isFirstLine = false;
            } else {
              process.getTitle(line);
            }
          }
          write.writeFile(process.titleLinks);
          stderr.writeln('success: the html file is created');
        } catch (_) {
          await _handleError(path);
        }
      }
    }
  }

  Future _handleError(String path) async {
    if (await FileSystemEntity.isDirectory(path)) {
      stderr.writeln('error: $path is a directory');
    } else {
      exitCode = 2;
    }
  }

}
