import 'package:circle/repositories/notes_repository.dart';
import 'package:circle/widget/home_screen_widgets/note_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Consumer<NotesRepository>(
        builder: (context, ref, child) {
          return Padding(
            // Adding a bottom padding to
            // get the list items above the button
            padding: const EdgeInsets.only(bottom: 50),
            child: ref.getFavoriteNotes.length != 0
                ? ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: ref.getFavoriteNotes.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.only(
                            top: 15,
                            // Checking for the last item of the list
                            // adding padding (15) only to the last item on the list
                            bottom: index != ref.getFavoriteNotes.length - 1
                                ? 0
                                : 15),
                        child: NoteWidget(note: ref.getFavoriteNotes[index]),
                      );
                    },
                  )
                : Center(
                    child: Text('Favorite list is empty...'),
                  ),
          );
        },
      ),
    );
  }
}