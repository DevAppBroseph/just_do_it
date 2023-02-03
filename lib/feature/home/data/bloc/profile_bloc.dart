import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitState()) {
    on<GetProfileEvent>(_getProfile);
  }

  String? access;
  UserRegModel? user;

  void setAccess(String access) => this.access = access;

  void _getProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(LoadProfileState());

    if (access != null) {
      UserRegModel? res = await Repository().getProfile(access!);
      if (res != null) {
        user = res;
        emit(LoadProfileSuccessState());
      }
    }
    emit(ProfileInitState());
  }
}
