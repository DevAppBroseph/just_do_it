import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class AllTasksView extends StatefulWidget {
  final bool asCustomer;
  const AllTasksView({super.key, required this.asCustomer});

  @override
  State<AllTasksView> createState() => _AllTasksViewState();
}

class _AllTasksViewState extends State<AllTasksView> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: MediaQuery(
              data: const MediaQueryData(textScaleFactor: 1.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: ColorStyles.greyEAECEE,
                ),
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
                              widget.asCustomer
                                  ? 'my_tasks'.tr()
                                  : 'Все офферы',
                              style: CustomTextStyle.black_22_w700_171716,
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
                              padding:
                                  EdgeInsets.only(top: 15.h, bottom: 100.h),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                log(taskList[index].id.toString());
                                return itemTask(
                                  taskList[index],
                                  (task) {
                                    setState(() {
                                      selectTask = task;
                                    });
                                  },
                                );
                              },
                            ),
                          ),
                          view(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget view() {
    if (owner != null) {
      return Scaffold(
          backgroundColor: ColorStyles.greyEAECEE,
          body: ProfileView(owner: owner!));
    }
    if (selectTask != null) {
      return Scaffold(
        backgroundColor: ColorStyles.greyEAECEE,
        body: TaskView(
          selectTask: selectTask!,
          openOwner: (owner) {
            this.owner = owner;
            setState(() {});
          },
          canEdit: true,
          canSelect: true,
        ),
      );
    }
    return Container();
  }
}
