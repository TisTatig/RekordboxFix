import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:core';

// Creating new object classes for use in the database
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
}

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
        KeyType: xmlPlaylist.getAttribute("Keytype") as String,
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
      'TrackID': Key,
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
        Count: xmlPlaylistFolder.getAttribute("Keytype") as String,
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
            TrackID INTEGER PRIMARY KEY, 
Name TEXT, 
Artist TEXT, 
Composer TEXT, 
Album TEXT, 
Grouping TEXT, 
Genre TEXT, 
Kind TEXT, 
Size INTEGER, 
TotalTime INTEGER, 
DiscNumber INTEGER, 
TrackNumber INTEGER, 
Year INTEGER, 
AverageBpm TEXT, 
DateAdded TEXT, 
Bitrate INTEGER, 
SampleRate INTEGER, 
Comments TEXT, 
PlayCount INTEGER, 
Rating TEXT, 
Location TEXT, 
Remixer TEXT, 
Tonality TEXT, 
Label TEXT, 
Mix TEXT
            );
            
  CREATE TABLE hotcues (
  TrackID INTEGER,
  Name TEXT,
  Type TEXT,
  Start TEXT,
  Num TEXT,
  Red TEXT,
  Green TEXT,
  Blue TEXT,
  FOREIGN KEY (TrackID) REFERENCES tracks(TrackID)
);

CREATE TABLE tempos (
  TrackID INTEGER,
  Inizio TEXT,
  Bpm TEXT,
  Metro TEXT,
  Battito TEXT,
  FOREIGN KEY (TrackID) REFERENCES tracks(TrackID)
);

CREATE TABLE playlists (
  Name TEXT PRIMARY KEY,
  Type TEXT,
  KeyType TEXT,
  Entries TEXT,
  FolderName TEXT
  FOREIGN KEY (FolderName) REFERENCES playlistfolders(Name)
);

CREATE TABLE playlisttracks (
  PlaylistName TEXT,
  TrackID INTEGER,
  FOREIGN KEY (PlaylistName) REFERENCES playlists(Name),
  FOREIGN KEY (TrackID) REFERENCES tracks(TrackID)
);

