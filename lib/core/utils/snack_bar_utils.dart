import 'package:flutter/material.dart';
import 'package:subs_track/widgets/snack_bar/fade_snack_bar.dart';

/// 스낵바 공통 유틸리티
class SnackBarUtils {
  SnackBarUtils._internal();

  static void show({
    required BuildContext context,
    required String message,
    Duration duration = const Duration(seconds: 3),
    Duration fadeDuration = const Duration(milliseconds: 300),
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        FadeSnackBar(
          text: message,
          duration: duration,
          fadeDuration: fadeDuration,
          behavior: behavior,
        ),
      );
  }
}
