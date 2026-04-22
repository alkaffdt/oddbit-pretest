import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/features/auth/domain/models/auth_state.dart';
import 'package:oddbit_mobile/features/auth/domain/models/submission_status_state.dart';
import 'package:oddbit_mobile/features/auth/domain/models/user_model.dart';

class LoginPageState {
  final AsyncValue<User>? user;
  final AuthStatus authStatus;

  LoginPageState({this.user, this.authStatus = AuthStatus.init});

  LoginPageState copyWith({AsyncValue<User>? user, AuthStatus? authStatus}) {
    return LoginPageState(
      user: user ?? this.user,
      authStatus: authStatus ?? this.authStatus,
    );
  }
}
