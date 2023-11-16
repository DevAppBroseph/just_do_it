import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/network/task_repository.dart';

part 'event_tasks.dart';
part 'state_tasks.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(TasksLoading()) {
    on<GetTasksEvent>(_getAllTasks);
    on<UpdateTaskEvent>(_updateTask);
  }
  List<Task> tasks = [];

  void _updateTask(UpdateTaskEvent event, Emitter<TasksState> emit) async {
    emit(UpdateTask());
  }

  void _getAllTasks(GetTasksEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());
    final regions = event.isSelectRegions.map((e) => e.id!).toList();
    final towns = event.isSelectTown.map((e) => e.id!).toList();
    final countries = event.isSelectCountry.map((e) => e.id!).toList();
    tasks = await TaskRepository().getTaskList(
      event.query,
      event.priceFrom,
      event.priceTo,
      event.dateStart,
      event.dateEnd,
      event.access,
      event.subcategory,
      regions,
      towns,
      countries,
      event.customer,
      event.currency,
      event.passport,
      event.cv,
    );

    emit(TasksLoaded(event.countFilter, tasks: tasks));
  }

}
