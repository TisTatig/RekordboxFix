import 'dart:ffi';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
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
                  onPressed: () async {
                    initDb();
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
    Directory databaseDirectory = await getTemporaryDirectory();
    String databaseDirectoryPath = databaseDirectory.path;

    final database = openDatabase(
      join(databaseDirectoryPath, 'track_database.db'),
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

    final db = await database;

    // Function for inserting tracks into database
    Future<void> tracksToDatabase() async {
      // Finding the track data
      List<XmlNode> collectionTracks = collectionXML
          .findAllElements("COLLECTION")
          .first
          .findElements("TRACK")
          .toList();

      await db.transaction((txn) async {
        final batch = txn.batch();
        for (XmlNode xmlTrack in collectionTracks) {
          // Finding and parsing trackdata
          var track = Track(
              id: int.parse(xmlTrack.getAttribute('TrackID')!),
              name: xmlTrack.getAttribute('Name')!,
              artist: xmlTrack.getAttribute('Artist')!,
              composer: xmlTrack.getAttribute('Composer')!,
              album: xmlTrack.getAttribute('Album')!,
              grouping: xmlTrack.getAttribute('Grouping')!,
              genre: xmlTrack.getAttribute('Genre')!,
              kind: xmlTrack.getAttribute('Kind')!,
              size: int.parse(xmlTrack.getAttribute('Size')!),
              totaltime: int.parse(xmlTrack.getAttribute('TotalTime')!),
              discnumber: int.parse(xmlTrack.getAttribute('DiscNumber')!),
              tracknumber: int.parse(xmlTrack.getAttribute('TrackNumber')!),
              year: int.parse(xmlTrack.getAttribute('Year')!),
              averagebpm: xmlTrack.getAttribute('AverageBpm')!,
              dateadded: xmlTrack.getAttribute('DateAdded')!,
              bitrate: int.parse(xmlTrack.getAttribute('BitRate')!),
              samplerate: int.parse(xmlTrack.getAttribute('SampleRate')!),
              comments: xmlTrack.getAttribute('Comments')!,
              playcount: int.parse(xmlTrack.getAttribute('PlayCount')!),
              rating: xmlTrack.getAttribute('Rating')!,
              location: xmlTrack.getAttribute('Location')!,
              remixer: xmlTrack.getAttribute('Remixer')!,
              tonality: xmlTrack.getAttribute('Tonality')!,
              label: xmlTrack.getAttribute('Label')!,
              mix: xmlTrack.getAttribute('Mix')!);

          // Adding track data to batch
          batch.insert('tracks', track.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);

          // Finding and parsing the Tempo data
          var tracktempo = xmlTrack.getElement("TEMPO");

          var tempo = Tempo(
              trackid: track.id,
              battito: tracktempo?.getAttribute("Battito") ?? "",
              inizio: tracktempo?.getAttribute("Inizio") ?? "",
              bpm: tracktempo?.getAttribute("Bpm") ?? "",
              metro: tracktempo?.getAttribute("Metro") ?? "");

          // Adding tempo data to the batch
          batch.insert('tempos', tempo.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);

          // Finding and parsing the hotcue data
          var xmlHotCueList = xmlTrack.findElements("POSITION_MARK");
          for (XmlElement xmlHotCue in xmlHotCueList) {
            var hotcue = Hotcue(
                trackid: track.id,
                name: xmlHotCue.getAttribute("Name") ?? "",
                type: xmlHotCue.getAttribute("Type") ?? "",
                start: xmlHotCue.getAttribute("Start") ?? "",
                number: xmlHotCue.getAttribute("Num") ?? "",
                red: xmlHotCue.getAttribute("Red") ?? "",
                green: xmlHotCue.getAttribute("Green") ?? "",
                blue: xmlHotCue.getAttribute("Blue") ?? "");

            // Adding hotcue data to database
            batch.insert('hotcues', hotcue.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          }
          print(
              "Track ${collectionTracks.indexOf(xmlTrack)} added to the batch");
        }

        // Committing batch to database
        await batch.commit();
        print("Track batch committed to database");
      });
    }

    // Function for inserting playlists into database
    Future<void> playlistsToDatabase() async {
      // Finding the playlists
      List<XmlNode> playlistList = collectionXML
          .findAllElements("PLAYLISTS")
          .first
          .findAllElements("Node")
          .where((element) => element.getAttribute("Type") == "2")
          .toList();

      await db.transaction((txn) async {
        final batch = txn.batch();

        // Parsing the playlists
        for (XmlNode xmlPlaylist in playlistList) {
          var playlist = Playlist(
              name: xmlPlaylist.getAttribute("Name") as String,
              type: xmlPlaylist.getAttribute("Type") as String,
              keytype: xmlPlaylist.getAttribute("Keytype") as String,
              entries: xmlPlaylist.getAttribute("Entries") as String);

          // Inserting playlists into the batch
          batch.insert('playlists', playlist.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);

          // Finding and parsing the playlisttracks
          xmlPlaylist.findAllElements("Track").forEach((element) {
            var playlistTrack = PlaylistTrack(
                playlistname: playlist.name,
                trackid: int.parse(element.getAttribute("Key")!));

            // Inserting playlisttracks into the batch
            batch.insert('playlisttracks', playlistTrack.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          });
          print(
              "Playlist ${playlistList.indexOf(xmlPlaylist)} added to the batch");
        }

        // Committing the playlist batches to database
        batch.commit();
      });
    }

    Future<List> findDuplicateIds() async {
      List<Map<String, Object?>> duplicateIds = await db.query('''
        (SELECT DISTINCT t1.id AS firstTrackId, t1.location AS firstTrackLocation, t1.bitrate AS firstTrackBitRate, t2.id AS secondTrackId, t2.location as secondTrackLocation, t2.bitrate AS secondTrackBitRate
        FROM tracks AS t1
        JOIN tracks AS t2
        ON t1.name LIKE t2.name
        WHERE t1.id < t2.id
        AND t1.artist LIKE t2.artist
        AND t1.location != t2.location);
        ''');
      return duplicateIds;
    }

    Future<void> mergeDuplicates(List duplicateIdsList) async {
      for (Map duplicateMap in duplicateIdsList) {
        // TODO: Write bit that finds and merges duplicates using SQL
        
        
        int firstTrackBitRate = duplicateMap['firstTrackBitRate'];
        int secondTrackBitRate = duplicateMap['secondTrackBitRate'];

        int goodTrackId;
        int badTrackId;
        String badTrackLocation;

        // Comparing the bitrates to preserve the higher quality track
        if (firstTrackBitRate < secondTrackBitRate) {
          badTrackId = duplicateMap['firstTrackId'];
          badTrackLocation = duplicateMap['firstTrackLocation'];
          goodTrackId = duplicateMap['secondTrackId'];
        } else {
          badTrackId = duplicateMap['secondTrackId'];
          badTrackLocation = duplicateMap['secondTrackLocation'];
          goodTrackId = duplicateMap['firstTrackId'];
        }

        // Replacing bad track playlist entries with good tracks
        await db.transaction((txn) async {
          await txn.execute('''
          UPDATE playlisttracks
          SET trackid = $goodTrackId
          WHERE trackid = $badTrackId
          ''');
        });

        //TODO: Merging the hotcues
        
        
        // Deleting the remaining bad track entries in the database
        Batch batch = db.batch();
        batch.delete('tracks', where: 'id = ?', whereArgs: ['$badTrackId']);
        batch.delete('hotcues',
            where: 'trackid = ?', whereArgs: ['$badTrackId']);
        batch
            .delete('tempos', where: 'trackid = ?', whereArgs: ['$badTrackId']);
        batch.commit();

        // Deleting the corresponding badtrack file
        final File duplicateTrackFile = File(badTrackLocation);
        print("Track with id: $badTrackId deleted...");
        // duplicateTrackFile.deleteSync();
      }
    }

    await tracksToDatabase();
    await playlistsToDatabase();
    print("Database saved at ${db.path}");
    await mergeDuplicates(await findDuplicateIds());

    await db.close();
  }
}
