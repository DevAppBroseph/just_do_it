import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/notofications.dart';
import 'package:just_do_it/network/repository.dart';

part 'notifications_event.dart';
part 'notifications_state.dart';

class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  NotificationsBloc() : super(NotificationsLoading()) {
    on<GetNotificationsEvent>(_getNotifications);
    on<DeleteNotificationsEvent>(_deleteNotifications);
  }
  List<NotificationsOnDevice>? notifications;

  void _getNotifications(GetNotificationsEvent event, Emitter<NotificationsState> emit) async {
    // emit(FavouritesLoading());
    if (event.access != null) {
      notifications = await Repository().getMyNotifications(event.access);

      emit(NotificationsLoaded(notifications: notifications));
    } else {
      emit(NotificationsError());
    }
  }

  void _deleteNotifications(DeleteNotificationsEvent event, Emitter<NotificationsState> emit) async {
    // emit(FavouritesLoading());
    if (event.access != null) {
      await Repository().deleteNotifications(event.access);
      notifications = await Repository().getMyNotifications(event.access);
      emit(NotificationsLoaded(notifications: notifications));
    } else {
      emit(NotificationsError());
    }
  }
}
