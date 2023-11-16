part of 'profile_bloc.dart';

class ProfileEvent {}

class GetProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {
  UserRegModel? newUser;
  UpdateProfileEvent(this.newUser);
}

class UpdateProfileTaskEvent extends ProfileEvent {
  UpdateProfileTaskEvent();
}

class EditPageSearchEvent extends ProfileEvent {
  int page;
  String text;
  EditPageSearchEvent(this.page, this.text);
}

class GetCategorieProfileEvent extends ProfileEvent {}

class UpdateProfileWithoutUserEvent extends ProfileEvent {}

class UpdateProfilePhotoEvent extends ProfileEvent {
  XFile? photo;
  UpdateProfilePhotoEvent({required this.photo});
}

class UpdateProfileCvEvent extends ProfileEvent {
  File? file;
  List<String> images;
  UpdateProfileCvEvent({required this.file,required this.images});
}

class UpdateProfileWithoutLoadingEvent extends ProfileEvent {
  UserRegModel? newUser;
  UpdateProfileWithoutLoadingEvent(this.newUser);
}
