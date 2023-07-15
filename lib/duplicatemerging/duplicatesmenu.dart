import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// Creating new object classes for use in the database
class Track {
  final int id;
  final String name;
  final String artist;
  final String composer;
  final String album;
  final String grouping;
  final String genre;
  final String kind;
  final int size;
  final int totaltime;
  final int discnumber;
  final int tracknumber;
  final int year;
  final String averagebpm;
  final String dateadded;
  final int bitrate;
  final int samplerate;
  final String comments;
  final int playcount;
  final String rating;
  final String location;
  final String remixer;
  final String tonality;
  final String label;
  final String mix;

  const Track({
    required this.id,
    required this.name,
    required this.artist,
    required this.composer,
    required this.album,
    required this.grouping,
    required this.genre,
    required this.kind,
    required this.size,
    required this.totaltime,
    required this.discnumber,
    required this.tracknumber,
    required this.year,
    required this.averagebpm,
    required this.dateadded,
    required this.bitrate,
    required this.samplerate,
    required this.comments,
    required this.playcount,
    required this.rating,
    required this.location,
    required this.remixer,
    required this.tonality,
    required this.label,
    required this.mix,
  });
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'artist': artist,
      'composer': composer,
      'album': album,
      'grouping': grouping,
      'genre': genre,
      'kind': kind,
      'size': size,
      'totaltime': totaltime,
      'discnumber': discnumber,
      'tracknumber': tracknumber,
      'year': year,
      'averagebpm': averagebpm,
      'dateadded': dateadded,
      'bitrate': bitrate,
      'samplerate': samplerate,
      'comments': comments,
      'playcount': playcount,
      'rating': rating,
      'location': location,
      'remixer': remixer,
      'tonality': tonality,
      'label': label,
      'mix': mix,
    };
  }
}

class Hotcue {
  final int trackid;
  final String name;
  final String type;
  final String start;
  final String number;
  final String red;
  final String green;
  final String blue;

  const Hotcue({
    required this.trackid,
    required this.name,
    required this.type,
    required this.start,
    required this.number,
    required this.red,
    required this.green,
    required this.blue,
  });

  Map<String, dynamic> toMap() {
    return {
      'trackid': trackid,
      'name': name,
      'type': type,
      'start': start,
      'number': number,
      'red': red,
      'green': green,
      'blue': blue
    };
  }
}

class Tempo {
  final int trackid;
  final String inizio;
  final String bpm;
  final String metro;
  final String battito;

  const Tempo(
      {required this.trackid,
      required this.inizio,
      required this.bpm,
      required this.metro,
      required this.battito});

  Map<String, dynamic> toMap() {
    return {
      'trackid': trackid,
      'inizio': inizio,
      'bpm': bpm,
      'metro': metro,
      'battito': battito
    };
  }
}

class Playlist {
  final String name;
  final String type;
  final String keytype;
  final String entries;

  const Playlist(
      {required this.name,
      required this.type,
      required this.keytype,
      required this.entries});

  Map<String, dynamic> toMap() {
    return {'name': name, 'type': type, 'keytype': keytype, 'entries': entries};
  }
}

class PlaylistTrack {
  final String playlistname;
  final int trackid;

  const PlaylistTrack({required this.playlistname, required this.trackid});

  Map<String, dynamic> toMap() {
    return {'playlistname': playlistname, 'trackid': trackid};
  }
}

class DuplicatesMenu extends StatefulWidget {
  const DuplicatesMenu({
    super.key,
    required this.file,
    required this.goBack,
  });

  final File file;
  final void Function(File?) goBack;

  @override
  State<DuplicatesMenu> createState() => _DuplicatesMenuState();
}

class _DuplicatesMenuState extends State<DuplicatesMenu> {
  late XmlDocument collectionXML =
      XmlDocument.parse(widget.file.readAsStringSync());

  int duplicateRemovalCount = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title: const Center(child: Text('Placeholder duplicates found'))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    initDb();
                    popDb();
                  },
                  child: const Text('Merge Duplicates')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    widget.goBack(null);
                  },
                  child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }

