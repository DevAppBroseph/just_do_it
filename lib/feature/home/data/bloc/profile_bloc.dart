import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitState()) {
    on<GetProfileEvent>(_getProfile);
    on<UpdateProfileEvent>(_updateProfile);
    on<UpdateProfileWithoutLoadingEvent>(_updateWithoutLoadingProfile);
  }

  String? access;
  UserRegModel? user;

  void setAccess(String? accessToken) async {
    await Storage().setAccessToken(accessToken);
    access = accessToken;
  }

  void setUser(UserRegModel? user) => this.user = user;

  void _updateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(LoadProfileState());
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
    user = event.newUser;
    if (access != null) {
      bool res = await Repository().updateUser(access!, user!);
      if (res) {
        emit(UpdateProfileSuccessState());
      }
    }
    // emit(ProfileInitState());
  }

  void _updateWithoutLoadingProfile(
    UpdateProfileWithoutLoadingEvent event,
    Emitter<ProfileState> emit,
  ) async {
    // emit(LoadProfileState());
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
    user = event.newUser;
    if (access != null) {
      bool res = await Repository().updateUser(access!, user!);
      if (res) {
        emit(UpdateProfileSuccessState());
      }
    }
    // emit(ProfileInitState());
  }

  void _getProfile(GetProfileEvent event, Emitter<ProfileState> emit) async {
    emit(LoadProfileState());
    String? accessToken = await Storage().getAccessToken();
    access = accessToken;
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
