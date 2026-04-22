import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/extensions/int_extensions.dart';
import 'package:oddbit_mobile/extensions/navigation_extension.dart';
import 'package:oddbit_mobile/features/notes/domain/entities/note_model.dart';
import 'package:oddbit_mobile/features/notes/presentation/providers/note_provider.dart';
import 'package:oddbit_mobile/theme/app_colors.dart';

class AddNewNoteForm extends ConsumerWidget {
  AddNewNoteForm({super.key, this.note});

  final Note? note;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future.microtask(() {
      if (note != null) {
        _titleController.text = note!.title;
        _contentController.text = note!.content;
      }
    });

    return Column(
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
        24.toHeightGap(),
        Row(
          children: [
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.secondary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (_titleController.text.isNotEmpty &&
                      _contentController.text.isNotEmpty) {
                    if (note != null) {
                      ref
                          .read(notesControllerProvider.notifier)
                          .editNote(
                            note!.id,
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
            ),
          ],
        ),
      ],
    );
  }
}