// Creating database of tracks
  void initDb() async {
    final database = openDatabase(
      join(await getDatabasesPath(), 'track_database.db'),
      onCreate: (db, version) {
        return db.execute('''CREATE TABLE tracks(
            id INTEGER PRIMARY KEY, 
            name TEXT, 
            artist TEXT, 
            composer TEXT, 
            album TEXT, 
            grouping TEXT, 
            genre TEXT, 
            kind TEXT, 
            size INTEGER, 
            totaltime INTEGER, 
            discnumber INTEGER, 
            tracknumber INTEGER, 
            year INTEGER, 
            averagebpm TEXT, 
            dateadded TEXT, 
            bitrate INTEGER, 
            samplerate INTEGER, 
            comments TEXT, 
            playcount INTEGER, 
            rating TEXT, 
            location TEXT, 
            remixer TEXT, 
            tonality TEXT, 
            label TEXT, 
            mix TEXT
            );
            
          CREATE TABLE hotcues(
            trackid INTEGER,
            name TEXT,
            type TEXT,
            start TEXT,
            number TEXT,
            red TEXT,
            green TEXT,
            blue TEXT,
            FOREIGN KEY(trackid) REFERENCES tracks(id)
          );

          CREATE TABLE tempos(
            trackid INTEGER,
            inizio TEXT,
            bpm TEXT,
            metro TEXT,
            battito TEXT,
            FOREIGN KEY(trackid) REFERENCES tracks(id)
          );

          CREATE TABLE playlists(
            name TEXT PRIMARY KEY,
            type TEXT,
            keytype TEXT,
            entries TEXT
          );

          CREATE TABLE playlisttracks(
            playlistname TEXT,
            trackid INTEGER,
            FOREIGN KEY(playlistname) REFERENCES playlist(name),
            FOREIGN KEY(trackid) REFERENCES tracks(id)
          );
            ''');
      },
      version: 1,
    );
  }

  void popDb() async {
    final database =
        openDatabase(join(await getDatabasesPath(), 'track_database.db'));

    // Function for inserting tracks into database
    Future<void> insertTrack(Track track, Tempo tempo) async {
      final db = await database;
      await db.insert('tracks', track.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
      await db.insert('tempos', tempo.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<void> insertHotCue(Hotcue hotcue) async {
      final db = await database;
      await db.insert('hotcues', hotcue.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<void> insertPlaylist(Playlist playlist) async {
      final db = await database;
      await db.insert('playlists', playlist.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    Future<void> insertPlaylistTrack(PlaylistTrack playlisttrack) async {
      final db = await database;
      await db.insert('playlisttracks', playlisttrack.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    }

    List<XmlNode> collectionTracks = collectionXML
        .findAllElements("COLLECTION")
        .first
        .findElements("TRACK")
        .toList();

    for (XmlNode track in collectionTracks) {
      var newtrack = Track(
          id: int.parse(track.getAttribute('TrackID')!),
          name: track.getAttribute('Name')!,
          artist: track.getAttribute('Artist')!,
          composer: track.getAttribute('Composer')!,
          album: track.getAttribute('Album')!,
          grouping: track.getAttribute('Grouping')!,
          genre: track.getAttribute('Genre')!,
          kind: track.getAttribute('Kind')!,
          size: int.parse(track.getAttribute('Size')!),
          totaltime: int.parse(track.getAttribute('TotalTime')!),
          discnumber: int.parse(track.getAttribute('DiscNumber')!),
          tracknumber: int.parse(track.getAttribute('TrackNumber')!),
          year: int.parse(track.getAttribute('Year')!),
          averagebpm: track.getAttribute('AverageBpm')!,
          dateadded: track.getAttribute('DateAdded')!,
          bitrate: int.parse(track.getAttribute('BitRate')!),
          samplerate: int.parse(track.getAttribute('SampleRate')!),
          comments: track.getAttribute('Comments')!,
          playcount: int.parse(track.getAttribute('PlayCount')!),
          rating: track.getAttribute('Rating')!,
          location: track.getAttribute('Location')!,
          remixer: track.getAttribute('Remixer')!,
          tonality: track.getAttribute('Tonality')!,
          label: track.getAttribute('TrackID')!,
          mix: track.getAttribute('TrackID')!);

      // Parsing the Tempo data
      var tracktempo = track.getElement("TEMPO")!;
      var newtempo = Tempo(
          trackid: newtrack.id,
          battito: tracktempo.getAttribute("Battito") as String,
          inizio: tracktempo.getAttribute("Inizio") as String,
          bpm: tracktempo.getAttribute("Bpm") as String,
          metro: tracktempo.getAttribute("Metro") as String);

      // Adding track and tempo data to database
      insertTrack(newtrack, newtempo);

      var trackhotcues = track.findElements("POSITION_MARK");
      for (XmlElement hotcue in trackhotcues) {
        var newHotCue = Hotcue(
            trackid: newtrack.id,
            name: hotcue.getAttribute("Name") as String,
            type: hotcue.getAttribute("Type") as String,
            start: hotcue.getAttribute("Start") as String,
            number: hotcue.getAttribute("Num") as String,
            red: hotcue.getAttribute("Red") as String,
            green: hotcue.getAttribute("Green") as String,
            blue: hotcue.getAttribute("Blue") as String);

        // Adding hotcue data to database
        insertHotCue(newHotCue);
      }

      List<XmlNode> playlistList = collectionXML
          .findAllElements("PLAYLISTS")
          .first
          .findAllElements("Node")
          .where((element) => element.getAttribute("Type") == "2")
          .toList();

      for (XmlNode playlist in playlistList) {
        var newPlayList = Playlist(
            name: playlist.getAttribute("Name") as String,
            type: playlist.getAttribute("Type") as String,
            keytype: playlist.getAttribute("Keytype") as String,
            entries: playlist.getAttribute("Entries") as String);
        insertPlaylist(newPlayList);

        playlist.findAllElements("Track").forEach((element) {
          var newPlaylistTrack = PlaylistTrack(
              playlistname: newPlayList.name,
              trackid: int.parse(element.getAttribute("Key")!));
          insertPlaylistTrack(newPlaylistTrack);
        });
      }
    }
  }

  // TODO: Write bit that finds and merges duplicates
}
