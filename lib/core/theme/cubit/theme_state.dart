part of 'theme_cubit.dart';

enum AppThemeMode { light, dark }

class ThemeState extends Equatable {
  final AppThemeMode appTheme;

  const ThemeState({this.appTheme = AppThemeMode.dark});

  factory ThemeState.initial() {
    return ThemeState();
  }

  ThemeState copyWith({AppThemeMode? appTheme}) {
    return ThemeState(appTheme: appTheme ?? this.appTheme);
  }

  @override
  List<Object?> get props => [appTheme];

  @override
  bool? get stringify => true;
}
