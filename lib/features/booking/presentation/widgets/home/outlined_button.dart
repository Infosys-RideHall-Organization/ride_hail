import 'package:flutter/material.dart';

import '../../../../../core/theme/app_palette.dart';

class CustomOutlinedButton extends StatelessWidget {
  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.buttonName,
    this.isLoading = false,
  });
  final VoidCallback? onPressed;
  final String buttonName;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return ElevatedButton(
      onPressed: onPressed,
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
      child: Text(
        isLoading ? 'Loading...' : buttonName,
        style: TextStyle(
          fontSize: isPortrait ? width * 0.04 : width * 0.02,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
