// ignore_for_file: non_constant_identifier_names

import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:core';
import 'package:logger/logger.dart';
import 'package:audiotags/audiotags.dart';

import '/track.dart';
import '/hotcue.dart';
import '/tempo.dart';
import '/playlist.dart';
import '/playlist_folder.dart';
import '/playlist_track.dart';
import '/r_g_b.dart';

// Setting up the logger
var logger = Logger(level: Level.info);

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
      path.join(databaseDirectoryPath, 'track_database.db'),
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
BitRate INTEGER, 
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
  FolderName TEXT,
  FOREIGN KEY (FolderName) REFERENCES playlistfolders(Name)
);

CREATE TABLE playlisttracks (
  PlaylistName TEXT,
  Key INTEGER,
  FOREIGN KEY (PlaylistName) REFERENCES playlists(Name),
  FOREIGN KEY (Key) REFERENCES tracks(TrackID)
);

Create TABLE playlistfolders (
  Name TEXT PRIMARY KEY,
  Type TEXT,
  Count TEXT,
  ParentName TEXT

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
          logger.d(
              "Track ${collectionTracks.indexOf(xmlTrack)} added to the batch");
        }

        // Committing batch to database
        await batch.commit();
        logger.i("Track batch committed to database");
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
          xmlPlaylist.findAllElements("TRACK").forEach((element) {
            PlaylistTrack playlistTrack =
                PlaylistTrack.fromXmlElement(playlist, element);

            // Inserting playlisttracks into the batch
            batch.insert('playlisttracks', playlistTrack.toMap(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          });
          logger.d(
              "Playlist ${playlistList.indexOf(xmlPlaylist)} added to the batch");
        }

        // Committing the playlist batches to database
        batch.commit();
      });
    }

    Future<List<Map<String, dynamic>>> findDuplicateIds() async {
      List<Map<String, Object?>> duplicateIdsQuery = await db.query('''
        (SELECT DISTINCT t1.TrackID AS firstTrackId, t2.TrackID AS secondTrackId
        FROM tracks AS t1
        JOIN tracks AS t2
        ON t1.Name LIKE t2.Name
        WHERE t1.TrackID < t2.TrackID
        AND t1.Artist LIKE t2.Artist
        AND t1.Location != t2.Location);
        ''');
      List<Map<String, dynamic>> duplicateIds =
          duplicateIdsQuery.map((e) => Map<String, dynamic>.from(e)).toList();

      logger.i('${duplicateIds.length} duplicate pairs found');
      return duplicateIds;
    }

    Future<void> mergeDuplicates(
        List<Map<String, dynamic>> duplicateIdsList) async {
      logger.i('Merging duplicates');
      for (Map duplicateMap in duplicateIdsList) {
        Map<String, Object?>? firstTrackMap = (await db.query('tracks',
                    where: 'TrackID = ?',
                    whereArgs: [duplicateMap["firstTrackId"]]))
                // If a track has versions 1,2 and 3, this will return null when trying to access already deleted version 2 in the comparison with 3
                .firstOrNull ??

            // Return the ID of the track that was not deleted in the first duplicateset that contained the track
            (await db.query('tracks', where: 'TrackID = ?', whereArgs: [
              duplicateIdsList
                  .firstWhere((element) =>
                      element.containsValue(duplicateMap['firstTrackId']))
                  .entries
                  .firstWhere((element) =>
                      element.value != duplicateMap['firstTrackId'])
                  .value
            ]))
                .firstOrNull;

        Map<String, Object?>? secondTrackMap = (await db.query('tracks',
                    where: 'TrackID = ?',
                    whereArgs: [duplicateMap["secondTrackId"]]))
                .firstOrNull ??
            // Return the ID of the track that was not deleted in the first duplicateset that contained the track
            (await db.query('tracks', where: 'TrackID = ?', whereArgs: [
              duplicateIdsList
                  .firstWhere((element) =>
                      element.containsValue(duplicateMap['secondTrackId']))
                  .entries
                  .firstWhere((element) =>
                      element.value != duplicateMap['secondTrackId'])
                  .value
            ]))
                .firstOrNull;
        if (firstTrackMap == null || secondTrackMap == null) {
          // pass
        } else {
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
            double firstHotcueStart = double.parse(firstHotcue.Start);
            double secondHotcueStart = double.parse(secondHotcue.Start);
            double distanceBetweenHotcues =
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
            double firstCueStart = double.parse(firstCue.Start);
            double secondCueStart = double.parse(secondCue.Start);
            return firstCueStart.compareTo(secondCueStart);
          });

          // RGB values taken from own RGB colored collection
          // TODO: make this dependent on colorscheme found in XML?
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
          batch.update('playlisttracks', {'Key': goodTrack.TrackID},
              where: 'Key = ?', whereArgs: [badTrack.TrackID]);

          // Removing old hotcues
          batch.delete('hotcues',
              where: 'TrackID = ? or TrackID = ?',
              whereArgs: [goodTrack.TrackID, badTrack.TrackID]);

          // Inserting new hotcues
          for (Hotcue hotcue in goodHotCueList) {
            batch.insert('hotcues', hotcue.toMap());
          }
          
          // Fixing metadata
          Tag? goodTrackTag = await AudioTags.read(goodTrack.Location);
          Tag? badTrackTag = await AudioTags.read(badTrack.Location);
          Tag newTag;

          if (goodTrackTag == null) {
            if (badTrackTag != null) {
              AudioTags.write(goodTrack.Location, badTrackTag);
            }
          } else {
            newTag = Tag(
                title:
                    goodTrack.Name.isNotEmpty ? goodTrack.Name : badTrack.Name,
                trackArtist: goodTrack.Artist.isNotEmpty
                    ? goodTrack.Artist
                    : badTrack.Artist,
                album: goodTrack.Album.isNotEmpty
                    ? goodTrack.Album
                    : badTrack.Album,
                albumArtist:
                    goodTrackTag.albumArtist ?? badTrackTag?.albumArtist,
                genre: goodTrack.Genre.isNotEmpty
                    ? goodTrack.Genre
                    : badTrack.Genre,
                year: goodTrack.Year != 0 ? goodTrack.Year : badTrack.Year,
                trackNumber: goodTrack.TrackNumber != 0
                    ? goodTrack.TrackNumber
                    : badTrack.TrackNumber,
                trackTotal: goodTrackTag.trackTotal ?? badTrackTag?.trackTotal,
                discNumber: goodTrack.DiscNumber != 0
                    ? goodTrack.DiscNumber
                    : badTrack.DiscNumber,
                discTotal: goodTrackTag.discTotal ?? badTrackTag?.discTotal,
                pictures: goodTrackTag.pictures.isNotEmpty
                    ? goodTrackTag.pictures
                    : badTrackTag?.pictures ?? goodTrackTag.pictures);
            AudioTags.write(goodTrack.Location, newTag);
          }
          
          // Deleting the remaining bad track entries in the database
          batch.delete('tracks',
              where: 'TrackID = ?', whereArgs: [badTrack.TrackID]);
          batch.delete('tempos',
              where: 'TrackID = ?', whereArgs: [badTrack.TrackID]);
          batch.commit();

          // Deleting the corresponding badtrack file
          final File duplicateTrackFile = File(badTrack.Location);
          if (duplicateTrackFile.existsSync()) {
            duplicateTrackFile.deleteSync();
            logger.d("Track with id: ${badTrack.TrackID} deleted...");
          }

          
        }
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
      builder.processing('xml', 'version="1.0" encoding="UTF-8"');
      builder.element("DJ_PLAYLISTS", nest: () {
        builder.attribute('Version', "1.0.0");
        builder.element("PRODUCT", attributes: {
          'Name': productName,
          'Version': productVersion,
          'Company': productCompany
        });
        builder.element('COLLECTION', attributes: {'Entries': trackCount});
        builder.element('PLAYLISTS', nest: () {
          builder.element('NODE',
              attributes: {'Type': '0', 'Name': 'ROOT', 'Count': ''});
        });
      });

      final newXML = builder.buildDocument();

      await db.transaction((txn) async {
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
          List<Map<String, Object?>> tempoMapList = await txn.query('tempos',
              where: 'TrackID = ?', whereArgs: [track.TrackID]);
          for (Map<String, Object?> tempoMapObject in tempoMapList) {
            Tempo tempo = Tempo.fromMap(tempoMapObject);
            builder.element('TEMPO', attributes: tempo.toXmlMap());
            xmlTrack.children.add(builder.buildFragment());
          }

          // Adding hotcue nodes to track element
          List<Map<String, Object?>> hotcueMapList = await txn.query('hotcues',
              where: 'TrackID = ?', whereArgs: [track.TrackID]);
          for (Map<String, Object?> hotcueMapObject in hotcueMapList) {
            Hotcue hotcue = Hotcue.fromMap(hotcueMapObject);
            if (hotcue.Num == "-1") {
              builder.element('POSITION_MARK',
                  attributes: hotcue.memoryCueToXmlMap());
            } else {
              builder.element('POSITION_MARK', attributes: hotcue.toXmlMap());
            }
            xmlTrack.children.add(builder.buildFragment());
          }
        }

        // Obtaining list of all tracks
        List<Map<String, dynamic>> trackMapList = (await txn.query('tracks'))
            .map((e) => Map<String, dynamic>.from(e))
            .toList();

        // Adding track node with hotcues and tempo children nodes
        for (Map<String, dynamic> trackMap in trackMapList) {
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

            List<Map<String, Object?>> newPlaylistFolderMapList = (await txn
                .query('playlistfolders',
                    where: 'parentName = ?', whereArgs: [playlistFolder.Name]));

            List<PlaylistFolder> newPlaylistFolderList =
                newPlaylistFolderMapList
                    .map((e) => PlaylistFolder.fromMap(e))
                    .toList();

            addPlaylistFolders(newPlaylistFolderList, builder, xmlDocument);
          }
        }

        List<Map<String, Object?>> rootPlaylistFolderMapList = (await txn.query(
            'playlistfolders',
            where: 'parentName = ?',
            whereArgs: ['ROOT']));

        List<PlaylistFolder> rootPlaylistFolderList = rootPlaylistFolderMapList
            .map((e) => PlaylistFolder.fromMap(e))
            .toList();

        await addPlaylistFolders(rootPlaylistFolderList, builder, newXML);

        // Function to add the playlists
        Future<void> addPlaylists(XmlDocument xmlDocument) async {
          final builder = XmlBuilder();
          List<Playlist> playlists = (await txn.query('playlists'))
              .map((e) => Playlist.fromMap(e))
              .toList();

          for (Playlist playlist in playlists) {
            // Create a NODE xmlelement for the playlist
            builder.element('NODE', attributes: playlist.toXmlMap());
            xmlDocument
                .findAllElements('NODE')
                .singleWhere((element) =>
                    element.getAttribute('Name') == playlist.FolderName)
                .children
                .add(builder.buildFragment());

            // Find the corresponding tracks and list them
            List<PlaylistTrack> playlistTracks = (await txn.query(
                    'playlisttracks',
                    where: 'PlaylistName = ?',
                    whereArgs: [playlist.Name]))
                .map((e) => PlaylistTrack.fromMap(e))
                .toList();

            // Add all tracks to the playlistnode
            for (PlaylistTrack playlistTrack in playlistTracks) {
              builder.element('TRACK', attributes: playlistTrack.toXmlMap());

              xmlDocument
                  .findAllElements('NODE')
                  .singleWhere((element) =>
                      element.getAttribute('Name') == playlist.Name)
                  .children
                  .add(builder.buildFragment());

              XmlElement playlistNode = xmlDocument
                  .findAllElements('NODE')
                  .singleWhere((element) =>
                      element.getAttribute('Name') == playlist.Name);

              // Correct the Entries counter
              int playlistEntries = playlistNode.children.length;
              playlistNode.setAttribute('Entries', playlistEntries.toString());
            }
          }
        }

        await addPlaylists(newXML);

        final Directory? newFileDirectory = await getDownloadsDirectory();
        if (newFileDirectory == null) {
          throw Exception('Downloads directory not found');
        }
        final String newFilePath =
            path.join(newFileDirectory.path, 'cleanCollection.xml');

        final File newXmlFile = File(newFilePath);

        // Prevent subsequent sessions from appending to same xml
        if (newXmlFile.existsSync()) {
          newXmlFile.deleteSync();
        }
        newXmlFile.writeAsStringSync(newXML.toXmlString(pretty: true));
        logger.i('File saved to ${newXmlFile.path}');
      });
    }

    logger.i('Building database...');
    await tracksToDatabase();
    await playlistFoldersToDatabase();
    await playlistsToDatabase();

    logger.i("Database saved at ${db.path}");
    await mergeDuplicates(await findDuplicateIds());
    logger.i('Building xml...');
    await buildNewXml();

    await db.close();

    // Delete the database to prevent database pollution between sessions
    final File databaseFile = File(db.path);
    databaseFile.deleteSync();
  }
}
