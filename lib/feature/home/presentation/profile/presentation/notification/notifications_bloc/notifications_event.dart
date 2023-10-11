part of 'notifications_bloc.dart';

class NotificationsEvent {}

class GetNotificationsEvent extends NotificationsEvent {
  String? access;
  final VoidCallback loadProfile;
  GetNotificationsEvent(this.access,this.loadProfile);
}

class DeleteNotificationsEvent extends NotificationsEvent {
  String? access;
  final VoidCallback loadProfile;
  DeleteNotificationsEvent(this.access,this.loadProfile);
}
