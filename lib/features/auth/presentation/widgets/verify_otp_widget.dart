import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/utils/obscure_email.dart';
import 'auth_button.dart';
import 'otp_timer.dart';

class VerifyOtpWidget extends StatelessWidget {
  const VerifyOtpWidget({
    super.key,
    required this.isSignUpVerification,
    required this.onVerifyPressed,
    required this.onResendCodePressed,
    required this.formKey,
    required this.otpController,
  });
  final bool isSignUpVerification;

  final VoidCallback onVerifyPressed;

  final VoidCallback onResendCodePressed;

  final GlobalKey<FormState> formKey;

  final TextEditingController otpController;

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).extra as String? ?? 'your email';
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;

    final defaultPinTheme = PinTheme(
      width: isPortrait ? width * 0.125 : width * 0.06,
      height: isPortrait ? height * 0.06 : height * 0.15,
      textStyle: TextStyle(
        fontSize: isPortrait ? width * 0.05 : width * 0.03,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppPalette.greyOpacityColor,
        border: Border.all(
          width: isPortrait ? width * 0.005 : width * 0.002,
          color: AppPalette.greyColor.withAlpha(100),
        ),
        borderRadius: BorderRadius.circular(
          isPortrait ? width * 0.04 : width * 0.02,
        ),
      ),
    );

    final focusedPinTheme = PinTheme(
      width: isPortrait ? width * 0.125 : width * 0.06,
      height: isPortrait ? height * 0.06 : height * 0.15,
      textStyle: TextStyle(
        fontSize: isPortrait ? width * 0.05 : width * 0.03,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: AppPalette.blueOpacityColor,
        border: Border.all(
          width: isPortrait ? width * 0.005 : width * 0.002,
          color: AppPalette.primaryColor,
        ),
        borderRadius: BorderRadius.circular(
          isPortrait ? width * 0.04 : width * 0.02,
        ),
      ),
    );

    final submittedPinTheme = PinTheme(
      width: isPortrait ? width * 0.125 : width * 0.06,
      height: isPortrait ? height * 0.06 : height * 0.15,
      textStyle: TextStyle(fontSize: isPortrait ? width * 0.05 : width * 0.03),
      decoration: BoxDecoration(
        color: AppPalette.blueOpacityColor,
        border: Border.all(
          width: isPortrait ? width * 0.005 : width * 0.002,
          color: AppPalette.primaryColor,
        ),
        borderRadius: BorderRadius.circular(
          isPortrait ? width * 0.04 : width * 0.02,
        ),
      ),
    );

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height * 0.02),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/blue_wave_2x.png',
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.016),
          child: Form(
            key: formKey,
            child: Column(
              spacing: height * 0.024,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                //Text
                Center(
                  child: Text(
                    'OTP has been sent to ${obscureEmail(email)}',
                    style: TextStyle(
                      fontSize: isPortrait ? width * 0.04 : width * 0.02,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                //Pinput
                Pinput(
                  controller: otpController,
                  hapticFeedbackType: HapticFeedbackType.lightImpact,
                  defaultPinTheme: defaultPinTheme,
                  focusedPinTheme: focusedPinTheme,
                  submittedPinTheme: submittedPinTheme,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  pinAnimationType: PinAnimationType.slide,
                  validator: (value) {
                    if (value == null) {
                      return 'OTP is a required field';
                    } else if (value.isEmpty) {
                      return 'OTP is a required field';
                    } else if (value.length < 4) {
                      return 'OTP is a 4 digit pin';
                    }
                    return null;
                  },
                ),
                //Resend code in
                !isSignUpVerification
                    ? OtpTimer(resendCode: onResendCodePressed)
                    : SizedBox.shrink(),
                //Button
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: height * 0.024,
                        bottom: height * 0.032,
                      ),
                      child: AuthButton(
                        onPressed: onVerifyPressed,
                        buttonName: 'Verify',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
