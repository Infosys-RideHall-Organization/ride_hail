import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../entities/auth/user.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUserStatus(User? user) {
    if (user != null) {
      emit(AppUserLoggedIn(user: user));
    } else {
      emit(AppUserInitial());
    }
  }
}
