import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_hail/core/common/widgets/custom_elevated_button.dart';
import 'package:ride_hail/core/common/widgets/text_form_field.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../../../../core/theme/app_palette.dart';
import '../../../auth/presentation/blocs/auth_bloc/auth_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final key = GlobalKey<FormState>();

  @override
  void dispose() {
    passwordController.dispose();
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
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthResetPasswordSuccess) {
            //show dialog
            showDialog<void>(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext dialogContext) {
                return Dialog(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.04,
                      horizontal: width * 0.04,
                    ),
                    child: Column(
                      spacing: height * 0.012,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'assets/images/success.png',
                        //   fit: BoxFit.cover,
                        //   height: 200,
                        //   alignment: Alignment.center,
                        // ),
                        Icon(
                          CupertinoIcons.check_mark_circled_solid,
                          color: AppPalette.primaryColor,
                          size: isPortrait ? width * 0.4 : width * 0.15,
                        ),
                        Text(
                          'Congratulations!',
                          style: TextStyle(
                            fontSize: isPortrait ? width * 0.07 : width * 0.02,
                            fontWeight: FontWeight.bold,
                            color: AppPalette.primaryColor,
                          ),
                        ),
                        Text(
                          'Password was reset successfully',
                          style: TextStyle(
                            fontSize: isPortrait ? width * 0.04 : width * 0.02,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: height * 0.008,
                          ),
                          child: CustomElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              context.pop();
                            },
                            buttonName: 'Go to Profile page',
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (state is AuthResetPasswordFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.error)));
            showToast(
              context: context,
              type: ToastificationType.error,
              description: state.error,
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
                      spacing: height * 0.024,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image
                        // Center(
                        //   child: Image.asset(
                        //     'assets/images/acknowledged.png',
                        //   ),
                        // ),
                        // Text
                        Text(
                          'Update your password to keep your account secure and protect your personal information.',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: isPortrait ? width * 0.04 : width * 0.02,
                          ),
                        ),
                        //Password field
                        CustomTextFormField(
                          obscureText: true,
                          textEditingController: passwordController,
                          hintText: 'New Password',
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return 'New Password is a required field';
                            } else if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                            ).hasMatch(password)) {
                              return 'Password must be at least 8 characters, include a capital letter, a number, and a special symbol';
                            }
                            return null;
                          },
                          prefixIcon: Icons.lock,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                        ),
                        // Confirm Password field
                        CustomTextFormField(
                          obscureText: true,
                          textEditingController: confirmPasswordController,
                          hintText: 'Confirm New Password',
                          validator: (password) {
                            if (password == null || password.isEmpty) {
                              return 'Confirm New Password is a required field';
                            } else if (!RegExp(
                              r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                            ).hasMatch(password)) {
                              return 'Password must be at least 8 characters, include a capital letter, a number, and a special symbol';
                            } else if (password !=
                                passwordController.text.trim()) {
                              return 'New Password and Confirm New Password must be same.';
                            }
                            return null;
                          },
                          prefixIcon: Icons.lock,
                          textInputAction: TextInputAction.go,
                          textInputType: TextInputType.text,
                        ),
                        //Button
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: height * 0.024,
                            ),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomElevatedButton(
                                onPressed: () async {
                                  key.currentState!.validate()
                                      ? context.read<AuthBloc>().add(
                                        AuthResetPasswordWithId(
                                          password:
                                              passwordController.text.trim(),
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
