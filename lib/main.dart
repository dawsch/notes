import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notatnik/features/notes/presentation/pages/editNote.dart';
import 'package:notatnik/features/notes/presentation/notifiers/notesNotifier.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:notatnik/features/themeModes/themeProvider.dart';
import 'package:notatnik/core/themeModes.dart';


void main() {
  if (!Platform.isIOS && !Platform.isAndroid){
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
 

  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeLoader = ref.watch(themeModeLoaderProvider);

    return themeLoader.when(
      loading: () => CircularProgressIndicator(),
      error: (e, s) => MaterialApp(home: Scaffold(body: Center(child: Text('Błąd ładowania')))),
      data: (_) {
        final themeMode = ref.watch(themeModeProvider);
        return MaterialApp(
          title: 'Notatnik',
          theme: lightMode,
          darkTheme: darkMode,
          themeMode: themeMode,
          home: NotesPage(),
        );
      },
    );
  }
}

class NotesPage extends ConsumerWidget{
  SharedPreferences? prefs;
  bool? isDarkMode;

  NotesPage({super.key})
  {
    initializeSheardPrefs();
  }
  void initializeSheardPrefs() async {

    prefs = await SharedPreferences.getInstance();
    
  }
  

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesNotifierProvider);
    isDarkMode = ref.watch(themeModeProvider) == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Notatnik', 
          style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onSecondary)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        actions: [
          Row(
            children: [
              Icon(Icons.light_mode, color: Theme.of(context).colorScheme.onPrimary,),
              Switch(
                value: isDarkMode ?? false,
                onChanged: (value) async {
                  ref.read(themeModeProvider.notifier).state =
                      value ? ThemeMode.dark : ThemeMode.light;
                  final prefs = await SharedPreferences.getInstance();
                  prefs.setBool("isDarkMode", value);
                },
              ),
              Icon(Icons.dark_mode, color: Theme.of(context).colorScheme.onPrimary,),
              const SizedBox(width: 8),
            ],
        ),
        ],
      ),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes[index];
          return ListTile(
            title: Text(note.title),
            subtitle: Text(note.modifyTime.toString()),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                ref.read(notesNotifierProvider.notifier).removeNote(note.id);
              },
            ),
            //onTap: () => _editNoteDialog(context, ref, note),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotePage(false, note: note))),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        shape: CircleBorder(),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditNotePage(true))),
        child: Icon(Icons.add, color: Theme.of(context).colorScheme.onSecondary,),
      ),
    );
  }
}
