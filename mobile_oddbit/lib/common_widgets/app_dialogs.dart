import 'package:flutter/material.dart';
import 'package:oddbit_mobile/core/error/failures.dart';
import 'package:oddbit_mobile/extensions/int_extensions.dart';
import 'package:oddbit_mobile/extensions/navigation_extension.dart';
import 'package:oddbit_mobile/extensions/string_extension.dart';
import 'package:oddbit_mobile/extensions/text_style_extension.dart';
import 'package:oddbit_mobile/theme/app_colors.dart';

class AppDialog {
  static BuildContext? _dialogContext;

  static void showLoadingDialog(
    BuildContext localContext, {
    String message = 'Please Wait...',
  }) {
    showDialog(
      context: localContext,
      barrierDismissible: true,
      builder: (context) {
        _dialogContext = context;
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          contentPadding: EdgeInsets.zero,
          content: Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const CircularProgressIndicator.adaptive(),
            ),
          ),
        );
      },
    );
  }

  static void dismissDialog() {
    if (_dialogContext != null) {
      Navigator.of(_dialogContext!).pop();
      _dialogContext = null;
    }
  }

  static void showSuccessDialog(
    BuildContext context, {
    String? message,
    VoidCallback? onTapped,
    bool barrierDismissible = false,
  }) {
    // auto-pop after
    Future.delayed(const Duration(seconds: 1), () {
      if (Navigator.canPop(context)) {
        context.pop();
        onTapped?.call();
      }
    });

    showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.check_circle,
                  color: AppColors.green1,
                  size: 111,
                ),
                16.toHeightGap(),
                Text(message ?? 'Success').fontSize(18).mediumWeight(),
              ],
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: onTapped != null
              ? [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 25,
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        onTapped.call();
                      },
                      child: const Text('OK'),
                    ),
                  ),
                ]
              : null,
        );
      },
    );
  }

  static void showErrorDialog(
    BuildContext context, {
    String? message,
    VoidCallback? onTapped,
    Widget? title,
    String? titleText,
  }) {
    if (!message.isNotNullAndNotEmpty) {
      message = 'An error occurred';
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.warning, size: 115, color: AppColors.orange1),
                8.toHeightGap(),
                title ??
                    Text(titleText ?? 'Sorry')
                        .center()
                        .mediumWeight()
                        .fontSize(22)
                        .textColor(AppColors.orange1),
                8.toHeightGap(),
                Text(message ?? Failure.defaultMessage).fontSize(14),
                32.toHeightGap(),
                SizedBox(
                  width: double.maxFinite,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onTapped?.call();
                    },
                    child: const Text('OK'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
