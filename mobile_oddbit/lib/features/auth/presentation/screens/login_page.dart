import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oddbit_mobile/common_widgets/app_dialogs.dart';
import 'package:oddbit_mobile/extensions/int_extensions.dart';
import 'package:oddbit_mobile/extensions/navigation_extension.dart';
import 'package:oddbit_mobile/extensions/text_style_extension.dart';
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
  final _confirmPasswordController = TextEditingController();

  bool isRegister = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
      body: _buildForm(),
    );
  }

  Widget _buildForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Username'),
            keyboardType: TextInputType.text,
            onChanged: (value) {
              setState(() {});
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _passwordController,
            decoration: const InputDecoration(labelText: 'Password'),
            obscureText: true,
            onChanged: (value) {
              setState(() {});
            },
          ),
          if (isRegister) ...[
            16.toHeightGap(),
            TextField(
              controller: _confirmPasswordController,
              decoration: const InputDecoration(labelText: 'Confirm Password'),
              obscureText: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
          ],
          14.toHeightGap(),
          _buildLoginOrRegisterButton(),
          14.toHeightGap(),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.textButtonColor,
              ),
              onPressed: isValidated
                  ? () {
                      ref
                          .read(authControllerProvider.notifier)
                          .submitAuth(
                            _emailController.text,
                            _passwordController.text,
                            isRegister: isRegister,
                          );
                    }
                  : null,
              child: Text(isRegister ? 'Register' : 'Login'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoginOrRegisterButton() {
    final loginButtonText = 'Login here';
    final registerButtonText = 'Don\'t have an account? Register here';

    return TextButton(
      onPressed: () {
        setState(() {
          isRegister = !isRegister;
        });

        _confirmPasswordController.clear();
        FocusScope.of(context).unfocus();
      },
      child: Text(
        isRegister ? loginButtonText : registerButtonText,
      ).textColor(AppColors.primary).fontWeight(FontWeight.bold).fontSize(12),
    );
  }

  bool get isValidated {
    if (isRegister) {
      return _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _passwordController.text == _confirmPasswordController.text;
    }

    return _emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty;
  }
}
