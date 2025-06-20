import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../../../../core/routes/app_routes.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          'Forgot Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthForgotPasswordSuccess) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
            showToast(
              context: context,
              type: ToastificationType.success,
              description: state.message,
            );
            context.push(
              AppRoutes.verifyResetOtp,
              extra: emailController.text.trim(),
            );
          } else if (state is AuthForgotPasswordFailure) {
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
          return SafeArea(
            child: Stack(
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
                Form(
                  key: key,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                    ),
                    child: Column(
                      spacing: height * 0.016,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        // Center(
                        //   child: Image.asset(
                        //     'assets/images/locked.png',
                        //   ),
                        // ),
                        // Text
                        Text(
                          'Please enter your email and we will send an OTP code in the next step to reset the password.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: isPortrait ? width * 0.04 : width * 0.02,
                          ),
                        ),
                        //Email field
                        AuthField(
                          textEditingController: emailController,
                          hintText: 'Email',
                          validator: (email) {
                            if (email == null || email.isEmpty) {
                              return 'Email is a required field';
                            } else if (!validator.isEmail(email)) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                          prefixIcon: Icons.email,
                          textInputAction: TextInputAction.go,
                          textInputType: TextInputType.emailAddress,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.024,
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: AuthButton(
                                onPressed: () async {
                                  key.currentState!.validate()
                                      ? context.read<AuthBloc>().add(
                                        AuthForgotPassword(
                                          email: emailController.text.trim(),
                                        ),
                                      )
                                      : null;
                                },
                                buttonName: 'Continue',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
