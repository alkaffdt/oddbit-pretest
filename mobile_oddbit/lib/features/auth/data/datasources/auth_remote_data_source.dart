import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/features/auth/domain/models/user.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/error/failures.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl(dioClient: ref.watch(dioClientProvider));
});

abstract class AuthRemoteDataSource {
  Future<User> login(String username, String password);
  Future<User> register(String username, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<User> login(String username, String password) async {
    try {
      final response = await dioClient.post(
        '/auth/login',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw const ServerFailure('Invalid credentials');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Server error occurred');
    }
  }

  @override
  Future<User> register(String username, String password) async {
    try {
      final response = await dioClient.post(
        '/auth/register',
        data: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw const ServerFailure('Invalid credentials');
      }
    } on DioException catch (e) {
      throw ServerFailure(e.message ?? 'Server error occurred');
    }
  }
}
