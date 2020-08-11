class Process {

  int titlePosition = 0;
  List titleLinks = <Map>[];

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
    var titleMap = new Map();
    titleMap['name'] = title;
    titleMap['link'] = 'https://www.netflix.com/search?q=$uri';
    titleLinks.add(titleMap);
  }

}