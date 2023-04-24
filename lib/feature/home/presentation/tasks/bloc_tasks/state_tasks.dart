part of 'bloc_tasks.dart';

class TasksState {}

class TasksEmpty extends TasksState {}

class TasksLoading extends TasksState {}

class TasksLoaded extends TasksState {
  final List<Task>? tasks;
  final int kolvo;
 
  TasksLoaded(this.kolvo, {required this.tasks});

class TasksError extends TasksState {}
