import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:privateproject/services/cloud/cloud_note.dart';
import 'package:privateproject/services/cloud/cloud_storage_constants.dart';
import 'package:privateproject/services/cloud/cloud_storage_exception.dart';

class FirebaseCloudStorage {
  final notes = FirebaseFirestore.instance.collection('notes');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudNote> createNewNote({
    required String ownerUserId,
  }) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldIdName: '',
    });
    final fetchNote = await document.get();
    return CloudNote(
      documentId: fetchNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  Future<void> deleteNote({
    required String documentId,
  }) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({textFieldIdName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({
    required String ownerUserId,
  }) {
    return notes.snapshots().map(
          (event) => event.docs
              .map((doc) => CloudNote.fromSnapshot(doc))
              .where((notes) => notes.ownerUserId == ownerUserId),
        );
  }

  Future<Iterable<CloudNote>> getNotes({
    required String ownerUserId,
  }) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (note) => note.docs.map(
              (doc) => CloudNote.fromSnapshot(doc),
            ),
          );
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }
}
