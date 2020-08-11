import 'dart:io';

class Write {
    
  Future writeFile(List titleLinks) async {
    final file = File('../assets/output/netflix-search.html');
    // delete the file if it existed previously
    await file.writeAsString('', mode: FileMode.write);
    for (var obj in titleLinks) {
      var fullLink = '<a href="${obj['link']}" target="_blank">${obj['name']}</a><br>\n';
      await file.writeAsString(fullLink, mode: FileMode.append);
    }
  }

}