import '../../../../core/usecases/usecase.dart';
import '../entities/note_model.dart';
import '../repositories/note_repository.dart';

class GetNotesUseCase implements UseCase<List<Note>, NoParams> {
  final NoteRepository repository;

  GetNotesUseCase(this.repository);

  @override
  Future<List<Note>> call(NoParams params) async {
    return await repository.getNotes();
  }
}
