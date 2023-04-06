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
// TODO: So now the idea is to somehow update thet state whenever the buttons are pressed
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
                activePhaseIndex++;
                collectionXML = file;
              });
            },
          );
        }

      case 1:
        {
          return HomeWithFile(
            file: collectionXML,
          );
        }

      case 2:
        {
          return DuplicatesMenu(
            file: collectionXML,
          );
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
                activePhaseIndex++;
                collectionXML = file;
              });
            },
          );
        }
    }
  }
}

class DuplicatesMenu extends StatelessWidget {
  DuplicatesMenu({
    super.key,
    required this.file,
  });

  final File file;

  var element,
      testName,
      testID,
      testArtist,
      testSize,
      match,
      matchID,
      matchArtist,
      matchSize;

  late final trackList =
      XmlDocument.parse(file.readAsStringSync()).findAllElements('TRACK');
  Map<String, Map> duplicateMap = {};

  @override
  Widget build(BuildContext context) {
    // Creating empty list to house the info of the duplicates in DataRow form for the DataTable

    //Finding the matches
    for (int i = 0; i <= 100; i++) {
      // TODO: the for loop is still limited here in order to make debugging faster
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

      // If match is found a new ListTile item is created and appended to the duplicateList
      // TODO: Implement binary search algorithm
      if (matchArtist == testArtist &&
          matchSize == testSize &&
          !(testID == matchID)) {
        duplicateMap['$matchID'] = {
          'Selected': false,
          'Artist': '$testArtist',
          'Name': '$testName'
        };

        // TODO: Making the onChanged cause the track ID and match ID to be appended to a removal table
        // TODO: Store the trackID somewhere else and add playlist information of both duplicates
      }
    }

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('List of Duplicates'),
        ),
        body: ListView.builder(
          itemCount: duplicateMap.length,
          itemBuilder: (BuildContext context, int index) {
            final matchID = duplicateMap.keys.elementAt(index);

            toggleCheck() {
              // setState(
              //   () {
              //     duplicateMap[matchID]?['Selected'] =
              //         !duplicateMap[matchID]?['Selected'];
              //   },
              // );
            }

            return CheckboxListTile(
              value: duplicateMap[matchID]?['Selected'],
              onChanged: toggleCheck(),
            );
          },
        ),
      ),
    );
  }
}

class HomeWithFile extends StatelessWidget {
  const HomeWithFile({
    super.key,
    required this.file,
  });

  final File file;

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
                onPressed: () => {
                      // setState(() => {activePhaseIndex = 2})
                    }),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              child: const Text('Cancel'),
              onPressed: () => {
                // setState(
                //   () => {activePhaseIndex = 0},
                // )
              },
            )
          ],
        ),
      ),
    );
  }
}

class HomeWithoutFile extends StatelessWidget {
  HomeWithoutFile({
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
