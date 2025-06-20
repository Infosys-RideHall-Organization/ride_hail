import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../../../../core/routes/app_routes.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/verify_otp_widget.dart';

class VerifyResetOtpPage extends StatefulWidget {
  const VerifyResetOtpPage({super.key});

  @override
  State<VerifyResetOtpPage> createState() => _VerifyResetOtpPageState();
}

class _VerifyResetOtpPageState extends State<VerifyResetOtpPage> {
  final formKey = GlobalKey<FormState>();

  final resetTokenController = TextEditingController();

  @override
  void dispose() {
    resetTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).extra as String?;
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthResetPasswordVerificationSuccess) {
          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text(state.message)));
          showToast(
            context: context,
            type: ToastificationType.success,
            description: state.message,
          );
          final resetPasswordToken = resetTokenController.text.trim();
          context.go(AppRoutes.resetPassword, extra: resetPasswordToken);
        } else if (state is AuthResetPasswordVerificationFailure) {
          // ScaffoldMessenger.of(
          //   context,
          // ).showSnackBar(SnackBar(content: Text(state.error)));
          showToast(
              context: context,
              type: ToastificationType.error, description: state.error);
        }
      },
      builder: (context, state) {
        if (state is AuthLoading) {
          return CustomLoadingIndicator();
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Forgot Password',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          resizeToAvoidBottomInset: false,
          body: VerifyOtpWidget(
            isSignUpVerification: false,
            onVerifyPressed: () {
              formKey.currentState!.validate()
                  ? context.read<AuthBloc>().add(
                    AuthResetPasswordVerification(
                      resetPasswordToken: resetTokenController.text.trim(),
                    ),
                  )
                  : null;
            },
            onResendCodePressed: () {
              context.read<AuthBloc>().add(AuthForgotPassword(email: email!));
            },
            formKey: formKey,
            otpController: resetTokenController,
          ),
        );
      },
    );
  }
}
