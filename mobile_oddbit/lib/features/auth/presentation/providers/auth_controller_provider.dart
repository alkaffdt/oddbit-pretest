import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/core/network/dio_client.dart';
import 'package:oddbit_mobile/extensions/string_extension.dart';
import 'package:oddbit_mobile/features/auth/domain/models/submission_status_state.dart';
import 'package:oddbit_mobile/features/auth/domain/repositories/auth_repository.dart';
import '../../domain/models/user.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/models/auth_state.dart';
import '../../data/models/login_page_state.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, LoginPageState>(
      (ref) => AuthController(
        ref.watch(authRepositoryProvider),
        dioClient: ref.watch(dioClientProvider),
      ),
    );

class AuthController extends StateNotifier<LoginPageState> {
  final AuthRepository _authRepository;
  final DioClient dioClient;

  AuthController(this._authRepository, {required this.dioClient})
    : super(LoginPageState());

  Future<void> submitAuth(
    String email,
    String password, {
    bool isRegister = false,
  }) async {
    try {
      state = state.copyWith(user: AsyncValue.loading());

      final result = isRegister
          ? await _authRepository.register(email, password)
          : await _authRepository.login(email, password);

      if (result.accessToken.isNotNullAndNotEmpty) {
        dioClient.setAuthToken(result.accessToken);

        state = state.copyWith(
          user: AsyncValue.data(
            User(
              username: result.username,
              accessToken: result.accessToken,
              refreshToken: result.refreshToken,
            ),
          ),
          authStatus: AuthStatus.authenticated,
        );
      } else {
        state = state.copyWith(
          user: AsyncValue.error('Login failed', StackTrace.current),
        );
      }
    } catch (e) {
      state = state.copyWith(
        user: AsyncValue.error(e.toString(), StackTrace.current),
      );
    }
  }

  Future<void> logout() async {
    state = state.copyWith(user: null);
    _authRepository.logout();
  }
}
