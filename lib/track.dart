// ignore_for_file: non_constant_identifier_names

import 'package:xml/xml.dart';

class Track {
  int TrackID;
  String Name;
  String Artist;
  String Composer;
  String Album;
  String Grouping;
  String Genre;
  String Kind;
  int Size;
  int TotalTime;
  int DiscNumber;
  int TrackNumber;
  int Year;
  String AverageBpm;
  String DateAdded;
  int BitRate;
  int SampleRate;
  String Comments;
  int PlayCount;
  String Rating;
  String Location;
  String Remixer;
  String Tonality;
  String Label;
  String Mix;

  Track({
    required this.TrackID,
    required this.Name,
    required this.Artist,
    required this.Composer,
    required this.Album,
    required this.Grouping,
    required this.Genre,
    required this.Kind,
    required this.Size,
    required this.TotalTime,
    required this.DiscNumber,
    required this.TrackNumber,
    required this.Year,
    required this.AverageBpm,
    required this.DateAdded,
    required this.BitRate,
    required this.SampleRate,
    required this.Comments,
    required this.PlayCount,
    required this.Rating,
    required this.Location,
    required this.Remixer,
    required this.Tonality,
    required this.Label,
    required this.Mix,
  });

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      TrackID: map['TrackID'],
      Name: map['Name'],
      Artist: map['Artist'],
      Composer: map['Composer'],
      Album: map['Album'],
      Grouping: map['Grouping'],
      Genre: map['Genre'],
      Kind: map['Kind'],
      Size: map['Size'],
      TotalTime: map['TotalTime'],
      DiscNumber: map['DiscNumber'],
      TrackNumber: map['TrackNumber'],
      Year: map['Year'],
      AverageBpm: map['AverageBpm'],
      DateAdded: map['DateAdded'],
      BitRate: map['BitRate'],
      SampleRate: map['SampleRate'],
      Comments: map['Comments'],
      PlayCount: map['PlayCount'],
      Rating: map['Rating'],
      Location: map['Location'],
      Remixer: map['Remixer'],
      Tonality: map['Tonality'],
      Label: map['Label'],
      Mix: map['Mix'],
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'TrackID': TrackID,
      'Name': Name,
      'Artist': Artist,
      'Composer': Composer,
      'Album': Album,
      'Grouping': Grouping,
      'Genre': Genre,
      'Kind': Kind,
      'Size': Size,
      'TotalTime': TotalTime,
      'DiscNumber': DiscNumber,
      'TrackNumber': TrackNumber,
      'Year': Year,
      'AverageBpm': AverageBpm,
      'DateAdded': DateAdded,
      'BitRate': BitRate,
      'SampleRate': SampleRate,
      'Comments': Comments,
      'PlayCount': PlayCount,
      'Rating': Rating,
      'Location': Location,
      'Remixer': Remixer,
      'Tonality': Tonality,
      'Label': Label,
      'Mix': Mix,
    };
  }

  factory Track.fromXmlNode(XmlNode xmlTrack) {
    return Track(
      TrackID: int.parse(xmlTrack.getAttribute('TrackID')!),
      Name: xmlTrack.getAttribute('Name')!,
      Artist: xmlTrack.getAttribute('Artist')!,
      Composer: xmlTrack.getAttribute('Composer')!,
      Album: xmlTrack.getAttribute('Album')!,
      Grouping: xmlTrack.getAttribute('Grouping')!,
      Genre: xmlTrack.getAttribute('Genre')!,
      Kind: xmlTrack.getAttribute('Kind')!,
      Size: int.parse(xmlTrack.getAttribute('Size')!),
      TotalTime: int.parse(xmlTrack.getAttribute('TotalTime')!),
      DiscNumber: int.parse(xmlTrack.getAttribute('DiscNumber')!),
      TrackNumber: int.parse(xmlTrack.getAttribute('TrackNumber')!),
      Year: int.parse(xmlTrack.getAttribute('Year')!),
      AverageBpm: xmlTrack.getAttribute('AverageBpm')!,
      DateAdded: xmlTrack.getAttribute('DateAdded')!,
      BitRate: int.parse(xmlTrack.getAttribute('BitRate')!),
      SampleRate: int.parse(xmlTrack.getAttribute('SampleRate')!),
      Comments: xmlTrack.getAttribute('Comments')!,
      PlayCount: int.parse(xmlTrack.getAttribute('PlayCount')!),
      Rating: xmlTrack.getAttribute('Rating')!,
      Location: xmlTrack.getAttribute('Location')!,
      Remixer: xmlTrack.getAttribute('Remixer')!,
      Tonality: xmlTrack.getAttribute('Tonality')!,
      Label: xmlTrack.getAttribute('Label')!,
      Mix: xmlTrack.getAttribute('Mix')!,
    );
  }

  Map<String, String> toXmlMap() {
    return {
      'TrackID': TrackID.toString(),
      'Name': Name,
      'Artist': Artist,
      'Composer': Composer,
      'Album': Album,
      'Grouping': Grouping,
      'Genre': Genre,
      'Kind': Kind,
      'Size': Size.toString(),
      'TotalTime': TotalTime.toString(),
      'DiscNumber': DiscNumber.toString(),
      'TrackNumber': TrackNumber.toString(),
      'Year': Year.toString(),
      'AverageBpm': AverageBpm,
      'DateAdded': DateAdded,
      'BitRate': BitRate.toString(),
      'SampleRate': SampleRate.toString(),
      'Comments': Comments,
      'PlayCount': PlayCount.toString(),
      'Rating': Rating,
      'Location': Location,
      'Remixer': Remixer,
      'Tonality': Tonality,
      'Label': Label,
      'Mix': Mix,
    };
  }
}
