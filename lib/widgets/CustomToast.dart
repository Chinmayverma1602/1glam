import 'package:flutter/material.dart';
import 'package:glam1/constants/AppColors.dart';
import 'package:google_fonts/google_fonts.dart';

enum ToastType { success, error, info, warning }

class CustomToast {
  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onDismiss,
    bool showIcon = true,
    double? width,
  }) {
    // Get the ScaffoldMessenger
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Dismiss any existing SnackBars
    scaffoldMessenger.hideCurrentSnackBar();

    // Configure based on type
    Color backgroundColor;
    Color textColor = Colors.white;
    IconData iconData;

    switch (type) {
      case ToastType.success:
        backgroundColor = Colors.green;
        iconData = Icons.check_circle_outline;
        break;
      case ToastType.error:
        backgroundColor = Colors.red;
        iconData = Icons.error_outline;
        break;
      case ToastType.warning:
        backgroundColor = Colors.orange;
        iconData = Icons.warning_amber_outlined;
        break;
      case ToastType.info:
      default:
        backgroundColor = AppColors.primary;
        iconData = Icons.info_outline;
        break;
    }

    final snackBar = SnackBar(
      content: Container(
        width: width,
        child: Row(
          children: [
            if (showIcon) ...[
              Icon(
                iconData,
                color: textColor,
                size: 24,
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.poppins(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      duration: duration,
      dismissDirection: DismissDirection.horizontal,
      onVisible: () {
        if (duration != Duration.zero) {
          Future.delayed(duration, () {
            if (onDismiss != null) onDismiss();
          });
        }
      },
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  // Helper methods for specific toast types
  static void showSuccess(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: ToastType.success,
      duration: duration,
      onDismiss: onDismiss,
    );
  }

  static void showError(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: ToastType.error,
      duration: duration,
      onDismiss: onDismiss,
    );
  }

  static void showInfo(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: ToastType.info,
      duration: duration,
      onDismiss: onDismiss,
    );
  }

  static void showWarning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    VoidCallback? onDismiss,
  }) {
    show(
      context,
      message: message,
      type: ToastType.warning,
      duration: duration,
      onDismiss: onDismiss,
    );
  }
}
