class Process {

  int titlePosition = 0;
  List titleLinks = <Map>[];

  getTitlePosition(String line) {
    var titleElements = line.split(',');
    titlePosition = titleElements.indexOf('Title');
  }

  getTitle(String line) {
    var lineElements = line.split(new RegExp(r',(?=(?:[^\"]*\"[^\"]*\")*[^\"]*$)'));
    var title = lineElements.elementAt(titlePosition);
    creteLink(title);
  }

  creteLink(String title) {
    var uri = Uri.encodeQueryComponent(title);
    var titleMap = new Map();
    titleMap['name'] = title;
    titleMap['link'] = 'https://www.netflix.com/search?q=$uri';
    titleLinks.add(titleMap);
  }

}