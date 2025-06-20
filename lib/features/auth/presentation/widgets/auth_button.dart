import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
  });
  final VoidCallback onPressed;
  final String buttonName;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPalette.primaryColor,
        elevation: 4,
        overlayColor: AppPalette.primaryColor,
        shadowColor: AppPalette.primaryColor,
        minimumSize: Size(
          width * .9,
          isPortrait ? height * 0.06 : height * 0.15,
        ),
      ),
      child: Text(
        buttonName,
        style: TextStyle(
          fontSize: isPortrait ? width * 0.04 : width * 0.02,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
