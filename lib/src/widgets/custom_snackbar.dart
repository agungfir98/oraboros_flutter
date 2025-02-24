import 'package:flutter/material.dart';

enum SnackBarType { success, error, warning, info }

class CustomSnackBar extends SnackBar {
  CustomSnackBar({
    super.key,
    required BuildContext context,
    SnackBarType type = SnackBarType.info,
    Widget? content,
    Duration duration = const Duration(seconds: 4),
  }) : super(
          width: MediaQuery.of(context).size.width * 0.8,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          dismissDirection: DismissDirection.horizontal,
          elevation: 0,
          duration: duration,
          content: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  width: 2,
                  color: Theme.of(context).colorScheme.outline,
                ),
                color: _setColor(context, type)),
            child: content,
          ),
        );

  static _setColor(BuildContext context, SnackBarType type) {
    ColorScheme colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case SnackBarType.success:
        return colorScheme.primary;
      case SnackBarType.error:
        return Colors.red[500];
      case SnackBarType.warning:
        return Colors.yellow[500];
      case SnackBarType.info:
        return Colors.white;
      default:
        return colorScheme.primary;
    }
  }
}
