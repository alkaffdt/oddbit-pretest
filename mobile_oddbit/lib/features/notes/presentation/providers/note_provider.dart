import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/note_model.dart';
import '../../domain/usecases/get_notes_usecase.dart';
import '../../data/repositories/note_repository_impl.dart';
import '../../../../core/usecases/usecase.dart';

final notesControllerProvider =
    AsyncNotifierProvider<NotesController, List<Note>>(NotesController.new);

class NotesController extends AsyncNotifier<List<Note>> {
  @override
  FutureOr<List<Note>> build() async {
    return await _fetchNotes();
  }

  Future<List<Note>> _fetchNotes() async {
    final getNotesUseCase = GetNotesUseCase(ref.read(noteRepositoryProvider));
    return await getNotesUseCase(NoParams());
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
