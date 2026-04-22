import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/extensions/int_extensions.dart';
import 'package:oddbit_mobile/extensions/navigation_extension.dart';
import 'package:oddbit_mobile/extensions/text_style_extension.dart';
import 'package:oddbit_mobile/features/auth/presentation/providers/auth_controller_provider.dart';
import 'package:oddbit_mobile/features/auth/presentation/screens/login_page.dart';
import 'package:oddbit_mobile/features/notes/domain/entities/note_model.dart';
import 'package:oddbit_mobile/features/notes/presentation/providers/note_provider.dart';
import 'package:oddbit_mobile/features/notes/presentation/widgets/add_new_note_form.dart';
import 'package:oddbit_mobile/features/notes/presentation/widgets/note_card_widget.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesPage> {
  void _showAddNoteDialog({Note? note}) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: AddNewNoteForm(note: note),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('My Notes').bold(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () => ref
                .read(authControllerProvider.notifier)
                .logout()
                .whenComplete(() {
                  ref.invalidate(notesControllerProvider);
                  if (context.mounted) {
                    context.pushReplacement(LoginPage());
                  }
                }),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: notesState.when(
          data: (notes) {
            if (notes.isEmpty) {
              return const Center(child: Text('No notes found.'));
            }
            return RefreshIndicator(
              onRefresh: () =>
                  ref.read(notesControllerProvider.notifier).loadNotes(),
              child: ListView.separated(
                separatorBuilder: (context, index) => 8.toHeightGap(),
                itemCount: notes.length,
                padding: const EdgeInsets.only(bottom: 100),
                itemBuilder: (context, index) {
                  final note = notes[index];

                  return NoteCardWidget(
                    note: note,
                    onDelete: (noteId) {
                      ref
                          .read(notesControllerProvider.notifier)
                          .deleteNote(noteId);
                    },
                    onEdit: (note) {
                      _showAddNoteDialog(note: note);
                    },
                  );
                },
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error: $error',
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddNoteDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
