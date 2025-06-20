import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ride_hail/core/common/widgets/custom_loading_indicator.dart';
import 'package:ride_hail/core/common/widgets/toast.dart';
import 'package:ride_hail/core/constants/constants.dart';
import 'package:ride_hail/core/routes/app_routes.dart';
import 'package:ride_hail/core/theme/app_palette.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/theme/cubit/theme_cubit.dart';
import '../../../auth/presentation/blocs/auth_bloc/auth_bloc.dart';
import '../bloc/profile_bloc.dart';
import '../widgets/placeholder_image.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ProfileBloc>().add(GetProfile()),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = MediaQuery.sizeOf(context).height;
    final isPortrait =
        MediaQuery.orientationOf(context) == Orientation.portrait;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text('Profile')),
        body: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  child: Text('Account Info', style: TextStyle(fontSize: 18)),
                ),
                Tab(child: Text('Settings', style: TextStyle(fontSize: 18))),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                physics: BouncingScrollPhysics(),
                children: [
                  // Content Page 1
                  BlocConsumer<ProfileBloc, ProfileState>(
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
                        return SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            spacing: 16.0,
                            children: [
                              // Image
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32.0,
                                  vertical: 16.0,
                                ),
                                child: Center(
                                  child: Stack(
                                    children: [
                                      GestureDetector(
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
                                                  child: Hero(
                                                    tag: 'profile_image',
                                                    child:
                                                        state
                                                                    .profile
                                                                    .profileImage !=
                                                                null
                                                            ? ClipOval(
                                                              child: Image.network(
                                                                '${Constants.backendUrl}${state.profile.profileImage}?ts=${DateTime.now().millisecondsSinceEpoch}',
                                                                width: 240,
                                                                height: 240,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                              ),
                                                            )
                                                            : ClipOval(
                                                              child:
                                                                  PlaceholderImage(),
                                                            ),
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Hero(
                                          tag: 'profile_image',
                                          child: ClipOval(
                                            child: Image.network(
                                              '${Constants.backendUrl}${state.profile.profileImage}?ts=${DateTime.now().millisecondsSinceEpoch}',
                                              width: 160,
                                              height: 160,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (_, __, ___) =>
                                                      PlaceholderImage(),
                                              loadingBuilder: (
                                                context,
                                                child,
                                                loadingProgress,
                                              ) {
                                                if (loadingProgress == null) {
                                                  return child;
                                                }
                                                return PlaceholderImage();
                                              },
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top:
                                            isPortrait
                                                ? height * 0.13
                                                : height * .28,
                                        left:
                                            isPortrait
                                                ? width * 0.24
                                                : width * .12,
                                        child: IconButton(
                                          iconSize: 20,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppPalette.primaryColor,
                                            shape: CircleBorder(),
                                          ),
                                          icon: Icon(Icons.edit),
                                          color: Colors.white,
                                          onPressed: () async {
                                            // handle tap
                                            final Object?
                                            isUpdated = await context.push(
                                              '${AppRoutes.profile}${AppRoutes.editProfile}',
                                            );
                                            if (mounted) {
                                              if (isUpdated is bool) {
                                                isUpdated
                                                    ? context
                                                        .read<ProfileBloc>()
                                                        .add(GetProfile())
                                                    : null;
                                              }
                                            }
                                          },
                                          padding: EdgeInsets.all(
                                            2,
                                          ), // adjust if needed
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Basic Info
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24.0,
                                  vertical: 8.0,
                                ),
                                child: Text(
                                  'Basic Information',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, height: 3),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                title: Text(
                                  'Name',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  state.profile.name,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, height: 3),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                title: Text(
                                  'Email',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  state.profile.email,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, height: 3),
                              ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                title: Text(
                                  'Gender',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                subtitle: Text(
                                  state.profile.gender,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              Divider(thickness: 1, height: 3),
                            ],
                          ),
                        );
                      }

                      return Center(child: Text('Loading Profile...'));
                    },
                  ),
                  // Content Page 2
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'App Settings',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        BlocBuilder<ThemeCubit, ThemeState>(
                          builder: (context, state) {
                            return ListTile(
                              leading: Icon(CupertinoIcons.eye),
                              title: Text(
                                'App Appearance',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: Icon(Icons.navigate_next),
                              onTap: () async {
                                await showModalBottomSheet(
                                  context: context,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return IntrinsicHeight(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          spacing: 16.0,
                                          children: [
                                            Text(
                                              'Choose Theme',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28,
                                              ),
                                            ),
                                            Divider(),
                                            ListTile(
                                              title: const Text('Light Theme'),
                                              trailing: Radio<AppThemeMode>(
                                                value: AppThemeMode.light,
                                                groupValue: state.appTheme,
                                                onChanged: (
                                                  AppThemeMode? value,
                                                ) {
                                                  if (value != null) {
                                                    context
                                                        .read<ThemeCubit>()
                                                        .changeTheme();
                                                    context.pop();
                                                  }
                                                },
                                              ),
                                            ),
                                            ListTile(
                                              title: const Text('Dark Theme'),
                                              trailing: Radio<AppThemeMode>(
                                                value: AppThemeMode.dark,
                                                groupValue: state.appTheme,
                                                onChanged: (
                                                  AppThemeMode? value,
                                                ) {
                                                  if (value != null) {
                                                    context
                                                        .read<ThemeCubit>()
                                                        .changeTheme();
                                                    context.pop();
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.password),
                          title: Text(
                            'Change Password',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            context.push(
                              '${AppRoutes.profile}${AppRoutes.changePassword}',
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(
                            CupertinoIcons.delete,
                            color: AppPalette.redColor,
                          ),
                          title: Text(
                            'Delete Account',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppPalette.redColor,
                            ),
                          ),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              builder: (context) {
                                return IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 16.0,
                                      children: [
                                        Text(
                                          'Delete Account',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppPalette.redAccentColor,
                                            fontSize: 28,
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          'Are you sure you want to delete your account? This action will permanently remove all your profile data and booking history.',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                context.pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppPalette
                                                    .darkGreyColor
                                                    .withAlpha(200),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 48,
                                                  vertical: 16,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                context.read<ProfileBloc>().add(
                                                  DeleteProfile(),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    AppPalette.redColor,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 48,
                                                  vertical: 16,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                              ),
                                              child: Text(
                                                'Yes, Delete',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Additional Information',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.info_outline),
                          title: Text(
                            'About',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            context.push(
                              '${AppRoutes.profile}${AppRoutes.about}',
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.question_answer_outlined),
                          title: Text(
                            'FAQs',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            context.push(
                              '${AppRoutes.profile}${AppRoutes.faq}',
                            );
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.handshake_outlined),
                          title: Text(
                            'Terms & Conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(Icons.navigate_next),
                          onTap: () {
                            context.push(
                              '${AppRoutes.profile}${AppRoutes.termsAndConditions}',
                            );
                          },
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            'Actions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        ListTile(
                          onTap: () async {
                            await showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              builder: (context) {
                                return IntrinsicHeight(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      spacing: 16.0,
                                      children: [
                                        Text(
                                          'Logout',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: AppPalette.redAccentColor,
                                            fontSize: 28,
                                          ),
                                        ),
                                        Divider(),
                                        Text(
                                          'Sure you want to log out?',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                        Divider(),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () {
                                                context.pop();
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: AppPalette
                                                    .darkGreyColor
                                                    .withAlpha(200),
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 48,
                                                  vertical: 16,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                              ),
                                              child: Text(
                                                'Cancel',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                context.read<AuthBloc>().add(
                                                  AuthSignOut(),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 48,
                                                  vertical: 16,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(32),
                                                ),
                                              ),
                                              child: Text(
                                                'Yes, Logout',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          leading: Icon(
                            Icons.logout,
                            color: AppPalette.redAccentColor,
                          ),
                          title: Text(
                            'Logout',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppPalette.redAccentColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
