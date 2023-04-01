import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'dart:io';

List<CheckboxListTile> findDuplicates(File file) {
  final document = XmlDocument.parse(file.readAsStringSync());
  final trackList = document.findAllElements('TRACK');
  // Creating empty list to house the info of the duplicates in DataRow form for the DataTable
  List<CheckboxListTile> duplicateList = [];

  //Finding the matches
  for (int i = 0; i <= 100; i++) {
    // TODO: the for loop is still limited here in order to make debugging faster
    var element = trackList.elementAt(i);

    var testName = element.getAttribute('Name');
    var testID = element.getAttribute('TrackID');
    var testArtist = element.getAttribute('Artist');
    var testSize = element.getAttribute('Size');
    var match = trackList
        .lastWhere((element) => element.getAttribute('Name') == testName);
    var matchID = match.getAttribute('TrackID');
    var matchArtist = element.getAttribute('Artist');
    var matchSize = element.getAttribute('Size');

    // If match is found a new ListTile item is created and appended to the duplicateList
    // TODO: Implement binary search algorithm
    if (matchArtist == testArtist &&
        matchSize == testSize &&
        !(testID == matchID)) {
      //
      // TODO: Making the onChanged cause the track ID and match ID to be appended to a removal table
      // TODO: Store the trackID somewhere else and add playlist information of both duplicates

      CheckboxListTile duplicateInfo() {
        bool checkboxValue = false;
        return CheckboxListTile(
            title: Text("$matchID - $testName - $matchArtist"),
            value: checkboxValue,
            onChanged: (bool value) => {
                  setState(() {
                    checkboxValue = value;
                  })
                },
            activeColor: Colors.green);
      }

      // Appending the listtiles to the duplicateList
      duplicateList.add(duplicateInfo());
    }
  }
  return duplicateList;
}
