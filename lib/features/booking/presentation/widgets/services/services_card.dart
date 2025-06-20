import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ride_hail/core/theme/cubit/theme_cubit.dart';

import '../../../../../core/theme/app_palette.dart';

class ServicesCard extends StatelessWidget {
  const ServicesCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.image,
  });

  final String title;
  final String subTitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(16.0),
          decoration: ShapeDecoration(
            color:
                state.appTheme == AppThemeMode.dark
                    ? AppPalette.servicesCardBackgroundColor
                    : AppPalette.greyColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Row(
            spacing: 16.0,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 100,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 8.0,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 24.0,
                      ),
                    ),
                    Text(subTitle),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
