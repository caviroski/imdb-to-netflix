import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

ArgResults argResults;
bool isFirstLine = true;
int titlePosition = 0;
List titleLinks = [];
class Title {
  String name;
  String link;

  Title(this.name, this.link);

  @override
  String toString() {
    return '{ ${this.name}, ${this.link} }';
  }
}

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
            getTitle(line);
          }
        }
        writeFile();
      } catch (_) {
        await _handleError(path);
      }
    }
  }
}

Future writeFile() async {
  final file = File('output/netflix-search.html');
  await file.writeAsString('', mode: FileMode.write);
  for (var obj in titleLinks) {
    var fullLink = '<a href="https://www.netflix.com/search?q=${obj.link}" target="_blank">${obj.name}</a><br>';
    await file.writeAsString(fullLink, mode: FileMode.append);
  }
}

getTitlePosition(String line) {
  var titleElements = line.split(',');
  titlePosition = titleElements.indexOf('Title');
}

getTitle(String line) {
  var lineElements = line.split(',');
  var title = lineElements.elementAt(titlePosition);
  if (title[0] == '"') {
    getTitleConatainingComa(line, title);
  } else {
    creteLink(title);
  }
}

getTitleConatainingComa(String line, String title) {
  var startIndex = line.indexOf(title);
  var inBetweenTitle = line.substring(startIndex);
  inBetweenTitle = inBetweenTitle.replaceFirst('"', '');
  var endIndex = inBetweenTitle.indexOf('"');
  var newTitle = inBetweenTitle.substring(0, endIndex);
  creteLink(newTitle);
}

creteLink(String title) {
  var uri = Uri.encodeQueryComponent(title);
  titleLinks.add(new Title(title, 'https://www.netflix.com/search?q=$uri'));
}

Future _handleError(String path) async {
  if (await FileSystemEntity.isDirectory(path)) {
    stderr.writeln('error: $path is a directory');
  } else {
    exitCode = 2;
  }
}