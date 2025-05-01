import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AuthIconButton extends StatelessWidget {
  const AuthIconButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppPalette.greyOpacityColor, width: 2),
        ),
      ),
      icon: icon,
    );
  }
}
