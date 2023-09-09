import 'package:database/screens/add_update.dart';
import 'package:flutter/material.dart';
import '../Model/note.dart';
import 'package:database/db.dart/notes_database.dart';

class ViewNode extends StatefulWidget {
  final int? nodeid;
  const ViewNode({super.key, required this.nodeid});

  @override
  State<ViewNode> createState() => _ViewNodeState();
}

class _ViewNodeState extends State<ViewNode> {
  bool isLoding = false;
   Note? notes;

  Future refreshNotes() async {
    setState(() {
      isLoding = true;
      NoteDatabase.instance.readNote(widget.nodeid);
      setState(() {
        isLoding = false;
      });
    });
  }
  @override
  void initState() {

    refreshNotes();
    super.initState();
  }
  Widget editButton() => IconButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddUpdateNote(),
            ),
          );
          refreshNotes();
        },
        icon: const Icon(Icons.update),
      );

  Widget deleteButton() => IconButton(
        onPressed: () async {
          final navigator = Navigator.of(context);
          await NoteDatabase.instance.deleteNote(widget.nodeid);
          navigator.pop();
        },
        icon: const Icon(Icons.delete),
      );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Read Nodes"),
      ),
      body: isLoding
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(12),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                children: [
                  Text(NoteFields.id.toString()),
                  Text(NoteFields.description.toString()),
                  Row(
                    children: [
                      editButton(),
                      deleteButton(),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
