import 'package:flutter/material.dart';
import '../Model/note.dart';
import 'package:database/db.dart/notes_database.dart';

class AddUpdateNote extends StatefulWidget {
  final Note? notes;
  const AddUpdateNote({Key? key, this.notes}) :super(key: key);

  @override
  State<AddUpdateNote> createState() => _AddUpdateNoteState(); 
}

class _AddUpdateNoteState extends State<AddUpdateNote> {
  TextEditingController texttitles = TextEditingController();
  TextEditingController textdescriptions = TextEditingController();
  final _fromKey = GlobalKey<FormState>();
  late String title;
  late String description;
  @override
  void initState() {
    title = widget.notes?.title ?? "";
    description = widget.notes?.description ?? "";
    super.initState();
  }

  Future updateNode() async {
    title = texttitles.text;
    description = textdescriptions.text;
    final navigator = Navigator.of(context);
    final node = widget.notes?.copy(
      title: title,
      description: description,
    );
    await NoteDatabase.instance.updateNote(node!);
    navigator.pop();
  }

  Future addNode() async {
    title = texttitles.text;
    description = textdescriptions.text;
    final navigator = Navigator.of(context);
    final node = Note(
      title: title,
      description: description,
    );
    await NoteDatabase.instance.create(node);
    navigator.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD_UPDATE_NOTES"),
      ),
      body: Form(
        key: _fromKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  keyboardType: TextInputType.text,
                  controller: texttitles,
                  decoration: const InputDecoration(
                    hintText: "Enter Title",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  maxLines: 8,
                  keyboardType: TextInputType.text,
                  controller: textdescriptions,
                  decoration:
                      const InputDecoration(hintText: "Enter desvription"),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: addNode,
                    icon: const Icon(Icons.save),
                    label: const Text("Save"),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton.icon(
                    onPressed: updateNode,
                    icon: const Icon(Icons.update),
                    label: const Text("Update"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
