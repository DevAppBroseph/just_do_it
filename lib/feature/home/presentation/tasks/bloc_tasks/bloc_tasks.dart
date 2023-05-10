import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/countries.dart';
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
    final regions = event.isSelectRegions.map((e) => e.id!).toList();
    final towns = event.isSelectTown.map((e) => e.id!).toList();
    final countries = event.isSelectCountry.map((e) => e.id!).toList();

    tasks = await Repository().getTaskList(
      event.access,
      event.query,
      event.priceFrom,
      event.priceTo,
      event.dateStart,
      event.dateEnd,
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
