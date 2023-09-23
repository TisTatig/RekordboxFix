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
  int id;
  String name;
  String artist;
  String composer;
  String album;
  String grouping;
  String genre;
  String kind;
  int size;
  int totaltime;
  int discnumber;
  int tracknumber;
  int year;
  String averagebpm;
  String dateadded;
  int bitrate;
  int samplerate;
  String comments;
  int playcount;
  String rating;
  String location;
  String remixer;
  String tonality;
  String label;
  String mix;

  Track({
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

  factory Track.fromMap(Map<String, dynamic> map) {
    return Track(
      id: map['id'],
      name: map['name'],
      artist: map['artist'],
      composer: map['composer'],
      album: map['album'],
      grouping: map['grouping'],
      genre: map['genre'],
      kind: map['kind'],
      size: map['size'],
      totaltime: map['totaltime'],
      discnumber: map['discnumber'],
      tracknumber: map['tracknumber'],
      year: map['year'],
      averagebpm: map['averagebpm'],
      dateadded: map['dateadded'],
      bitrate: map['bitrate'],
      samplerate: map['samplerate'],
      comments: map['comments'],
      playcount: map['playcount'],
      rating: map['rating'],
      location: map['location'],
      remixer: map['remixer'],
      tonality: map['tonality'],
      label: map['label'],
      mix: map['mix'],
    );
  }
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
  int trackid;
  String name;
  String type;
  String start;
  String number;
  String red;
  String green;
  String blue;

  Hotcue({
    required this.trackid,
    required this.name,
    required this.type,
    required this.start,
    required this.number,
    required this.red,
    required this.green,
    required this.blue,
  });

  factory Hotcue.fromMap(Map<String, dynamic> map) {
    return Hotcue(
      trackid: map['trackid'],
      name: map['name'],
      type: map['type'],
      start: map['start'],
      number: map['number'],
      red: map['red'],
      green: map['green'],
      blue: map['blue'],
    );
  }

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
  int trackid;
  String inizio;
  String bpm;
  String metro;
  String battito;

  Tempo(
      {required this.trackid,
      required this.inizio,
      required this.bpm,
      required this.metro,
      required this.battito});

  factory Tempo.fromMap(Map<String, dynamic> map) {
    return Tempo(
      trackid: map['trackid'],
      inizio: map['inizio'],
      bpm: map['bpm'],
      metro: map['metro'],
      battito: map['battito'],
    );
  }

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
  String name;
  String type;
  String keytype;
  String entries;

  Playlist(
      {required this.name,
      required this.type,
      required this.keytype,
      required this.entries});

  factory Playlist.fromMap(Map<String, dynamic> map) {
    return Playlist(
      name: map['name'],
      type: map['type'],
      keytype: map['keytype'],
      entries: map['entries'],
    );
  }

  Map<String, dynamic> toMap() {
    return {'name': name, 'type': type, 'keytype': keytype, 'entries': entries};
  }
}

class PlaylistTrack {
  String playlistname;
  int trackid;

  PlaylistTrack({required this.playlistname, required this.trackid});

  factory PlaylistTrack.fromMap(Map<String, dynamic> map) {
    return PlaylistTrack(
        playlistname: map['playlistname'], trackid: map['trackid']);
  }

  Map<String, dynamic> toMap() {
    return {'playlistname': playlistname, 'trackid': trackid};
  }
}

class RGB {
  String red, green, blue;
  RGB(this.red, this.green, this.blue);
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
        Map<String, Object?> firstTrackMap = (await db.query('tracks',
                where: 'id = ?', whereArgs: ['${duplicateMap.keys.first}']))
            .first;

        Map<String, Object?> secondTrackMap = (await db.query('tracks',
                where: 'id = ?', whereArgs: ['${duplicateMap.values.first}']))
            .first;

        Track firstTrack = Track.fromMap(firstTrackMap);
        Track secondTrack = Track.fromMap(secondTrackMap);

        Track goodTrack;
        Track badTrack;

        // Comparing the bitrates to preserve the higher quality track
        if (firstTrack.bitrate < secondTrack.bitrate) {
          goodTrack = secondTrack;
          badTrack = firstTrack;
        } else {
          goodTrack = firstTrack;
          badTrack = secondTrack;
        }

        // Retrieve hotcue info from both tracks
        List<Map<String, Object?>> goodHotCueMapList = await db.query('''
        (SELECT * 
        FROM hotcues
        WHERE trackid = ${goodTrack.id}
        )
        ''');

        List<Map<String, Object?>> badHotCueMapList = await db.query('''
        (SELECT * 
        FROM hotcues
        WHERE trackid = ${badTrack.id}
        )
        ''');

        List<Hotcue> goodHotCueList = goodHotCueMapList.map((hotcuemap) {
          return Hotcue.fromMap(hotcuemap);
        }).toList();

        List<Hotcue> badHotCueList = badHotCueMapList.map((hotcuemap) {
          return Hotcue.fromMap(hotcuemap);
        }).toList();

        // Function checks if there is not already a cue of the same type and around the same time in the track
        bool cuesOfSameTypeAndNearEachother(
            Hotcue firstHotcue, Hotcue secondHotcue) {
          int firstHotcueStart = firstHotcue.start as int;
          int secondHotcueStart = secondHotcue.start as int;
          int distanceBetweenHotcues =
              (firstHotcueStart - secondHotcueStart).abs();

          return firstHotcue.type == secondHotcue.type &&
              distanceBetweenHotcues < 2;
        }

        // Merge hotcues
        for (Hotcue badHotCue in badHotCueList) {
          // Hotcues and memorycues
          if (badHotCue.type == '0') {
            // Hotcues have number != -1
            if (badHotCue.number != '-1' &&
                !goodHotCueList.any((Hotcue goodHotcue) {
                  // If the goodhotcuelist doesn't already have a hotcue similar to the proposed badhotcue...
                  return goodHotcue.number != '-1' &&
                      cuesOfSameTypeAndNearEachother(goodHotcue, badHotCue);
                })) {
              // ... have goodhotcuelist adopt badhotcue and correct the id
              badHotCue.trackid = goodTrack.id;
              goodHotCueList.add(badHotCue);
            } else if (badHotCue.number == '-1' &&
                !goodHotCueList.any((Hotcue goodHotcue) {
                  return goodHotcue.number == '-1' &&
                      cuesOfSameTypeAndNearEachother(goodHotcue, badHotCue);
                })) {
              badHotCue.trackid = goodTrack.id;
              goodHotCueList.add(badHotCue);
            }
          } else if (!goodHotCueList.any((Hotcue goodHotCue) {
            return cuesOfSameTypeAndNearEachother(goodHotCue, badHotCue);
          })) {
            badHotCue.trackid = goodTrack.id;
            goodHotCueList.add(badHotCue);
          }
        }

        // Sort cues by starting time
        goodHotCueList.sort((firstCue, secondCue) {
          int firstCueStart = firstCue.start as int;
          int secondCueStart = secondCue.start as int;
          return firstCueStart.compareTo(secondCueStart);
        });

        // RGB values taken from own RGB colored collection
        // TODO: make this dependent on colorscheme found in XML
        Map<String, RGB> hotcueNumberToColorMap = {
          '0': RGB("255", "55", "111"),
          '1': RGB("69", "172", "219"),
          '2': RGB("125", "193", "61"),
          '3': RGB("170", "114", "255"),
          '4': RGB("48", "210", "110"),
          '5': RGB("224", "100", "27"),
          '6': RGB("48", "90", "255"),
          '7': RGB("195", "175", "4")
        };

        int goodHotCueListLength = goodHotCueList.length;

        // Number to keep track of hotcues and assign correct number
        int hotcueNumber = 0;

        // Loop to renumber the hotcues to avoid duplicate cue numbers due to merging
        for (int i = 0; i < goodHotCueListLength; i++) {
          Hotcue hotcue = goodHotCueList[i];

          // Memory cues have static number '-1' and must be skipped
          if (hotcue.number != '-1') {
            hotcue.number = hotcueNumber.toString();

            // Assign to preset RGB if cuenumber in RGB map, else set to original RGB
            RGB hotcueRGB = hotcueNumberToColorMap[hotcue.number] ??
                RGB(hotcue.red, hotcue.green, hotcue.blue);

            // Assign colors to cue
            hotcue.red = hotcueRGB.red;
            hotcue.green = hotcueRGB.green;
            hotcue.blue = hotcueRGB.blue;

            // Increase hotcuenumber to correctly assign next found hotcue
            hotcueNumber++;
          }
        }

        // Start a new batch
        Batch batch = db.batch();

        // Replacing bad track playlist entries with good tracks
        batch.update('playlisttracks', {'trackid': goodTrack.id},
            where: 'trackid = ?', whereArgs: [badTrack.id]);

        // Removing old hotcues
        batch.delete('hotcues',
            where: 'trackid = ? or trackid = ?',
            whereArgs: [goodTrack.id, badTrack.id]);

        // Inserting new hotcues
        for (Hotcue hotcue in goodHotCueList) {
          batch.insert('hotcues', hotcue.toMap());
        }

        // Deleting the remaining bad track entries in the database
        batch.delete('tracks', where: 'id = ?', whereArgs: [badTrack.id]);
        batch.delete('tempos', where: 'trackid = ?', whereArgs: [badTrack.id]);
        batch.commit();

        // Deleting the corresponding badtrack file
        final File duplicateTrackFile = File(badTrack.location);
        duplicateTrackFile.deleteSync();
        print("Track with id: ${badTrack.id} deleted...");
      }
    }

    await tracksToDatabase();
    await playlistsToDatabase();
    print("Database saved at ${db.path}");
    await mergeDuplicates(await findDuplicateIds());

    await db.close();
  }
}
