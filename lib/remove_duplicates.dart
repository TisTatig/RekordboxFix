import 'package:xml/xml.dart';
import 'dart:io';

List<String> findDuplicates(File file) {
  final document = XmlDocument.parse(file.readAsStringSync());
  final trackList = document.findAllElements('TRACK');
  List<String> duplicateList = [];

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
      // IN PROGRESS: Populating the list of duplicates
      duplicateList.add("$testName - $testArtist");
    }
  });

  return duplicateList;
}
