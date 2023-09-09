

import 'package:database/screens/add_update.dart';
import 'package:flutter/material.dart';
import 'db.dart/notes_database.dart';
import 'Model/note.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:database/screens/views_node.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Note?>? notes;
  bool isLoding = false;
  @override
  void initState() {
    refreshNotes();
    super.initState();
  }

  @override
  void dispose() {
    NoteDatabase.instance.close();
    super.dispose();
  }

  Future refreshNotes() async {
    setState(() {
      isLoding = true;
      NoteDatabase.instance.readAllNotes().then((value) => notes = value);
      setState(() {
        isLoding = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DataBase"),
      ),
      body: FutureBuilder(
        future: NoteDatabase.instance.readAllNotes(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return isLoding
              ? const CircularProgressIndicator()
              : notes!.isEmpty
                  ? const Center(
                      child: Text("No Data"),
                    )
                  : ListView.builder(
                      itemCount: notes?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () async {
                            await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ViewNode(nodeid: notes![index]!.id),
                            ));
                          },
                          child: SingleChildScrollView(
                            child: Card(
                              color: Colors.amber,
                              margin: const EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    notes![index]!.title.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  Text(
                                    notes![index]!.description.toString(),
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUpdateNote(),
            ),
          );
          refreshNotes();
        },
        child: const Icon(Icons.pages),
      ),
    );
  }
}
