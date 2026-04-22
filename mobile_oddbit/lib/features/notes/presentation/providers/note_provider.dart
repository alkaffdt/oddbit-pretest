import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/features/notes/domain/repositories/note_repository.dart';
import '../../domain/entities/note_model.dart';
import '../../data/repositories/note_repository_impl.dart';

final notesControllerProvider =
    AsyncNotifierProvider<NotesController, List<Note>>(NotesController.new);

class NotesController extends AsyncNotifier<List<Note>> {
  late NoteRepository noteRepository;

  @override
  FutureOr<List<Note>> build() async {
    noteRepository = ref.read(noteRepositoryProvider);
    return _fetchNotes();
  }

  Future<List<Note>> _fetchNotes() async {
    try {
      final notes = await noteRepository.getNotes();
      return notes;
    } catch (error) {
      return [];
    }
  }

  Future<void> loadNotes() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _fetchNotes());
  }

  Future<void> addNote(String title, String content) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() async {
      await ref.read(noteRepositoryProvider).addNote(title, content);
      return await _fetchNotes();
    }).then((newValue) {
      if (newValue.hasValue && newValue.value != null) {
        state = AsyncValue.data(newValue.value!);
      } else {
        state = newValue;
      }
    });
  }

  Future<void> editNote(int id, String title, String content) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() async {
      await ref.read(noteRepositoryProvider).editNote(id, title, content);
      return await _fetchNotes();
    }).then((newValue) {
      if (newValue.hasValue && newValue.value != null) {
        state = AsyncValue.data(newValue.value!);
      } else {
        state = newValue;
      }
    });
  }

  Future<void> deleteNote(int id) async {
    state = const AsyncValue.loading();
    await AsyncValue.guard(() async {
      await ref.read(noteRepositoryProvider).deleteNote(id);
      return await _fetchNotes();
    }).then((newValue) {
      if (newValue.hasValue && newValue.value != null) {
        state = AsyncValue.data(newValue.value!);
      } else {
        state = newValue;
      }
    });
  }
}
