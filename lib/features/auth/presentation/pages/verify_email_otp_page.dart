import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_hail/core/routes/app_routes.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/verify_otp_widget.dart';

class VerifyEmailOtpPage extends StatefulWidget {
  const VerifyEmailOtpPage({super.key});

  @override
  State<VerifyEmailOtpPage> createState() => _VerifyEmailOtpPageState();
}

class _VerifyEmailOtpPageState extends State<VerifyEmailOtpPage> {
  final formKey = GlobalKey<FormState>();

  final verificationTokenController = TextEditingController();

  @override
  void dispose() {
    verificationTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verify Email OTP',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthEmailVerificationSuccess) {
            // ScaffoldMessenger.of(context).showSnackBar(
            //   SnackBar(content: Text(state.user.isVerified.toString())),
            // );
            showToast(
              context: context,
              type: ToastificationType.success,
              description: 'Email Verification Successful!',
            );
            // go to lock
            context.go(AppRoutes.signIn);
          } else if (state is AuthEmailVerificationFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
            showToast(
              context: context,
              type: ToastificationType.error,
              description: state.message,
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoadingIndicator();
          }
          return VerifyOtpWidget(
            otpController: verificationTokenController,
            isSignUpVerification: true,
            onVerifyPressed: () {
              formKey.currentState!.validate()
                  ? context.read<AuthBloc>().add(
                    AuthEmailVerification(
                      verificationToken:
                          verificationTokenController.text.trim(),
                    ),
                  )
                  : null;
            },
            onResendCodePressed: () {},
            formKey: formKey,
          );
        },
      ),
    );
  }
}
