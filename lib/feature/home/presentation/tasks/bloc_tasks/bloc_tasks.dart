import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';

part 'event_tasks.dart';
part 'state_tasks.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc() : super(TasksLoading()) {
    on<GetTasksEvent>(_getAllTasks);
    // on<SearchTasksEvent>(_searchTasks);
  }
  List<Task>? tasks;

  void _getAllTasks(GetTasksEvent event, Emitter<TasksState> emit) async {
    emit(TasksLoading());

    if (event.access != null) {
      tasks = await Repository().getTaskList(event.access, event.query);

      emit(TasksLoaded(tasks: tasks));
      log(event.query);
    } else {
      emit(TasksError());
    }
  }

  // void _searchTasks(SearchTasksEvent event, Emitter<TasksState> emit) async {
  //   emit(TasksLoading());
  //   if (event.access != null) {
  //     await Repository().searchTask(event.access!, event.tasksName!);
  //     tasks = await Repository().getTaskList(event.access);
  //     log(tasks!.length.toString());
  //     emit(TasksLoaded(tasks: tasks, search: event.tasksName));
  //   } else {
  //     emit(TasksError());
  //   }

    //   final foundTasks = prevState.tasks?.where((task) {
    //     final nameSplits = task.name.toLowerCase().split(' ');
    //     final searchSplits = event.tasksName?.toLowerCase().split(' ')
    //       ?..removeWhere((searchSplit) => searchSplit.isEmpty);
    //     final checks = <bool>[];
    //     for (final nameSplit in nameSplits) {
    //       bool passed = false;
    //       for (final searchSplit in searchSplits!) {
    //         if (nameSplit.contains(searchSplit)) {
    //           passed = true;
    //         }
    //       }
    //       checks.add(passed);
    //     }
    //     List<bool> isFounds = [];
    //     isFounds = checks.where((check) => check).toList();
    //     return isFounds.length >= searchSplits!.length;
    //   }).toList();
    //  log(event.tasksName.toString());
    //   emit(prevState.copyWith(tasks: foundTasks, search: event.tasksName));
  // }
}
