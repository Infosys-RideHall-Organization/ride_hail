import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/utils/google_signin_id_token.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_field.dart';
import '../widgets/auth_footer.dart';
import '../widgets/auth_header.dart';
import '../widgets/continue_with_widget.dart';
import '../widgets/forgot_password_button.dart';
import '../widgets/google_sign_in_button.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    // final isPortrait =
    //     MediaQuery.orientationOf(context) == Orientation.portrait;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.message)));
            showToast(
              context: context,
              type: ToastificationType.error,
              description: state.message,
            );
          } else if (state is AuthSuccess) {
            // ScaffoldMessenger.of(
            //   context,
            // ).showSnackBar(SnackBar(content: Text(state.user.name)));
            showToast(
              context: context,
              type: ToastificationType.success,
              description: "Signed in successfully!",
            );
            context.go(AppRoutes.home);
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return CustomLoadingIndicator();
          }
          return SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: constraints.maxWidth,
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Stack(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.06),
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: Image.asset(
                                    'assets/images/blue_wave_2x.png',
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  top: height * 0.18,
                                  left: width * 0.016,
                                  right: width * 0.016,
                                ),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    spacing: height * 0.016,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      //Top texts
                                      AuthHeader(
                                        header: 'Welcome Back to Ride Hail',
                                      ),
                                      //Auth fields
                                      // Email
                                      AuthField(
                                        prefixIcon: Icons.email,
                                        textInputAction: TextInputAction.next,
                                        textInputType:
                                            TextInputType.emailAddress,
                                        textEditingController: _emailController,
                                        validator: (email) {
                                          if (email == null || email.isEmpty) {
                                            return 'Email is a required field';
                                          } else if (!validator.isEmail(
                                            email,
                                          )) {
                                            return 'Enter a valid email';
                                          }
                                          return null;
                                        },
                                        hintText: 'Email',
                                      ),
                                      //Password
                                      AuthField(
                                        obscureText: true,
                                        prefixIcon: Icons.lock,
                                        textInputAction: TextInputAction.go,
                                        textInputType: TextInputType.text,
                                        textEditingController:
                                            _passwordController,
                                        validator: (password) {
                                          if (password == null ||
                                              password.isEmpty) {
                                            return 'Password is a required field';
                                          } else if (!RegExp(
                                            r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
                                          ).hasMatch(password)) {
                                            return 'Password must be at least 8 characters, include a capital letter, a number, and a special symbol';
                                          }
                                          return null;
                                        },
                                        hintText: 'Password',
                                      ),
                                      //Login Button
                                      AuthButton(
                                        onPressed: () {
                                          _formKey.currentState!.validate()
                                              ? context.read<AuthBloc>().add(
                                                AuthSignIn(
                                                  email:
                                                      _emailController.text
                                                          .trim(),
                                                  password:
                                                      _passwordController.text
                                                          .trim(),
                                                ),
                                              )
                                              : null;
                                        },
                                        buttonName: 'Login',
                                      ),
                                      //Forgot password text
                                      Center(
                                        child: ForgotPasswordButton(
                                          onPressed: () {
                                            context.push(
                                              AppRoutes.forgotPassword,
                                            );
                                          },
                                        ),
                                      ),
                                      // Or continue with
                                      ContinueWithWidget(),
                                      // Buttons for company login
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: height * 0.02,
                                          bottom: height * 0.02,
                                          left: width * 0.03,
                                          right: width * 0.03,
                                        ),
                                        child: GoogleSignInButton(
                                          onPressed: () async {
                                            final idToken =
                                                await getGoogleIdToken();
                                            if (idToken != null) {
                                              // Use the token
                                              debugPrint('ID Token: $idToken');
                                              if (context.mounted) {
                                                context.read<AuthBloc>().add(
                                                  AuthGoogleSignIn(
                                                    idToken: idToken,
                                                  ),
                                                );
                                              }
                                            } else {
                                              // Handle error or cancellation
                                              debugPrint(
                                                'Failed to retrieve ID token',
                                              );
                                              if (context.mounted) {
                                                showToast(
                                                  context: context,
                                                  type:
                                                      ToastificationType.error,
                                                  description:
                                                      'Google Sign In Failed.',
                                                );
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                      // Rich text
                                      AuthFooter(
                                        isSignUp: false,
                                        onTap: () {
                                          context.go(AppRoutes.signUp);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                'assets/images/Infosys_logo_natural.png',
                                height: 50,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
