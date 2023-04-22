part of '../main.dart';

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
    var duplicateBin = Directory("${widget.file.parent.path}\\DuplicateTracks");
    duplicateBin.createSync();

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
          duplicateTrack.copySync(
              "${duplicateBin.path}/${duplicateTrack.path.substring(duplicateTrack.path.lastIndexOf("/") + 1)}");
          duplicateTrack.deleteSync();
          duplicateRemovalCount++;
        } catch (e) {
          // TODO: Have the program create an error log with file locations
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Center(child: Text("Understood")),
                      )
                    ],
                    title: const Text("File Deletion Error"),
                    content: Text(
                        "The duplicate at ${secondTrack.getAttribute("Location")} could not be deleted. However, the duplicate will still be removed from your RekordBox library.\nYou can run the garbage track collection module to have it removed for you, or else you can always delete the file manually."),
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
    // TODO: Overwrite the old XML file with new one
    String newCollectionPath = "${widget.file.parent.path}\\newCollection.xml";
    File(newCollectionPath).writeAsStringSync(collectionXML.toXmlString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
            textAlign: TextAlign.center,
            "$duplicateRemovalCount tracks have been merged"),
        content: Text(
            textAlign: TextAlign.center,
            "The duplicate files have been moved to:\n ${duplicateBin.path}\nfor review and/or deletion"),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.goBack(File(newCollectionPath));
            },
            child: const Center(child: Text("Continue")),
          )
        ],
        actionsPadding: const EdgeInsets.all(20.0),
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
                    widget.goBack(null);
                  },
                  child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }
}
