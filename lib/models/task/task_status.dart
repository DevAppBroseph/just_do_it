enum TaskStatus{
  inactiveAfter10Days,inactiveAfterDeadline,active,completed,progress,undefined
}

extension TaskStatusX on TaskStatus{
  bool get  isInactive{
     const inactiveList=[TaskStatus.inactiveAfterDeadline,TaskStatus.inactiveAfter10Days,TaskStatus.completed];
     return inactiveList.contains(this);
  }
  String get getStatusDescription{
    switch (this) {
      case TaskStatus.completed:
        return "Completed";
      case TaskStatus.progress:
        return "Progress";
      default :
        return "";
    }
  }
  static TaskStatus fromString(String? inputStatus,DateTime deadline) {
    const dd=["completed","progress"];
    deadline=deadline.subtract(const Duration(days: 1));
    if(dd.contains(inputStatus?.toLowerCase())){
      switch (inputStatus?.toLowerCase()) {
        case "completed":
          return TaskStatus.completed;
        default :
          return TaskStatus.progress;
      }
    }else {
      if (DateTime.now().isAfter(deadline.add(const Duration(days: 2)))) {
        return TaskStatus.inactiveAfterDeadline;
      }
      //TODO check for "inactiveAfter10Days" of last answer date and last grade
      return TaskStatus.active;
    }
  }
}