import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';

class DataUpdater {
  Future<void> updateTasksAndProfileData(BuildContext context) async {
    context.read<TasksBloc>().add(UpdateTaskEvent());
    context.read<ChatBloc>().add(GetListMessage());
    context.read<TasksBloc>().add(
          GetTasksEvent(),
        );
    context.read<ProfileBloc>().add(GetProfileEvent());
  }
}
