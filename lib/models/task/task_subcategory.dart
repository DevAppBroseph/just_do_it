class TaskSubcategory {
  bool isSelect;
  int id;
  String? description;
  String? engDescription;

  TaskSubcategory(this.isSelect, {required this.id, required this.description, required this.engDescription});

  factory TaskSubcategory.fromJson(Map<String, dynamic> data) {
    int id = data['id'];
    String? engDescription = data['description_eng'];
    String? description = data['description'];
    return TaskSubcategory(false, id: id, description: description, engDescription: engDescription);
  }
}