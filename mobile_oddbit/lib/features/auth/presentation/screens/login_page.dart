import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/common_widgets/app_dialogs.dart';
import 'package:oddbit_mobile/extensions/navigation_extension.dart';
import 'package:oddbit_mobile/features/auth/domain/models/auth_state.dart';
import 'package:oddbit_mobile/features/auth/presentation/providers/auth_controller_provider.dart';
import 'package:oddbit_mobile/features/notes/presentation/screens/notes_page.dart';
import 'package:oddbit_mobile/theme/app_colors.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool isRegister = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.authStatus == AuthStatus.authenticated) {
        // close loading dialog
        context.pop();

        // Navigate to notes page
        context.push(NotesPage());
        return;
      }

      if (next.user?.isLoading == true) {
        AppDialog.showLoadingDialog(context);
      } else if (next.user?.hasError ?? false) {
        // dismiss loading dialog
        context.pop();

        AppDialog.showErrorDialog(
          context,
          message: next.user!.error.toString(),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: _buildLoginForm(),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Username'),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textButtonColor,
              ),
              onPressed: () {
                ref
                    .read(authControllerProvider.notifier)
                    .login(_emailController.text, _passwordController.text);
              },
              child: const Text('Login'),
            ),
          ),
        ],
      ),
    );
  }
}
