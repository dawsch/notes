import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notatnik/notesNotifier.dart';
import 'note.dart';

class EditNotePage extends StatelessWidget{
  final bool isNew;
  final WidgetRef ref;
  final Note note;
  EditNotePage(this.isNew, this.ref, {this.note = const Note(content: "", title: "", id: ""), super.key});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: note.title);
    final contentController = TextEditingController(text: note.content);
    return Scaffold(
      appBar: AppBar(title: Text('edytuj', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onPrimary)), 
        backgroundColor: Theme.of(context).colorScheme.primary, 
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
        iconTheme: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),),
      body: Padding(padding: EdgeInsets.all(15), child: 
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("created: ${note.createTime.toString()}"),
          Text("last modification: ${note.modifyTime.toString()}"),
          TextField(controller: titleController, decoration: InputDecoration(labelText: "Title"),),
          Expanded(child: TextField(controller: contentController, expands: true, maxLines: null,)),
        ],)
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: ()=>{
          if (isNew){
            ref.read(notesProvider.notifier).addNote(
                  titleController.text,
                  contentController.text)
          } else {
            ref.read(notesProvider.notifier).editNote(
                  note.id,
                  titleController.text,
                  contentController.text)
          },
          Navigator.pop(context)
        },
        child: Icon(Icons.save, color: Theme.of(context).colorScheme.onSecondary,),
      ),
    );
  }

}