import 'package:flutter/material.dart';
import 'package:privateproject/services/auth/auth_service.dart';
import 'package:privateproject/services/cloud/cloud_note.dart';
import 'package:privateproject/services/cloud/firebase_cloud_storage.dart';
import 'package:privateproject/views/notes/notes_list_view.dart';
import '../../constants/route.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialog/logout_dialog.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes'), actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(createUpdateNoteRoute);
            },
            icon: const Icon(Icons.add)),
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                if (shouldLogout) {
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    loginRoute,
                    (_) => false,
                  );
                }
                break;
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem(
                value: MenuAction.logout,
                child: Text("Log out"),
              )
            ];
          },
        )
      ]),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context).pushNamed(
                      createUpdateNoteRoute,
                      arguments: note,
                    );
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
