// ignore_for_file: non_constant_identifier_names

import 'package:rekordboxfix_app/playlist.dart';
import 'package:xml/xml.dart';

class PlaylistTrack {
  String PlaylistName;
  int Key;

  PlaylistTrack({
    required this.PlaylistName,
    required this.Key,
  });

  factory PlaylistTrack.fromMap(Map<String, dynamic> map) {
    return PlaylistTrack(
      PlaylistName: map['PlaylistName'],
      Key: map['Key'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'PlaylistName': PlaylistName,
      'Key': Key,
    };
  }

  factory PlaylistTrack.fromXmlElement(
      Playlist playlist, XmlElement xmlPlaylistTrack) {
    return PlaylistTrack(
        PlaylistName: playlist.Name,
        Key: int.parse(xmlPlaylistTrack.getAttribute("Key")!));
  }

  Map<String, String> toXmlMap() {
    return {
      'Key': Key.toString(),
    };
  }
}
