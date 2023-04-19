import 'dart:io';
import 'package:xml/xml.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

List<String> userPhaseList = [
  "noFileLoaded",
  "fileLoaded",
  "duplicateFunctionality",
  "garbageFunctionality"
];

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RekordBoxFix App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int activePhaseIndex = 0;
  late File collectionXML;

  @override
  Widget build(BuildContext context) {
    switch (activePhaseIndex) {
      case 0:
        {
          return HomeWithoutFile(
            onSelectFile: (file) {
              setState(() {
                activePhaseIndex = 1;
                collectionXML = file;
              });
            },
          );
        }

      case 1:
        {
          return HomeWithFile(
              file: collectionXML,
              onCancel: () {
                setState(() {
                  activePhaseIndex = 0;
                });
              },
              findDuplicates: () {
                setState(() {
                  activePhaseIndex = 2;
                });
              });
        }

      case 2:
        {
          return DuplicatesMenu(
              file: collectionXML,
              onCancel: () {
                setState(() {
                  activePhaseIndex = 1;
                });
              },
              goBack: (file) {
                setState(() {
                  activePhaseIndex = 1;
                  collectionXML = file;
                });
              });
        }

      /* TODO: CREATE OTHER CASES
      case 3: 
      {
        return garbageMenu(context);
      }
      */
      default:
        {
          return HomeWithoutFile(
            onSelectFile: (file) {
              setState(() {
                activePhaseIndex = 1;
                collectionXML = file;
              });
            },
          );
        }
    }
  }
}

class DuplicatesMenu extends StatefulWidget {
  const DuplicatesMenu(
      {super.key,
      required this.file,
      required this.goBack,
      required this.onCancel});

  final File file;
  final void Function(File) goBack;
  final void Function() onCancel;

  @override
  State<DuplicatesMenu> createState() => _DuplicatesMenuState();
}

class _DuplicatesMenuState extends State<DuplicatesMenu> {
  Map<String, String> duplicateMap = {};
  late XmlDocument collectionXML =
      XmlDocument.parse(widget.file.readAsStringSync());
  late final trackList = collectionXML.findAllElements('TRACK');
  late final playListSection = collectionXML.findAllElements("PLAYLISTS");
  late File duplicateTrack;

  @override
  void initState() {
    super.initState();
    XmlElement? element, match;
    String? testName,
        testID,
        testArtist,
        testSize,
        matchID,
        matchArtist,
        matchSize;

// TODO: Streamline this process
    for (int i = 0; i < trackList.length; i++) {
      element = trackList.elementAt(i);
      testName = element.getAttribute('Name');
      testID = element.getAttribute('TrackID');
      testArtist = element.getAttribute('Artist');
      testSize = element.getAttribute('Size');
      match = trackList
          .lastWhere((element) => element.getAttribute('Name') == testName);
      matchID = match.getAttribute('TrackID');
      matchArtist = element.getAttribute('Artist');
      matchSize = element.getAttribute('Size');

      if (matchArtist == testArtist &&
          matchSize == testSize &&
          !(testID == matchID)) {
        duplicateMap[testID!] = '$matchID';
      }
    }
  }

