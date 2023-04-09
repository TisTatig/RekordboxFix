import 'dart:ffi';
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
  Map<String, Map<dynamic, dynamic>> duplicateMap = {};

  @override
  void initState() {
    super.initState();
    var element, match;
    var testName, testID, testArtist, testSize, matchID, matchArtist, matchSize;

    late final trackList = XmlDocument.parse(widget.file.readAsStringSync())
        .findAllElements('TRACK')
        .first
        .siblings;

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

      // If match is found a new ListTile item is created and appended to the duplicateList
      if (matchArtist == testArtist &&
          matchSize == testSize &&
          !(testID == matchID)) {
        duplicateMap[matchID] = {
          'Selected': false,
          'Artist': testArtist,
          'Name': testName,
          'Original': testID
        };
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
            title:
                Center(child: Text('${duplicateMap.length} duplicates found'))),
        body: ListView.builder(
            itemCount: duplicateMap.length,
            itemBuilder: (BuildContext context, int index) {
              final matchID = duplicateMap.keys.elementAt(index);
              Map<dynamic, dynamic>? matchInfo = duplicateMap[matchID];

              return CheckboxListTile(
                value: matchInfo?['Selected'],
                onChanged: (bool? value) {
                  value = !matchInfo?['Selected'];
                  matchInfo?['Selected'] = value;
                  setState(() => {});
                },
                title: Text(duplicateMap[matchID]?['Name'] +
                    " - " +
                    duplicateMap[matchID]?['Artist']),
              );
            }),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  onPressed: () {
                    print('Delete Placeholder');
                  },
                  child: const Text('Delete')),
              ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
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
