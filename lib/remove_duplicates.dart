import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'dart:io';

DataTable findDuplicates(File file) {
  final document = XmlDocument.parse(file.readAsStringSync());
  final trackList = document.findAllElements('TRACK');
  List<DataRow> duplicateList = [];

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
      // The idea is to use List<Datacolumn> duplicateInfo { return [DataRow(Cells:[ Datacell(Text:'$TrackID'), etc, etc, etc]}
      // then those lists will be put into a DataTable through:
      //  when duplicate is found: duplicateInfo.add.duplicateInfo()

      // When the list is filled create DataTable with:
      // DataTable duplicateTable() { return DataTable(columns: Properties(), rows: duplicateList)}
      // and then return that DataTable
      
      duplicateList.addAll("$matchID" : "$testName - $testArtist");
    }
  });

  return duplicateList;
}
