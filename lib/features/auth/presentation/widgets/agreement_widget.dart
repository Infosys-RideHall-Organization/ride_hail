import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:ride_hail/features/auth/presentation/widgets/terms_and_conditions_dialog.dart';

import '../../../../core/theme/app_palette.dart';

class AgreementWidget extends StatelessWidget {
  const AgreementWidget({
    super.key,
    required this.value,
    required this.onAgreed,
    required this.onChanged,
  });
  final bool value;
  final VoidCallback onAgreed;

  final void Function(bool? value) onChanged;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          checkColor: AppPalette.whiteColor,
          activeColor: AppPalette.primaryColor,
          side: BorderSide(
            width: isPortrait ? width * 0.04 : width * 0.022,
            color: AppPalette.primaryColor,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2)),
          onChanged: onChanged,
        ),
        Text.rich(
          TextSpan(
            style: TextStyle(
              fontSize: isPortrait ? width * 0.04 : width * 0.02,
            ),
            children: [
              TextSpan(text: 'I agree to the\t'),
              TextSpan(
                text: 'Terms & Conditions.',
                recognizer:
                    TapGestureRecognizer()
                      ..onTap = () {
                        showTermsAndConditionsDialog(
                          context: context,
                          onAgreed: onAgreed,
                        );
                      },
                style: TextStyle(
                  color: AppPalette.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
