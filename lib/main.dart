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
  const DuplicatesMenu({super.key, required this.file, required this.onCancel});

  final File file;
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
    var element, match;
    var testName, testID, testArtist, testSize, matchID, matchArtist, matchSize;

// TODO: Streamline this process
    for (int i = 0; i < trackList.length; i++) {
      element = trackList.elementAt(i);
      testName = element?.getAttribute('Name');
      testID = element?.getAttribute('TrackID');
      testArtist = element?.getAttribute('Artist');
      testSize = element?.getAttribute('Size');
      match = trackList
          .lastWhere((element) => element.getAttribute('Name') == testName);
      matchID = match?.getAttribute('TrackID');
      matchArtist = element?.getAttribute('Artist');
      matchSize = element?.getAttribute('Size');

      if (matchArtist == testArtist &&
          matchSize == testSize &&
          !(testID == matchID)) {
        duplicateMap[testID] = '$matchID';
      }
    }
    print(match.attributes);
  }

  // TODO: Complete the merge function
  void mergeDuplicates(Map<String, String> duplicates) {
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
        // Loop over playlists in playlist section of xml
        for (XmlElement playListElement in playListSection) {
          // Only apply to elements that themselves directly contain tracks (i.e. of type 1 apparently)
          if (playListElement.getAttribute("Type") == "1") {
            // Obtain the tracklist they hold in the form of xmlnodes
            Iterable<XmlNode> playListTrackList = playListElement.children;

            // Replace secondTrack playlist listings (by TrackID) with firstTrack TrackID
            for (XmlNode playListTrack in playListTrackList) {
              if (playListTrack.getAttribute("Key") ==
                  secondTrack.getAttribute("TrackID")) {
                playListTrack.setAttribute(
                    "Key", firstTrack.getAttribute("TrackID"));
              }
            }
          }
        }

        // Deleting the duplicate track
        duplicateTrack = secondTrack.getAttribute("Location") as File;
        try {
          duplicateTrack.deleteSync();
        } catch (e) {
          // TODO: Have the program create an error log in which the file locations and errors can be found
          AlertDialog(
            title: const Text("File Deletion Error"),
            content: Text(
                "The duplicate at ${secondTrack.getAttribute("Location")} could not be deleted ($e). However, the duplicate will still be removed from your RekordBox library.\nYou can run the garbage track collection module to have it removed for you, or else you can always delete the file manually. "),
          );
        }

        collectionXML.rootElement.children
            .removeWhere((element) => element.getAttribute("trackID") == value);
      },
    );
  }

  // TODO: widget should return the amount of duplicates and then give the option to merge them
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
                    print('Merge Placeholder');
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
