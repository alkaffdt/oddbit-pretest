import 'package:oddbit_mobile/features/notes/domain/entities/note_model.dart';

abstract class NoteRepository {
  Future<List<Note>> getNotes();
  Future<Note> addNote(String title, String content);
  Future<void> deleteNote(int id);
}
