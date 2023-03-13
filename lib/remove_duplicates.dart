import 'package:xml/xml.dart';
import 'dart:io';

int findDuplicates(File file) {
  final document = XmlDocument.parse(file.readAsStringSync());
  final trackList = document.findAllElements('TRACK');

  trackList.forEach((element) {
    var testName = element.getAttribute('Name');
    var testID = element.getAttribute('TrackID');
    var testArtist = element.getAttribute('Artist');
    var testSize = element.getAttribute('Size');
    var match = trackList
        .lastWhere((element) => element.getAttribute('Name') == testName);
    var matchID = match.getAttribute('TrackID');
    var matchArtist = element.getAttribute('Artist');
    var matchSize = element.getAttribute('Size');

    if (matchArtist == testArtist &&
        matchSize == testSize &&
        !(testID == matchID)) {
      print(
          'Duplicate found for $testName:\nID One = $testID\nID Two = $matchID\n');
    }
  });

  return 0;
}
