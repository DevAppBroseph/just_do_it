part of 'notifications_bloc.dart';

class NotificationsEvent {}

class GetNotificationsEvent extends NotificationsEvent {
  String? access;
  GetNotificationsEvent(this.access);
}

class DeleteNotificationsEvent extends NotificationsEvent {
  String? access;
  DeleteNotificationsEvent(this.access);
}
