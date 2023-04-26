import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';

part 'event_tasks.dart';
part 'state_tasks.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(TasksLoading()) {
    on<GetTasksEvent>(_getAllTasks);
  }
  List<Task> tasks = [];

  void _getAllTasks(GetTasksEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    log(event.priceFrom.toString());
    // if (event.access != null) {
    tasks = await Repository().getTaskList(
      event.access,
      event.query,
      event.region,
      event.priceFrom,
      event.priceTo,
      event.dateStart,
      event.dateEnd,
      event.subcategory,
      event.customer,
    );
    tasks = tasks;
    emit(TasksLoaded(event.countFilter, tasks: tasks));
    // log(event.query);
    // } else {
    // emit(TasksError());
    // }
  }
}