  void mergeDuplicates(Map<String, String> duplicates) {
    int duplicateRemovalCount = 0;
    duplicates.forEach(
      (key, value) {
        XmlElement firstTrack = trackList
            .firstWhere((element) => element.getAttribute('TrackID') == key);
        XmlElement secondTrack = trackList
            .firstWhere((element) => element.getAttribute('TrackID') == value);

        // Going over the attributes of both tracks
        for (int i = 0; i < firstTrack.attributes.length; i++) {
          XmlAttribute firstTrackAtt = firstTrack.attributes[i];
          XmlAttribute secondTrackAtt = secondTrack.attributes[i];

          // If secondTrack has more complete data it overwrites firstTrackData
          if (firstTrackAtt.value != secondTrackAtt.value &&
              firstTrackAtt.value.isEmpty) {
            firstTrack.setAttribute(secondTrackAtt.name.toString(),
                secondTrackAtt.value.toString());
          }
        }

        // If secondTrack has more hotcues, overwrite the firstTrack hotcues
        if (firstTrack.children.length < secondTrack.children.length) {
          for (int childIndex = 0;
              childIndex < secondTrack.children.length;
              childIndex++) {
            // Replace the existing firstTrack hotcues with secondTrack hotcues
            if (childIndex < firstTrack.children.length) {
              firstTrack.children[childIndex]
                  .replace(secondTrack.children[childIndex]);
              // Append the remaining hotcue children to firstTrack
            } else {
              firstTrack.children.add(secondTrack.children[childIndex]);
            }
          }
        }

        // Replace secondTrack playlist listings (by TrackID) with firstTrack TrackID
        collectionXML
            .findAllElements("PLAYLISTS")
            .first
            .findAllElements("TRACK")
            .where((trackNode) =>
                trackNode.getAttribute("Key") ==
                secondTrack.getAttribute("TrackID"))
            .forEach(
              (element) => element.setAttribute(
                  "Key", firstTrack.getAttribute("TrackID")),
            );

        // Directing the app to the duplicate file
        String duplicatePath = secondTrack.getAttribute("Location") as String;
        // RekordBox prepends a string that we need to get rid of
        duplicateTrack = File(duplicatePath
            // TODO: Check if this holds for all operating systems
            .replaceAll('file://localhost/', "")
            .replaceAll("%20", " "));
        // Deleting the actual files of the duplicates
        try {
          // TODO: Remove trainingwheel by removing copySync: Now the file is first moved to a TestBin folder
          // TODO: Replace absolute path with relative one
          duplicateTrack.copySync(
              "C:/Users/krezi/Documents/Visual Studio Code/Rekordbox/rekordboxfix_app/test/testTracks/TestBin/${duplicateTrack.path.substring(duplicateTrack.path.lastIndexOf("/") + 1)}");
          duplicateTrack.deleteSync();
          duplicateRemovalCount++;
        } catch (e) {
          // TODO: Have the program create an error log in which the file locations and errors can be found
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          color: Theme.of(context).colorScheme.primary,
                          padding: const EdgeInsets.all(10),
                          child: const Text("Okay"),
                        ),
                      )
                    ],
                    title: const Text("File Deletion Error"),
                    content: Text(
                        "The duplicate at ${secondTrack.getAttribute("Location")} could not be deleted ($e). However, the duplicate will still be removed from your RekordBox library.\nYou can run the garbage track collection module to have it removed for you, or else you can always delete the file manually."),
                  ));
        }

        // Deleting the Xml nodes of the duplicates
        collectionXML
            .findAllElements("COLLECTION")
            .first
            .children
            .removeWhere((element) => element.getAttribute("TrackID") == value);
      },
    );
    // TODO: Overwrite the old XML file with new one to fix playlists
    // TODO: Replace absolute path with relative
    String newCollectionPath =
        "C:/Users/krezi/Documents/Visual Studio Code/Rekordbox/rekordboxfix_app/test/newCollection.xml";
    File(newCollectionPath).writeAsStringSync(collectionXML.toXmlString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("$duplicateRemovalCount duplicates have been removed."),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.goBack(File(newCollectionPath));
            },
            child: const Text("Okay"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title:
                Center(child: Text('${duplicateMap.length} duplicates found'))),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    mergeDuplicates(duplicateMap);
                  },
                  child: const Text('Merge Duplicates')),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () {
                    widget.onCancel();
                  },
                  child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }
}

class HomeWithFile extends StatelessWidget {
  const HomeWithFile(
      {super.key,
      required this.file,
      required this.onCancel,
      required this.findDuplicates});

  final File file;
  final void Function() onCancel;
  final void Function() findDuplicates;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(children: [
              Icon(
                Icons.audio_file_outlined,
                color: Theme.of(context).primaryColor,
                size: 64,
              ),
              Text(file.path),
            ]),
            ElevatedButton(
                child: const Text('Find duplicates'),
                onPressed: () => {findDuplicates()}),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                child: const Text('Cancel'), onPressed: () => {onCancel()})
          ],
        ),
      ),
    );
  }
}

class HomeWithoutFile extends StatelessWidget {
  const HomeWithoutFile({
    required this.onSelectFile,
    super.key,
  });

  final void Function(File) onSelectFile;

  Future<void> filepicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    // If a legit file is picked collectionXML updates to contain the filepath and the stateIndex is moved
    final selectedPath = result?.files.single.path;
    if (selectedPath != null) {
      final selectedFile = File(selectedPath);

      onSelectFile(selectedFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Import your collection\'s XML'),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                filepicker();
              },
              child: const Padding(
                padding: EdgeInsets.all(20.0),
                child: Text('Import'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
