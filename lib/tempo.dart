// ignore_for_file: non_constant_identifier_names

import 'package:xml/xml.dart';

class Tempo {
  int TrackID;
  String Inizio;
  String Bpm;
  String Metro;
  String Battito;

  Tempo({
    required this.TrackID,
    required this.Inizio,
    required this.Bpm,
    required this.Metro,
    required this.Battito,
  });

  factory Tempo.fromMap(Map<String, dynamic> map) {
    return Tempo(
      TrackID: map['TrackID'],
      Inizio: map['Inizio'],
      Bpm: map['Bpm'],
      Metro: map['Metro'],
      Battito: map['Battito'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'TrackID': TrackID,
      'Inizio': Inizio,
      'Bpm': Bpm,
      'Metro': Metro,
      'Battito': Battito,
    };
  }

  factory Tempo.fromXmlElement(int TrackID, XmlElement xmlTempo) {
    return Tempo(
        TrackID: TrackID,
        Battito: xmlTempo.getAttribute("Battito") ?? "",
        Inizio: xmlTempo.getAttribute("Inizio") ?? "",
        Bpm: xmlTempo.getAttribute("Bpm") ?? "",
        Metro: xmlTempo.getAttribute("Metro") ?? "");
  }

  Map<String, String> toXmlMap() {
    return {
      'Inizio': Inizio,
      'Bpm': Bpm,
      'Metro': Metro,
      'Battito': Battito,
    };
  }
}
