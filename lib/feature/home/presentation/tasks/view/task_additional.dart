import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class TaskAdditional extends StatefulWidget {
  final String title;
  final bool asCustomer;
  bool scoreTrue;
  TaskAdditional(
      {super.key,
      required this.title,
      required this.asCustomer,
      required this.scoreTrue});

  @override
  State<TaskAdditional> createState() => _TaskAdditionalState();
}

class _TaskAdditionalState extends State<TaskAdditional> {
  List<Task> taskList = [];
  Task? selectTask;
  Owner? owner;

  @override
  void initState() {
    super.initState();
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository().getMyTaskList(
        BlocProvider.of<ProfileBloc>(context).access!, widget.asCustomer);
    taskList.clear();
    taskList.addAll(res);
    setState(() {});
    if (widget.scoreTrue) {
      if (!mounted) return;

      if (widget.asCustomer == true) {
        scoreDialog(context, '50', 'creating_an_order'.tr());
      } else {
        scoreDialog(context, '50', 'creating_an_offer'.tr().toLowerCase());
      }

      widget.scoreTrue = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: AppColors.greyPrimary,
        body: Stack(
          children: [
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CustomIconButton(
                            onBackPressed: () {
                              if (owner != null) {
                                owner = null;
                                setState(() {});
                              } else if (selectTask != null) {
                                selectTask = null;
                                setState(() {});
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            icon: SvgImg.arrowRight,
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            widget.title,
                            style: CustomTextStyle.sf22w700(
                                AppColors.blackSecondary),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: Stack(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height -
                              20.h -
                              10.h -
                              82.h,
                          child: ListView.builder(
                            itemCount: taskList.length,
                            padding: EdgeInsets.only(top: 15.h, bottom: 100.h),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return itemTask(taskList[index], (task) {
                                setState(() {
                                  selectTask = task;
                                });
                              }, BlocProvider.of<ProfileBloc>(context).user,
                                  context);
                            },
                          ),
                        ),
                        view(),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget view() {
    if (owner != null) {
      return Scaffold(
          backgroundColor: AppColors.greyPrimary,
          body: ProfileView(owner: owner!));
    }
    if (selectTask != null) {
      return Scaffold(
        backgroundColor: AppColors.greyPrimary,
        body: TaskPage(
          task: selectTask!,
          openOwner: (owner) {
            this.owner = owner;
            setState(() {});
          },
          canEdit: true,
        ),
      );
    }
    return Container();
  }
}
