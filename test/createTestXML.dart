// ignore_for_file: file_names

import 'dart:core';
import 'package:xml/xml.dart';
import 'dart:io';
import 'package:args/args.dart';

const lineNumber = 'line-number';
String scriptPath = Platform.script.toFilePath();
String scriptDirectory = File(scriptPath).parent.path;

void main(List<String> arguments) {
  exitCode = 0;
  final parser = ArgParser()..addFlag(lineNumber, negatable: false, abbr: 'n');
  ArgResults argResults = parser.parse(arguments);
  final paths = argResults.rest;

  createXML(paths);
}

Future<void> createXML(List<String> paths) async {
  if (paths.isEmpty) {
    // No files provided as arguments. Read from stdin and print each line.
    print("Correct usage: dart run ./createTestXML.dart pathToCollectionXML");
  } else {
    int xmlCounter = 1;
    for (final path in paths) {
      File file = File(path);
      XmlDocument document = XmlDocument.parse(file.readAsStringSync());

      List<XmlElement> xmlTracks = document
          .findAllElements("COLLECTION")
          .first
          .findAllElements("TRACK")
          .toList();

      int trackCounter = 1;

      for (XmlElement track in xmlTracks) {
        String fakeTrackLocation =
            "$scriptDirectory/testTracks/Track$trackCounter";
        File fakeTrack = File(fakeTrackLocation);
        if (!(await fakeTrack.exists())) {
          fakeTrack.createSync();
        }
        track.setAttribute("Location", fakeTrackLocation);
        trackCounter++;
      }

      String newTextXMLLocation =
          "$scriptDirectory/testXMLs/testXML$xmlCounter.xml";
      File newTestXML = File(newTextXMLLocation);

      newTestXML.createSync();
      newTestXML.writeAsStringSync(document.toXmlString(pretty: true));
      print("TestXML $xmlCounter created and saved in testXMLs directory...");
      xmlCounter++;
    }
  }
}