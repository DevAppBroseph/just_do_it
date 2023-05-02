part of 'bloc_tasks.dart';

class TasksEvent {}

class GetTasksEvent extends TasksEvent {
  String? query;
  String? access;
  List<int> subcategory;
  String? dateStart;
  String? dateEnd;
  int? priceFrom;
  int? priceTo;
  bool? customer;
  int? countFilter;
  int? currency;
  List<Countries> isSelectCountry;
  List<Regions> isSelectRegions;
  List<Town> isSelectTown;
  GetTasksEvent({
    this.currency,
    this.access,
    this.query,
    this.dateEnd,
    this.dateStart,
    this.priceFrom,
    this.priceTo,
    this.isSelectRegions = const [],
    this.isSelectCountry = const [],
    this.isSelectTown = const [],
    this.subcategory = const [],
    this.countFilter,
    this.customer,
  });
}
// class SearchTasksEvent extends TasksEvent {
//   final String? tasksName;
//   String? access;
//   SearchTasksEvent(this.access, {required this.tasksName});
// }



