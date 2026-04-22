import 'package:flutter/material.dart';
import 'package:oddbit_mobile/extensions/text_style_extension.dart';
import 'package:oddbit_mobile/features/notes/domain/entities/note_model.dart';

class NoteCardWidget extends StatelessWidget {
  const NoteCardWidget({super.key, required this.note, required this.onDelete});

  final Note note;
  final void Function(int) onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),

        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(note.title).fontSize(18).bold(),
              ),
            ),
            InkWell(
              onTap: () => onDelete(note.id),
              child: Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
        subtitle: Text(note.content),
      ),
    );
  }
}
