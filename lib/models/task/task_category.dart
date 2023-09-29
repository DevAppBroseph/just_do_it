import 'package:just_do_it/models/task/task_subcategory.dart';

class TaskCategory {
  bool isSelect;
  int id;
  String? description;
  String? engDescription;
  String? photo;
  List<TaskSubcategory> subcategory;
  List<String> selectSubcategory = [];

  TaskCategory(this.isSelect, this.id, this.description, this.photo, this.subcategory, this.engDescription);

  factory TaskCategory.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? description = data['description'];
    String? engDescription = data['description_eng'];

    String? photo = data['photo'];
    List<TaskSubcategory> subcategory = [];
    if (data['subcategories'] != null) {
      for (var element in data['subcategories']) {
        subcategory.add(TaskSubcategory.fromJson(element));
      }
    }
    return TaskCategory(false, id, description, photo, subcategory, engDescription);
  }
}