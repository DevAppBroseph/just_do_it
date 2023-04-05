part of 'profile_bloc.dart';

class ProfileState {}

class ProfileInitState extends ProfileState {}

class LoadProfileState extends ProfileState {}

class UpdateProfileSuccessState extends ProfileState {}

class UpdateProfileErrorState extends ProfileState {}

class LoadProfileSuccessState extends ProfileState {}

class LoadProfileErrorState extends ProfileState {}

class GetCategoriesProfileState extends ProfileState {
  List<Activities> activities;

  GetCategoriesProfileState({required this.activities});
}
