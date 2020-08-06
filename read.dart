import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

ArgResults argResults;
bool isFirstLine = true;
int titlePosition = 0;

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser();

  argResults = parser.parse(arguments);
  final paths = argResults.rest;

  readFile(paths);
}

Future readFile(List<String> paths) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    await stdin.pipe(stdout);
  } else {
    for (var path in paths) {
      final lines = utf8.decoder
          .bind(File(path).openRead())
          .transform(const LineSplitter());
      // print('lines = ${await lines.length}');
      try {
        await for (var line in lines) {
          if (isFirstLine) {
            getTitlePosition(line);
            isFirstLine = false;
          } else {
            // bbb(line);
          }
          // stdout.writeln(line);
        }
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

getTitlePosition(String line) {
  var titleElements = line.split(',');
  titlePosition = titleElements.indexOf('Title');
}

bbb(String line) {
  print('line bbb = $line');
}

Future _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}