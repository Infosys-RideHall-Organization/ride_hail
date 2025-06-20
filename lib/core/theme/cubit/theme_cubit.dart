import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(ThemeState.initial());

  // void changeTheme() {
  //   if (state.appTheme == AppThemeMode.light) {
  //     emit(state.copyWith(appTheme: AppThemeMode.dark));
  //   } else {
  //     emit(state.copyWith(appTheme: AppThemeMode.light));
  //   }
  // }

  // Modified to accept a specific theme mode
  void changeTheme() {
    if (state.appTheme == AppThemeMode.light) {
      emit(state.copyWith(appTheme: AppThemeMode.dark));
    } else {
      emit(state.copyWith(appTheme: AppThemeMode.light));
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final themeString = json['appTheme'] as String?;
    if (themeString != null) {
      return ThemeState(
        appTheme: AppThemeMode.values.firstWhere(
          (appThemeMode) => appThemeMode.toString() == themeString,
          orElse: () => AppThemeMode.dark,
        ),
      );
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'appTheme': state.appTheme.toString()};
  }
}
