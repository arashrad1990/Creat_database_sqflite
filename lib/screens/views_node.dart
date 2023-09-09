import 'package:database/screens/add_update.dart';
import 'package:flutter/material.dart';
import '../Model/note.dart';
import 'package:database/db.dart/notes_database.dart';

class ViewNode extends StatefulWidget {
  final int? nodeid;
  const ViewNode({Key? key, required this.nodeid}) : super(key: key);

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
              builder: (context) => const AddUpdateNote(
             
              ), //notes : notes
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
                  Card(
                    child: ListTile(
                      tileColor: Colors.grey,
                      title: Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Text(
                          notes!.title.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 22),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 20, bottom: 20),
                        child: Text(
                          notes!.description.toString(),
                          style: const TextStyle(
                              color: Colors.black, fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
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
