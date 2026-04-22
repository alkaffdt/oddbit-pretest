import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/secure_storage.dart';
import '../models/user_model.dart';
import '../../../../core/error/failures.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(secureStorage: ref.watch(secureStorageProvider));
});

abstract class AuthLocalDataSource {
  Future<void> cacheUser(UserModel userToCache);
  Future<UserModel?> getLastUser();
  Future<void> clearUser();
}

const cachedUserKey = 'CACHED_USER';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> cacheUser(UserModel userToCache) async {
    await secureStorage.writeData(
      cachedUserKey,
      json.encode(userToCache.toJson()),
    );
  }

  @override
  Future<UserModel?> getLastUser() async {
    try {
      final jsonString = await secureStorage.readData(cachedUserKey);
      if (jsonString != null) {
        return UserModel.fromJson(json.decode(jsonString));
      } else {
        return null;
      }
    } catch (_) {
      throw const CacheFailure('Failed to load user from cache');
    }
  }

  @override
  Future<void> clearUser() async {
    await secureStorage.deleteData(cachedUserKey);
  }
}
