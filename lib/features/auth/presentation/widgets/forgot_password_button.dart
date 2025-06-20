import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key, required this.onPressed});
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return TextButton(
      style: ElevatedButton.styleFrom(
        overlayColor: AppPalette.greyOpacityColor,
      ),
      onPressed: onPressed,
      child: Text(
        'Forgot your Password?',
        style: TextStyle(
          color: AppPalette.primaryColor,
          fontSize: isPortrait ? width * 0.04 : width * 0.02,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
