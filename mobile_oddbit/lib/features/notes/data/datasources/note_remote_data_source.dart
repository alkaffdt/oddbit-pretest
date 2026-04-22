import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/dio_client.dart';
import '../../domain/entities/note_model.dart';
import '../../../../core/error/failures.dart';

final noteRemoteDataSourceProvider = Provider<NoteRemoteDataSource>((ref) {
  return NoteRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

abstract class NoteRemoteDataSource {
  Future<List<Note>> fetchNotes();
  Future<Note> createNote(String title, String content);
  Future<void> deleteNote(int id);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final DioClient dioClient;

  NoteRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<Note>> fetchNotes() async {
    try {
      final response = await dioClient.get('/notes');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Note.fromJson(json)).toList();
      } else {
        throw const ServerFailure('Failed to fetch notes');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Server error occurred');
    }
  }

  @override
  Future<Note> createNote(String title, String content) async {
    try {
      final response = await dioClient.post(
        '/notes',
        data: {'title': title, 'content': content},
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        return Note.fromJson(response.data);
      } else {
        throw const ServerFailure('Failed to create note');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Server error occurred');
    }
  }

  @override
  Future<void> deleteNote(int id) async {
    try {
      final response = await dioClient.delete('/notes/$id');
      if (response.statusCode != 200) {
        throw const ServerFailure('Failed to delete note');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Server error occurred');
    }
  }
}
