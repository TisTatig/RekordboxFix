// ignore_for_file: non_constant_identifier_names

import 'package:xml/xml.dart';

class PlaylistFolder {
  String Name;
  String Type;
  String Count;
  String ParentName;

  PlaylistFolder({
    required this.Name,
    required this.Type,
    required this.Count,
    required this.ParentName,
  });

  factory PlaylistFolder.fromMap(Map<String, dynamic> map) {
    return PlaylistFolder(
        Name: map['Name'],
        Type: map['Type'],
        Count: map['Count'],
        ParentName: map['ParentName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': Name,
      'Type': Type,
      'Count': Count,
      'ParentName': ParentName,
    };
  }

  factory PlaylistFolder.fromXmlElement(XmlElement xmlPlaylistFolder) {
    return PlaylistFolder(
        Name: xmlPlaylistFolder.getAttribute("Name") as String,
        Type: xmlPlaylistFolder.getAttribute("Type") as String,
        Count: xmlPlaylistFolder.getAttribute("Count") as String,
        ParentName: xmlPlaylistFolder.parent?.getAttribute('Name') ?? "");
  }

  Map<String, String> toXmlMap() {
    return {
      'Name': Name,
      'Type': Type,
      'Count': Count,
    };
  }
}
