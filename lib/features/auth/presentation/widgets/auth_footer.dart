import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_palette.dart';

class AuthFooter extends StatelessWidget {
  const AuthFooter({super.key, required this.isSignUp, required this.onTap});

  final bool isSignUp;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(width * 0.015),
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text:
                    isSignUp
                        ? 'Already have an account?\t'
                        : 'Don\'t have an account?\t',
                style: TextStyle(
                  color: AppPalette.greyColor,
                  fontWeight: FontWeight.w500,
                  fontSize: isPortrait ? width * 0.04 : width * 0.02,
                ),
              ),
              TextSpan(
                recognizer: TapGestureRecognizer()..onTap = onTap,
                text: isSignUp ? 'Login!' : 'Sign up!',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isPortrait ? width * 0.04 : width * 0.02,
                  color: AppPalette.primaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
