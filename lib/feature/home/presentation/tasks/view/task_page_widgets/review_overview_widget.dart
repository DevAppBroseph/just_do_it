import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page_widgets/offer_respond_action_widget.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page_widgets/task_respond_action_widget.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/models/user_reg.dart';

class ReviewOverviewWidget extends StatefulWidget {
  const ReviewOverviewWidget({super.key,required this.task, required this.isTaskOwner, required this.openOwner, required this.canEdit, required this.getTask, required this.onNewUser});
  final Task task;
  final bool isTaskOwner;
  final Function(Owner?) openOwner;
  final bool canEdit;
  final VoidCallback getTask;
  final Function(UserRegModel?) onNewUser;

  @override
  State<ReviewOverviewWidget> createState() => _ReviewOverviewWidgetState();
}

class _ReviewOverviewWidgetState extends State<ReviewOverviewWidget> {
  // late final user = BlocProvider.of<ProfileBloc>(context).user;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start,children: [
        if(widget.task.isTask!)...[
          if (widget.task.answers.isNotEmpty&&widget.task.status!=TaskStatus.completed &&widget.isTaskOwner &&
              !(widget.task.isBanned??false))...[
            Text(
              'responses'.tr(),
              style: CustomTextStyle.black_17_w800,
            ),
            BlocBuilder<TasksBloc, TasksState>(
                buildWhen: (previous, current) {
                  if (current is UpdateTask) {
                    widget.getTask();
                    return true;
                  }
                  if (previous != current) {
                    return true;
                  }
                  return false;
                }, builder: (context, state) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (previous, current) {
                    if (current is LoadProfileSuccessState) {
                      widget.onNewUser(BlocProvider.of<ProfileBloc>(context).user);

                      return true;
                    }
                    if (current is UpdateProfileSuccessState) {
                      widget.onNewUser(BlocProvider.of<ProfileBloc>(context).user);
                      return true;
                    }
                    if (previous != current) {
                      return true;
                    }
                    return false;
                  }, builder: (context, stateProfile) {
                final selectedAnswerIndex =widget.task.answers.indexWhere((element) =>element.status=="Selected");
                if(selectedAnswerIndex!=-1){
                  final selectedAnswer=widget.task.answers[selectedAnswerIndex];
                  widget.task.answers.clear();
                  widget.task.answers.add(selectedAnswer);
                }else{
                  widget.task.answers=widget.task.answers..sort((a,b){
                    if ((a.isGraded ?? false) && !(b.isGraded ?? false)) {
                      return -1; // a comes before b
                    } else if (!(a.isGraded ?? false) && (b.isGraded ?? false)) {
                      return 1; // b comes before a
                    } else {
                      return 0; // no change in order
                    }
                  });
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.task.answers.length,
                  itemBuilder: (context, index) {
                    return TaskRespondActionWidget(
                      task: widget.task,
                      index: index,
                      openOwner: widget.openOwner,
                      canEdit: widget.canEdit,
                    );
                  },
                );
              });
            }),
          ]

        ]else...[
          if (widget.task.answers.isNotEmpty&&widget.task.status!=TaskStatus.completed &&
              !(widget.task.isBanned??false))...[
            Text(
              'responses'.tr(),
              style: CustomTextStyle.black_17_w800,
            ),
            BlocBuilder<TasksBloc, TasksState>(
                buildWhen: (previous, current) {
                  if (current is UpdateTask) {
                    widget.getTask();
                    return true;
                  }
                  if (previous != current) {
                    return true;
                  }
                  return false;
                }, builder: (context, state) {
              return BlocBuilder<ProfileBloc, ProfileState>(
                  buildWhen: (previous, current) {
                    if (current is LoadProfileSuccessState) {
                      widget.onNewUser(BlocProvider.of<ProfileBloc>(context).user);

                      return true;
                    }
                    if (current is UpdateProfileSuccessState) {
                      widget.onNewUser(BlocProvider.of<ProfileBloc>(context).user);
                      return true;
                    }
                    if (previous != current) {
                      return true;
                    }
                    return false;
                  }, builder: (context, stateProfile) {
                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.task.answers.length,
                  itemBuilder: (context, index) {
                    return OfferRespondActionWidget(
                      task: widget.task,
                      index: index,
                      openOwner: widget.openOwner,
                      canEdit: widget.canEdit,
                    );
                  },
                );
              });
            }),
          ]
        ]

    ],);
  }
}
