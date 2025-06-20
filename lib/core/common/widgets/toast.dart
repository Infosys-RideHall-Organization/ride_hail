import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../theme/cubit/theme_cubit.dart';

final Map<ToastificationType, String> toastTitles = {
  ToastificationType.success: 'Success',
  ToastificationType.error: 'Error',
  ToastificationType.warning: 'Warning',
  ToastificationType.info: 'Info',
};

ToastificationItem showToast({
  required BuildContext context,
  required ToastificationType type,
  required String description,
}) {
  final isDarkMode =
      context.read<ThemeCubit>().state.appTheme == AppThemeMode.dark;

  return toastification.show(
    type: type,
    style: ToastificationStyle.fillColored,
    autoCloseDuration: const Duration(seconds: 5),
    alignment: Alignment.topCenter,
    direction: TextDirection.ltr,
    animationDuration: const Duration(milliseconds: 300),
    showIcon: true,
    showProgressBar: true,
    closeOnClick: false,
    pauseOnHover: true,
    dragToClose: true,

    primaryColor: isDarkMode ? Colors.grey[900]! : Colors.white,
    foregroundColor: isDarkMode ? Colors.white : Colors.black,
    backgroundColor: isDarkMode ? Colors.grey[850]! : Colors.grey[100]!,

    progressBarTheme: ProgressIndicatorThemeData(
      color: _getToastColor(type),
      circularTrackColor: isDarkMode ? Colors.grey[700] : Colors.grey[300],
    ),

    // Text Content
    title: Text(
      toastTitles[type] ?? 'Notification',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
      ),
    ),
    description: RichText(
      text: TextSpan(
        text: description,
        style: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black87),
      ),
    ),

    // Icon Based on Type
    icon: Icon(_getToastIcon(type), color: _getToastColor(type)),

    // Styling
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    borderRadius: BorderRadius.circular(12),
  );
}

// Function to get icon based on Toast type
IconData _getToastIcon(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return Icons.check_circle;
    case ToastificationType.error:
      return Icons.error;
    case ToastificationType.warning:
      return Icons.warning;
    case ToastificationType.info:
      return Icons.info;
  }
}

// Function to get color based on Toast type
Color _getToastColor(ToastificationType type) {
  switch (type) {
    case ToastificationType.success:
      return Colors.greenAccent;
    case ToastificationType.error:
      return Colors.redAccent;
    case ToastificationType.warning:
      return Colors.amberAccent;
    case ToastificationType.info:
      return Colors.blueAccent;
  }
}
