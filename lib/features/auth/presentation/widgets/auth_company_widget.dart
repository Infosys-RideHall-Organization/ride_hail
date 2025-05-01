import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'auth_icon_button.dart';

class AuthCompanyWidget extends StatelessWidget {
  const AuthCompanyWidget({
    super.key,
    required this.appleLogin,
    required this.googleLogin,
    required this.facebookLogin,
  });

  final VoidCallback appleLogin;
  final VoidCallback googleLogin;
  final VoidCallback facebookLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Wrap(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 24.0,
          children: [
            AuthIconButton(
              onPressed: googleLogin,
              icon: SvgPicture.asset(
                'assets/images/google.svg',
                fit: BoxFit.cover,
                height: 36,
              ),
            ),
            AuthIconButton(
              onPressed: appleLogin,
              icon: SvgPicture.asset(
                'assets/images/apple.svg',
                fit: BoxFit.cover,
                height: 36,
              ),
            ),
            AuthIconButton(
              onPressed: facebookLogin,
              icon: SvgPicture.asset(
                'assets/images/facebook.svg',
                fit: BoxFit.cover,
                height: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
