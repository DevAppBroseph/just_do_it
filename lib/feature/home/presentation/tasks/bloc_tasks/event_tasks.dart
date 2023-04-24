part of 'bloc_tasks.dart';

class TasksEvent {}

class GetTasksEvent extends TasksEvent {
  String query;
  String? access;
  List<int?> subcategory;
  String? dateStart;
  String? dateEnd;
  int? priceFrom;
  int? priceTo;
  List<String?> region;
  bool? customer;
  int? countFilter;
  GetTasksEvent(
    this.access,
    this.query,
    this.dateEnd,
    this.dateStart,
    this.priceFrom,
    this.priceTo,
    this.region,
    this.subcategory,
    this.countFilter,
    this.customer,
  );
}
// class SearchTasksEvent extends TasksEvent {
//   final String? tasksName;
//   String? access;
//   SearchTasksEvent(this.access, {required this.tasksName});
// }



