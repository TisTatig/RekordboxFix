import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'dart:io';

DataTable findDuplicates(File file) {
  final document = XmlDocument.parse(file.readAsStringSync());
  final trackList = document.findAllElements('TRACK');
  // Creating empty list to house the info of the duplicates in DataRow form for the DataTable
  List<DataRow> duplicateList = [];

  // Creating the column labels of the DataTable
  List<DataColumn> propertyList = [
    const DataColumn(label: Text('ID')),
    const DataColumn(label: Text('Name')),
    const DataColumn(label: Text('Artist'))
  ];

  //Finding the matches
  trackList.forEach(
    (element) {
      var testName = element.getAttribute('Name');
      var testID = element.getAttribute('TrackID');
      var testArtist = element.getAttribute('Artist');
      var testSize = element.getAttribute('Size');
      var match = trackList
          .lastWhere((element) => element.getAttribute('Name') == testName);
      var matchID = match.getAttribute('TrackID');
      var matchArtist = element.getAttribute('Artist');
      var matchSize = element.getAttribute('Size');

      // If match is found a new DataRow item is created and appended to the duplicateList
      if (matchArtist == testArtist &&
          matchSize == testSize &&
          !(testID == matchID)) {
        //Creating the DataRow packages of the found duplicate's info to be used in building the DataTable
        List<DataRow> duplicateInfo() {
          return [
            DataRow(
              cells: [
                DataCell(Text('$matchID')),
                DataCell(Text('$testName')),
                DataCell(Text('$matchArtist')),
              ],
            )
          ];
        }

        duplicateList.add(duplicateInfo().first);
      }
    },
  );

  return DataTable(
    columns: propertyList,
    rows: duplicateList,
  );
}
