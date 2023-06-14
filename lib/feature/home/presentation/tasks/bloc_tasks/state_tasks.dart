part of 'bloc_tasks.dart';

class TasksState {}

class TasksEmpty extends TasksState {}

class TasksLoading extends TasksState {}

class UpdateTask extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task>? tasks;
  final int? countFilter;

  TasksLoaded(this.countFilter, {required this.tasks});
}

class TasksError extends TasksState {}
