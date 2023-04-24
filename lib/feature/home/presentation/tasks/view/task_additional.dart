import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class TaskAdditional extends StatefulWidget {
  String title;
  TaskAdditional({super.key, required this.title});

  @override
  State<TaskAdditional> createState() => _TaskAdditionalState();
}

class _TaskAdditionalState extends State<TaskAdditional> {
  List<Task> taskList = [];
  Task? selectTask;

  @override
  void initState() {
    super.initState();
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository()
        .getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!, true);
    taskList.clear();
    taskList.addAll(res.reversed);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                            if (selectTask != null) {
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
                          style: CustomTextStyle.black_22_w700_171716,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                selectTask == null
                    ? Expanded(
                        child: ListView(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          padding: EdgeInsets.zero,
                          children: taskList
                              .map(
                                (e) => itemTask(
                                  e,
                                  (task) {
                                    setState(() {
                                      selectTask = task;
                                    });
                                  },
                                ),
                              )
                              .toList(),
                        ),
                      )
                    : TaskView(
                        selectTask: selectTask!,
                        openOwner: (owner) {},
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
