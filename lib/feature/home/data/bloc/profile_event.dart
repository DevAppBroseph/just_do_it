part of 'profile_bloc.dart';

class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  UserRegModel? newUser;
  UpdateProfileEvent(this.newUser);
}

class UpdateProfileWithoutLoadingEvent extends ProfileEvent {
  UserRegModel? newUser;
  UpdateProfileWithoutLoadingEvent(this.newUser);
}
