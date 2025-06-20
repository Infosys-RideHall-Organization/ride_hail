import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_hail/core/common/widgets/custom_elevated_button.dart';
import 'package:ride_hail/core/common/widgets/text_form_field.dart';
import 'package:ride_hail/core/utils/pick_image.dart';
import 'package:ride_hail/features/profile/domain/enums/gender.dart';
import 'package:ride_hail/features/profile/presentation/widgets/placeholder_image.dart';
import 'package:string_validator/string_validator.dart' as validator;
import 'package:toastification/toastification.dart';

import '../../../../core/common/widgets/custom_loading_indicator.dart';
import '../../../../core/common/widgets/toast.dart';
import '../../../../core/constants/constants.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/gender_drop_down.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  Gender gender = Gender.notSpecified;

  File? profileImage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ProfileBloc>().add(GetProfile()),
    );
    final profileState = context.read<ProfileBloc>().state;
    if (profileState is ProfileSuccess) {
      _nameController.text = profileState.profile.name;
      _emailController.text = profileState.profile.email;
      gender = GenderExtension.fromString(profileState.profile.gender);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        profileImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Edit Profile')),
        body: BlocConsumer<ProfileBloc, ProfileState>(
          listener: (context, state) {
            if (state is ProfileFailure) {
              showToast(
                context: context,
                type: ToastificationType.error,
                description: state.message,
              );
            }
          },
          builder: (context, state) {
            if (state is ProfileLoading) {
              return Center(child: CustomLoadingIndicator());
            } else if (state is ProfileSuccess) {
              final imageUrl =
                  (state.profile.profileImage != null)
                      ? '${Constants.backendUrl}${state.profile.profileImage}?ts=${DateTime.now().millisecondsSinceEpoch}'
                      : null;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 32.0,
                        right: 32.0,
                        top: 16.0,
                      ),
                      child: Center(
                        child: GestureDetector(
                          onLongPress: () {
                            showGeneralDialog(
                              context: context,
                              barrierLabel: "Image Preview",
                              barrierDismissible: true,
                              barrierColor: Colors.black54,
                              transitionDuration: const Duration(
                                milliseconds: 200,
                              ),
                              pageBuilder: (
                                context,
                                animation,
                                secondaryAnimation,
                              ) {
                                return BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 5,
                                    sigmaY: 5,
                                  ),
                                  child: Center(
                                    child: ClipOval(
                                      child:
                                          profileImage != null
                                              ? Image.file(
                                                profileImage!,
                                                width: 240,
                                                height: 240,
                                                fit: BoxFit.cover,
                                              )
                                              : imageUrl != null
                                              ? Image.network(
                                                imageUrl,
                                                width: 240,
                                                height: 240,
                                                fit: BoxFit.cover,
                                              )
                                              : PlaceholderImage(),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: ClipOval(
                            child:
                                profileImage != null
                                    ? Image.file(
                                      profileImage!,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    )
                                    : imageUrl != null
                                    ? Image.network(
                                      imageUrl,
                                      width: 160,
                                      height: 160,
                                      fit: BoxFit.cover,
                                    )
                                    : PlaceholderImage(),
                          ),
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        // Pick image
                        selectImage();
                      },
                      child: Text('Change Picture'),
                    ),
                    // Basic Info
                    Padding(
                      padding: EdgeInsets.only(
                        // top: height * 0.18,
                        left: width * 0.016,
                        right: width * 0.016,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          spacing: height * 0.016,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //Profile fields
                            // Name
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: Text(
                                    'Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                CustomTextFormField(
                                  prefixIcon: Icons.person,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.name,
                                  textEditingController: _nameController,
                                  validator: (name) {
                                    if (name == null || name.isEmpty) {
                                      return 'Name is a required field';
                                    }
                                    return null;
                                  },
                                  hintText: 'Name',
                                ),
                              ],
                            ),
                            // Email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: Text(
                                    'Email',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                CustomTextFormField(
                                  isEnabled: false,
                                  prefixIcon: Icons.email,
                                  textInputAction: TextInputAction.next,
                                  textInputType: TextInputType.emailAddress,
                                  textEditingController: _emailController,
                                  validator: (email) {
                                    if (email == null || email.isEmpty) {
                                      return 'Email is a required field';
                                    } else if (!validator.isEmail(email)) {
                                      return 'Enter a valid email';
                                    }
                                    return null;
                                  },
                                  hintText: 'Email',
                                  helperText:
                                      'Your Email is your primary identifier and cannot be changed directly. Please contact support to update it.',
                                ),
                              ],
                            ),
                            // Gender
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(
                                    left: 8.0,
                                    bottom: 4.0,
                                  ),
                                  child: Text(
                                    'Gender',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                CustomGenderDropdown(
                                  initialValue: GenderExtension.fromString(
                                    gender.displayValue,
                                  ),
                                  onChanged: (changedGender) {
                                    setState(() {
                                      gender = changedGender;
                                    });
                                    debugPrint(
                                      "Selected gender: ${gender.displayValue}",
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox.shrink(),
                            //Signup Button
                            CustomElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ProfileBloc>().add(
                                    UpdateProfileDetails(
                                      file: profileImage,
                                      name: _nameController.text.trim(),
                                      gender: gender.displayValue,
                                    ),
                                  );
                                  context.pop(true);
                                }
                              },
                              buttonName: 'Save Changes',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return Center(child: Text('Loading Profile...'));
          },
        ),
      ),
    );
  }
}
