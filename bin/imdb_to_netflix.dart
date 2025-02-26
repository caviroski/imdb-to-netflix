import 'dart:io';

import 'package:args/args.dart';
import 'package:imdb_to_netflix/read.dart';

ArgResults argResults;

void main(List<String> arguments) {

  exitCode = 0; // presume success yes
  final parser = ArgParser();

  argResults = parser.parse(arguments);
  final paths = argResults.rest;

  var read = new Read(); 
  read.readFile(paths);
  
}