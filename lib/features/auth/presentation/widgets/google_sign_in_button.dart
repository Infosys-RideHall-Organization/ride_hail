import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class GoogleSignInButton extends StatelessWidget {
  final VoidCallback onPressed;

  const GoogleSignInButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: Size(
          width * .9,
          isPortrait ? height * 0.06 : height * 0.15,
        ),
        backgroundColor:
            isDark ? AppPalette.darkBackgroundColor : AppPalette.whiteColor,
        foregroundColor:
            isDark ? AppPalette.whiteColor : AppPalette.darkBackgroundColor,
        side: BorderSide(
          color:
              isDark ? AppPalette.whiteColor : AppPalette.darkBackgroundColor,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      onPressed: onPressed,
      child: Row(
        spacing: 16.0,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/google-logo-48.png', height: 32),
          Text('Continue With Google', style: TextStyle(fontSize: 16.0)),
        ],
      ),
    );
  }
}
