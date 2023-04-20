import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';

class TaskAdditional extends StatefulWidget {
  String title;
  TaskAdditional({super.key, required this.title});

  @override
  State<TaskAdditional> createState() => _TaskAdditionalState();
}

class _TaskAdditionalState extends State<TaskAdditional> {
  List<Task> taskList = [];

  @override
  void initState() {
    super.initState();
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository()
        .getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!);
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
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.keyboard_backspace_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          widget.title,
                          style: CustomTextStyle.black_21_w700_171716,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children:
                        taskList.map((e) => itemTask(e, (tas) {})).toList(),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
