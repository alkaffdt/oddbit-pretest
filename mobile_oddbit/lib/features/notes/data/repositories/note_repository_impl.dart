import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/note_model.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_data_source.dart';

final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return NoteRepositoryImpl(
    remoteDataSource: ref.watch(noteRemoteDataSourceProvider),
  );
});

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;

  NoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Note>> getNotes() async {
    return await remoteDataSource.fetchNotes();
  }

  @override
  Future<Note> addNote(String title, String content) async {
    return await remoteDataSource.createNote(title, content);
  }

  @override
  Future<void> deleteNote(int id) async {
    await remoteDataSource.deleteNote(id);
  }
}
