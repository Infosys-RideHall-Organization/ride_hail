import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  static _border([Color color = Colors.black12]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }

  static final darkThemeMode = ThemeData.dark().copyWith(
    textTheme: Typography().black.apply(bodyColor: AppPalette.whiteColor),
    scaffoldBackgroundColor: AppPalette.darkBackgroundColor,
    appBarTheme: AppBarTheme(
      surfaceTintColor: AppPalette.darkBackgroundColor,
      color: AppPalette.darkBackgroundColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppPalette.primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    buttonTheme: ButtonThemeData(splashColor: Colors.grey.withAlpha(50)),
    dialogTheme: DialogTheme(
      surfaceTintColor: AppPalette.darkBackgroundColor,
      backgroundColor: AppPalette.darkBackgroundColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: Colors.white,
        backgroundColor: AppPalette.primaryColor,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppPalette.primaryColor,
      selectionColor: AppPalette.greyOpacityColor,
      selectionHandleColor: AppPalette.primaryColor,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: _border(),
      focusedBorder: _border(AppPalette.primaryColor),
      errorBorder: _border(AppPalette.redColor),
      enabledBorder: _border(),
    ),
    tabBarTheme: TabBarTheme(
      overlayColor: WidgetStatePropertyAll(AppPalette.transparentColor),
      labelColor: AppPalette.whiteColor,
      unselectedLabelColor: Colors.grey,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppPalette.primaryColor, width: 3),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppPalette.blackColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(
          AppPalette.primaryColor.withAlpha(100),
        ),
        surfaceTintColor: WidgetStatePropertyAll(AppPalette.whiteColor),
        foregroundColor: WidgetStatePropertyAll(AppPalette.primaryColor),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppPalette.primaryColor;
        }
        return Colors.grey;
      }),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppPalette.darkBackgroundColor,
      surfaceTintColor: AppPalette.darkBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      modalElevation: 8,
    ),
  );

  static final lightThemeMode = ThemeData.light().copyWith(
    textTheme: Typography().black.apply(
      fontFamily: 'Outfit',
      bodyColor: AppPalette.blackColor,
    ),
    scaffoldBackgroundColor: AppPalette.whiteColor,
    appBarTheme: AppBarTheme(
      surfaceTintColor: AppPalette.whiteColor,
      color: AppPalette.whiteColor,
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppPalette.primaryColor,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),

    buttonTheme: ButtonThemeData(splashColor: Colors.black.withAlpha(50)),
    dialogTheme: DialogTheme(
      surfaceTintColor: AppPalette.whiteColor,
      backgroundColor: AppPalette.whiteColor,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        foregroundColor: Colors.white,
        backgroundColor: AppPalette.primaryColor,
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppPalette.primaryColor,
      selectionColor: AppPalette.primaryColor.withAlpha(100),
      selectionHandleColor: AppPalette.primaryColor,
    ),
    tabBarTheme: TabBarTheme(
      overlayColor: WidgetStatePropertyAll(AppPalette.transparentColor),
      labelColor: AppPalette.primaryColor,
      unselectedLabelColor: Colors.black54,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: AppPalette.primaryColor, width: 2),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: _border(),
      focusedBorder: _border(AppPalette.primaryColor),
      errorBorder: _border(AppPalette.redColor),
      enabledBorder: _border(),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppPalette.whiteColor,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(
          AppPalette.primaryColor.withAlpha(50),
        ),
        surfaceTintColor: WidgetStatePropertyAll(AppPalette.whiteColor),
        foregroundColor: WidgetStatePropertyAll(AppPalette.primaryColor),
      ),
    ),
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppPalette.primaryColor;
        }
        return Colors.black54;
      }),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: AppPalette.whiteColor,
      surfaceTintColor: AppPalette.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      modalElevation: 8,
    ),
  );
}
