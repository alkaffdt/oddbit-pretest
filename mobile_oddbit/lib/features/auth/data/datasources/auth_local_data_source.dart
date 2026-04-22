import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/features/auth/domain/models/user_model.dart';

import '../../../../core/storage/secure_storage.dart';
import '../../../../core/error/failures.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  return AuthLocalDataSourceImpl(
    secureStorage: ref.watch(secureStorageProvider),
  );
});

abstract class AuthLocalDataSource {
  Future<void> saveRefreshToken(String refreshToken);
  Future<String?> getRefreshToken();
  Future<void> clearUser();
}

const refreshTokenKey = 'REFRESH_TOKEN';

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SecureStorage secureStorage;

  AuthLocalDataSourceImpl({required this.secureStorage});

  @override
  Future<void> saveRefreshToken(String refreshToken) async {
    await secureStorage.writeData(refreshTokenKey, refreshToken);
  }

  @override
  Future<String?> getRefreshToken() async {
    try {
      final jsonString = await secureStorage.readData(refreshTokenKey);
      if (jsonString != null) {
        return jsonString;
      } else {
        return null;
      }
    } catch (_) {
      throw const CacheFailure('Failed to load user from cache');
    }
  }

  @override
  Future<void> clearUser() async {
    await secureStorage.deleteData(refreshTokenKey);
  }
}