Create TABLE playlistfolders (
  Name TEXT PRIMARY KEY
  Type TEXT,
  Count TEXT,
  ParentName TEXT,

)

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
          Track track = Track.fromXmlNode(xmlTrack);

          // Adding track data to batch
          batch.insert('tracks', track.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);

          // Finding and parsing the Tempo data
          List<XmlElement> trackTempoList =
              xmlTrack.findAllElements("TEMPO").toList();
          for (XmlElement trackTempo in trackTempoList) {
            // Adding tempo data to the batch
            Tempo tempo = Tempo.fromXmlElement(track.TrackID, trackTempo);
            batch.insert('tempos', tempo.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          }

          // Finding and parsing the hotcue data
          var xmlHotCueList = xmlTrack.findElements("POSITION_MARK");
          for (XmlElement xmlHotCue in xmlHotCueList) {
            Hotcue hotcue = Hotcue.fromXmlElement(track.TrackID, xmlHotCue);

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

    Future<void> playlistFoldersToDatabase() async {
      //Finding the folders
      List<XmlElement> playlistFoldersList = collectionXML
          .findAllElements("PLAYLISTS")
          .first
          .findAllElements("NODE")
          .where((element) => element.getAttribute("Type") == "0")
          .toList();

      await db.transaction(
        (txn) async {
          final batch = txn.batch();

          // Parsing the folders
          for (XmlElement xmlFolder in playlistFoldersList) {
            PlaylistFolder playlistFolder =
                PlaylistFolder.fromXmlElement(xmlFolder);

            // Inserting folders into the batch
            batch.insert('playlistfolders', playlistFolder.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          }

          // Committing folders to database
          batch.commit();
        },
      );
    }

    // Function for inserting playlists into database
    Future<void> playlistsToDatabase() async {
      // Finding the playlists
      List<XmlElement> playlistList = collectionXML
          .findAllElements("PLAYLISTS")
          .first
          .findAllElements("NODE")
          .where((element) => element.getAttribute("Type") != "0")
          .toList();

      await db.transaction((txn) async {
        final batch = txn.batch();

        // Parsing the playlists
        for (XmlElement xmlPlaylist in playlistList) {
          Playlist playlist = Playlist.fromXmlElement(xmlPlaylist);

          // Inserting playlists into the batch
          batch.insert('playlists', playlist.toMap(),
              conflictAlgorithm: ConflictAlgorithm.replace);

          // Finding and parsing the playlisttracks
          xmlPlaylist.findAllElements("Track").forEach((element) {
            PlaylistTrack playlistTrack =
                PlaylistTrack.fromXmlElement(playlist, element);

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
        (SELECT DISTINCT t1.TrackID AS firstTrackId, t2,TrackID AS secondTrackId
        FROM tracks AS t1
        JOIN tracks AS t2
        ON t1.Name LIKE t2.Name
        WHERE t1.TrackID < t2.TrackID
        AND t1.Artist LIKE t2.Artist
        AND t1.Location != t2.Location);
        ''');
      return duplicateIds;
    }

    Future<void> mergeDuplicates(List duplicateIdsList) async {
      for (Map duplicateMap in duplicateIdsList) {
        Map<String, Object?> firstTrackMap = (await db.query('tracks',
                where: 'TrackID = ?',
                whereArgs: ['${duplicateMap.keys.first}']))
            .first;

        Map<String, Object?> secondTrackMap = (await db.query('tracks',
                where: 'TrackID = ?',
                whereArgs: ['${duplicateMap.values.first}']))
            .first;

        Track firstTrack = Track.fromMap(firstTrackMap);
        Track secondTrack = Track.fromMap(secondTrackMap);

        Track goodTrack;
        Track badTrack;

        // Comparing the bitrates to preserve the higher quality track
        if (firstTrack.BitRate < secondTrack.BitRate) {
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
        WHERE TrackID = ${goodTrack.TrackID}
        )
        ''');

        List<Map<String, Object?>> badHotCueMapList = await db.query('''
        (SELECT * 
        FROM hotcues
        WHERE TrackID = ${badTrack.TrackID}
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
          int firstHotcueStart = firstHotcue.Start as int;
          int secondHotcueStart = secondHotcue.Start as int;
          int distanceBetweenHotcues =
              (firstHotcueStart - secondHotcueStart).abs();

          return firstHotcue.Type == secondHotcue.Type &&
              distanceBetweenHotcues < 2;
        }

        // Merge hotcues
        for (Hotcue badHotCue in badHotCueList) {
          // Hotcues and memorycues
          if (badHotCue.Type == '0') {
            // Hotcues have number != -1
            if (badHotCue.Num != '-1' &&
                !goodHotCueList.any((Hotcue goodHotcue) {
                  // If the goodhotcuelist doesn't already have a hotcue similar to the proposed badhotcue...
                  return goodHotcue.Num != '-1' &&
                      cuesOfSameTypeAndNearEachother(goodHotcue, badHotCue);
                })) {
              // ... have goodhotcuelist adopt badhotcue and correct the id
              badHotCue.TrackID = goodTrack.TrackID;
              goodHotCueList.add(badHotCue);
            } else if (badHotCue.Num == '-1' &&
                !goodHotCueList.any((Hotcue goodHotcue) {
                  return goodHotcue.Num == '-1' &&
                      cuesOfSameTypeAndNearEachother(goodHotcue, badHotCue);
                })) {
              badHotCue.TrackID = goodTrack.TrackID;
              goodHotCueList.add(badHotCue);
            }
          } else if (!goodHotCueList.any((Hotcue goodHotCue) {
            return cuesOfSameTypeAndNearEachother(goodHotCue, badHotCue);
          })) {
            badHotCue.TrackID = goodTrack.TrackID;
            goodHotCueList.add(badHotCue);
          }
        }

        // Sort cues by starting time
        goodHotCueList.sort((firstCue, secondCue) {
          int firstCueStart = firstCue.Start as int;
          int secondCueStart = secondCue.Start as int;
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
          if (hotcue.Num != '-1') {
            hotcue.Num = hotcueNumber.toString();

            // Assign to preset RGB if cuenumber in RGB map, else set to original RGB
            RGB hotcueRGB = hotcueNumberToColorMap[hotcue.Num] ??
                RGB(hotcue.Red, hotcue.Green, hotcue.Blue);

            // Assign colors to cue
            hotcue.Red = hotcueRGB.red;
            hotcue.Green = hotcueRGB.green;
            hotcue.Blue = hotcueRGB.blue;

            // Increase hotcuenumber to correctly assign next found hotcue
            hotcueNumber++;
          }
        }

        // Start a new batch
        Batch batch = db.batch();

        // Replacing bad track playlist entries with good tracks
        batch.update('playlisttracks', {'trackid': goodTrack.TrackID},
            where: 'trackid = ?', whereArgs: [badTrack.TrackID]);

        // Removing old hotcues
        batch.delete('hotcues',
            where: 'trackid = ? or trackid = ?',
            whereArgs: [goodTrack.TrackID, badTrack.TrackID]);

        // Inserting new hotcues
        for (Hotcue hotcue in goodHotCueList) {
          batch.insert('hotcues', hotcue.toMap());
        }

        // Deleting the remaining bad track entries in the database
        batch.delete('tracks', where: 'id = ?', whereArgs: [badTrack.TrackID]);
        batch.delete('tempos',
            where: 'trackid = ?', whereArgs: [badTrack.TrackID]);
        batch.commit();

        // Deleting the corresponding badtrack file
        final File duplicateTrackFile = File(badTrack.Location);
        duplicateTrackFile.deleteSync();
        print("Track with id: ${badTrack.TrackID} deleted...");
      }
    }

    Future<void> buildNewXml() async {
      XmlElement xmlProductElement =
          collectionXML.findAllElements("PRODUCT").first;

      String productName =
          xmlProductElement.getAttribute('Name') ?? "rekordbox";
      String productVersion =
          xmlProductElement.getAttribute('Version') ?? "6.6.11";
      String productCompany =
          xmlProductElement.getAttribute('Company') ?? "AlphaTheta";

      String trackCount = Sqflite.firstIntValue(
              await db.rawQuery('SELECT COUNT(*) from tracks'))
          .toString();

      final builder = XmlBuilder();
      builder.processing('xml', 'version="1.0"');
      builder.element("DJ_PLAYLISTS", nest: () {
        builder.attribute('Version', "1.0.0");
        builder.element("PRODUCT", attributes: {
          'Name': productName,
          'Version': productVersion,
          'Company': productCompany
        }, nest: () {
          builder.element('COLLECTION', attributes: {'Entries': trackCount});
        });
        builder.element('PLAYLISTS', nest: () {
          builder.element('NODE',
              attributes: {'Type': '0', 'Name': 'ROOT', 'Count': ''});
        });
      });

      final newXML = builder.buildDocument();

      void addTrackElement(
          XmlDocument document, XmlBuilder builder, Track track) async {
        builder.element('TRACK', attributes: track.toXmlMap());
        XmlElement collection = document.findAllElements('COLLECTION').first;
        collection.children.add(builder.buildFragment());

        // Find the built track element in the xml for further additions
        XmlElement xmlTrack = document
            .findAllElements('TRACK')
            .where((element) =>
                element.getAttribute("TrackID") == track.TrackID.toString())
            .first;

        // Adding tempo nodes to track element
        List<Map<String, Object?>> tempoMapList = await db
            .query('tempos', where: 'TrackID = ?', whereArgs: [track.TrackID]);
        for (Map<String, Object?> tempoMapObject in tempoMapList) {
          Tempo tempo = Tempo.fromMap(tempoMapObject);
          builder.element('TEMPO', attributes: tempo.toXmlMap());
          xmlTrack.children.add(builder.buildFragment());
        }

        // Adding hotcue nodes to track element
        List<Map<String, Object?>> hotcueMapList = await db
            .query('hotcues', where: 'TrackID = ?', whereArgs: [track.TrackID]);
        for (Map<String, Object?> hotcueMapObject in hotcueMapList) {
          Hotcue hotcue = Hotcue.fromMap(hotcueMapObject);
          builder.element('POSITION_MARK', attributes: hotcue.toXmlMap());
          xmlTrack.children.add(builder.buildFragment());
        }
      }

      // Obtaining list of all tracks
      List<Map<String, String>> trackMapList =
          (await db.query('tracks')).toList().cast<Map<String, String>>();

      // Adding track node with hotcues and tempo children nodes
      for (Map<String, String> trackMap in trackMapList) {
        Track track = Track.fromMap(trackMap);
        addTrackElement(newXML, builder, track);
      }

      // Adds playlist folders recursively looking for folders that have the added folders as parent
      Future<void> addPlaylistFolders(List<PlaylistFolder> playlistFolderList,
          XmlBuilder builder, XmlDocument xmlDocument) async {
        for (PlaylistFolder playlistFolder in playlistFolderList) {
          builder.element('NODE', attributes: playlistFolder.toXmlMap());
          xmlDocument
              .findAllElements("NODE")
              .singleWhere((element) =>
                  element.getAttribute('Name') == playlistFolder.ParentName)
              .children
              .add(builder.buildFragment());
          List<Map<String, Object?>> newPlaylistFolderMapList = (await db.query(
              'playlistfolders',
              where: 'parentFolder = ?',
              whereArgs: [playlistFolder.Name]));

          List<PlaylistFolder> newPlaylistFolderList = newPlaylistFolderMapList
              .map((e) => PlaylistFolder.fromMap(e))
              .toList();

          addPlaylistFolders(newPlaylistFolderList, builder, xmlDocument);
        }
      }

      List<Map<String, Object?>> rootPlaylistFolderMapList = (await db.query(
          'playlistfolders',
          where: 'parentName = ?',
          whereArgs: ['ROOT']));

      List<PlaylistFolder> rootPlaylistFolderList = rootPlaylistFolderMapList
          .map((e) => PlaylistFolder.fromMap(e))
          .toList();

      await addPlaylistFolders(rootPlaylistFolderList, builder, newXML);

      // TODO: find playlists type 1, find tracks belonging to and add
      // Future<void> addPlaylistTracks() {}
    }

    await tracksToDatabase();
    await playlistsToDatabase();
    print("Database saved at ${db.path}");
    await mergeDuplicates(await findDuplicateIds());
    await buildNewXml();
    await db.close();
  }
}
