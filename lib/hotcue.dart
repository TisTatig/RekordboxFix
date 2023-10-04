// ignore_for_file: non_constant_identifier_names

import 'package:xml/xml.dart';

class Hotcue {
  int TrackID;
  String Name;
  String Type;
  String Start;
  String Num;
  String Red;
  String Green;
  String Blue;

  Hotcue({
    required this.TrackID,
    required this.Name,
    required this.Type,
    required this.Start,
    required this.Num,
    required this.Red,
    required this.Green,
    required this.Blue,
  });

  factory Hotcue.fromMap(Map<String, dynamic> map) {
    return Hotcue(
      TrackID: map['TrackID'],
      Name: map['Name'],
      Type: map['Type'],
      Start: map['Start'],
      Num: map['Num'],
      Red: map['Red'],
      Green: map['Green'],
      Blue: map['Blue'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TrackID': TrackID,
      'Name': Name,
      'Type': Type,
      'Start': Start,
      'Num': Num,
      'Red': Red,
      'Green': Green,
      'Blue': Blue,
    };
  }

  factory Hotcue.fromXmlElement(int TrackID, XmlElement xmlHotcue) {
    return Hotcue(
      TrackID: TrackID,
      Name: xmlHotcue.getAttribute("Name") ?? "",
      Type: xmlHotcue.getAttribute("Type") ?? "",
      Start: xmlHotcue.getAttribute("Start") ?? "",
      Num: xmlHotcue.getAttribute("Num") ?? "",
      Red: xmlHotcue.getAttribute("Red") ?? "",
      Green: xmlHotcue.getAttribute("Green") ?? "",
      Blue: xmlHotcue.getAttribute("Blue") ?? "",
    );
  }

  Map<String, String> toXmlMap() {
    return {
      'Name': Name,
      'Type': Type,
      'Start': Start,
      'Num': Num,
      'Red': Red,
      'Green': Green,
      'Blue': Blue,
    };
  }

  Map<String, String> memoryCueToXmlMap() {
    return {
      'Name': Name,
      'Type': Type,
      'Start': Start,
      'Num': Num,
    };
  }
}
