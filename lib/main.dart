import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final _TabPages = <Widget>[
      // const Center(child: Icon(Icons.copy, size: 64, color: Colors.amber)),
      Duplicates(),
      const Center(child: Icon(Icons.recycling, size: 64, color: Colors.green))
    ];
    final _Tabs = <Tab>[
      const Tab(icon: Icon(Icons.copy), text: 'Duplicates'),
      const Tab(icon: Icon(Icons.recycling), text: 'Garbage Collection')
    ];
    return DefaultTabController(
      length: _Tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Rekordbox Fix'),
          bottom: TabBar(
            tabs: _Tabs,
          ),
        ),
        body: TabBarView(
          children: _TabPages,
        ),
      ),
    );
  }
}

class Duplicates extends StatefulWidget {
  @override
  State<Duplicates> createState() => _DuplicatesState();
}

class _DuplicatesState extends State<Duplicates> {
  bool fileLoaded = false;

  void _filepicker() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      print("No file selected");
    } else {
      setState(() => {fileLoaded = true});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    if (!fileLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Find and delete duplicates in your Rekordbox library'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () => _filepicker(),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: const Text('Import your collection\'s XML'),
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text('Review the duplicates before deletion'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            children: [Icon(Icons.file_open), Text('result.files.single.name')],
          ),
        ),
      );
    }
  }
}
