// ignore_for_file: non_constant_identifier_names

import 'package:xml/xml.dart';

class Playlist {
  String Name;
  String Type;
  String KeyType;
  String Entries;
  String FolderName;

  Playlist({
    required this.Name,
    required this.Type,
    required this.KeyType,
    required this.Entries,
    required this.FolderName,
  });

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
        Name: map['Name'],
        Type: map['Type'],
        KeyType: map['KeyType'],
        Entries: map['Entries'],
        FolderName: map['FolderName']);
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': Name,
      'Type': Type,
      'KeyType': KeyType,
      'Entries': Entries,
      'FolderName': FolderName
    };
  }

  factory Playlist.fromXmlElement(XmlElement xmlPlaylist) {
    return Playlist(
        Name: xmlPlaylist.getAttribute("Name") as String,
        Type: xmlPlaylist.getAttribute("Type") as String,
        KeyType: xmlPlaylist.getAttribute("KeyType") as String,
        Entries: xmlPlaylist.getAttribute("Entries") as String,
        FolderName: xmlPlaylist.parent!.getAttribute("Name")!);
  }

  Map<String, String> toXmlMap() {
    return {
      'Name': Name,
      'Type': Type,
      'KeyType': KeyType,
      'Entries': Entries,
    };
  }
}
