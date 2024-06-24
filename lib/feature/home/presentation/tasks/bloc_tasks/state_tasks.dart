part of 'bloc_tasks.dart';

class TasksState {}

class TasksEmpty extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoadingMore extends TasksState {}

class UpdateTask extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task>? tasks;
  final int? countFilter;
  final String? nextPageUrl;

  TasksLoaded(this.countFilter, {required this.tasks, this.nextPageUrl});
}

class TasksError extends TasksState {}
