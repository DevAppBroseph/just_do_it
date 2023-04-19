part of 'bloc_tasks.dart';

class TasksEvent {}

class GetTasksEvent extends TasksEvent {
  String query;
  String? access;
  GetTasksEvent(this.access, this.query);

}
// class SearchTasksEvent extends TasksEvent {
//   final String? tasksName;
//   String? access;
//   SearchTasksEvent(this.access, {required this.tasksName});
// }



