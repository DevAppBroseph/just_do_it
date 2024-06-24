import 'package:dio/dio.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/services/dio/dio_client.dart';

class TaskRepository {
  Future<Map<String, dynamic>> getTaskList(
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
    int? page,
    String? nextPageUrl,
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
      if (page != null) "page": page,
    };

    final response = await dio.get(
      nextPageUrl ?? 'http://62.113.114.14/orders/',
      queryParameters: nextPageUrl == null ? queryParameters : null,
      options: Options(
        headers: access != null ? {'Authorization': 'Bearer $access'} : null,
      ),
    );

    List<Task> tasks = [];
    if (response.statusCode == 200 || response.statusCode == 201) {
      if (response.data['results'] is List) {
        for (var element in response.data['results']) {
          try {
            final task = Task.fromJson(element);
            tasks.add(task);
          } catch (e) {
            print("Error parsing task: $e");
          }
        }
      } else {
        print(
            "Expected results to be a List, but got ${response.data['results'].runtimeType}");
      }

      return {
        "tasks": tasks,
        "next": response.data['next'],
      };
    }

    return {
      "tasks": tasks,
      "next": null,
    };
  }
}
