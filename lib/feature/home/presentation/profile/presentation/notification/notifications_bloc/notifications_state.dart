part of 'notifications_bloc.dart';


class NotificationsState {
  
}

class FNotificationsEmpty extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationsOnDevice>? notifications;
  

  NotificationsLoaded({required this.notifications});
}

class NotificationsError extends NotificationsState {}


