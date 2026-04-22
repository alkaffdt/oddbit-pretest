import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/extensions/int_extensions.dart';
import 'package:oddbit_mobile/extensions/navigation_extension.dart';
import 'package:oddbit_mobile/features/auth/presentation/providers/auth_controller_provider.dart';
import 'package:oddbit_mobile/features/auth/presentation/screens/login_page.dart';
import 'package:oddbit_mobile/features/notes/domain/entities/note_model.dart';
import 'package:oddbit_mobile/features/notes/presentation/providers/note_provider.dart';
import 'package:oddbit_mobile/features/notes/presentation/widgets/note_card_widget.dart';

class NotesPage extends ConsumerStatefulWidget {
  const NotesPage({super.key});

  @override
  ConsumerState<NotesPage> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesPage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _showAddNoteDialog({Note? note}) {
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                minLines: 1,
                maxLines: 10,
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty &&
                    _contentController.text.isNotEmpty) {
                  if (note != null) {
                    ref
                        .read(notesControllerProvider.notifier)
                        .editNote(
                          note.id,
                          _titleController.text,
                          _contentController.text,
                        );
                  } else {
                    ref
                        .read(notesControllerProvider.notifier)
                        .addNote(
                          _titleController.text,
                          _contentController.text,
                        );
                  }

                  _titleController.clear();
                  _contentController.clear();

                  // close dialog
                  context.pop();
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final notesState = ref.watch(notesControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
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
