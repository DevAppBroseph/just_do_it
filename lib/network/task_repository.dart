import 'package:dio/dio.dart';
import 'package:just_do_it/constants/server.dart';
import 'package:just_do_it/models/task/task.dart';

class TaskRepository{
  var dio = Dio();

  Future<List<Task>> getTaskList(
      String? query,
      int? priceFrom,
      int? priceTo,
      String? dateStart,
      String? dateEnd,
      String? access,
      List<int> subcategory,
      List<int> regions,
      List<int> towns,
      List<int> countries,
      bool? customer,
      int? currency,
      bool? passport,
      bool? cv,
      ) async {
    Map<String, dynamic>? queryParameters = {
      if (query != null && query.isNotEmpty) "search": query,
      if (priceTo != null) "price_to": priceTo,
      if (priceFrom != null) "price_from": priceFrom,
      if (dateEnd != null) "date_end": dateEnd,
      if (dateStart != null) "date_start": dateStart,
      if (currency != null) "currency": currency,
      if (passport != null && passport) "doc_info_not_empty": passport,
      if (countries.isNotEmpty) "countries": countries,
      if (towns.isNotEmpty) "towns": towns,
      if (regions.isNotEmpty) "regions": regions,
      if (subcategory.isNotEmpty) "subcategory": subcategory,
      if (cv != null && cv) "has_cv": cv,
      "as_customer": customer,
    };
    final response = await dio.get(
      '$server/orders/',
      queryParameters: queryParameters,
      options: Options(
        validateStatus: ((status) => status! >= 200),
        headers: access != null ? {'Authorization': 'Bearer $access'} : null,
      ),
    );
    List<Task> tasks = [];
    if (response.statusCode == 201 || response.statusCode == 200) {
      for (var element in response.data) {
        final task = Task.fromJson(element);
        tasks.add(task);
      }
      return tasks;
    }
    return tasks;
  }
}