import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/create_task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_additional.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/counts_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_button.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/task.dart';

import '../../../../../models/order_task.dart';
import '../../../../../network/repository.dart';

class Contractor extends StatefulWidget {
  final Size size;
  const Contractor({super.key, required this.size});

  @override
  State<Contractor> createState() => _ContractorState();
}

class _ContractorState extends State<Contractor> {
  List<Task> taskList = [];
  Task? selectTask;
  Owner? owner;
  @override
  void initState() {
    super.initState();
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository()
        .getMyTaskList(BlocProvider.of<ProfileBloc>(context).access!, true);
    taskList.clear();
    taskList.addAll(res);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.of(context)
                  .pushNamed(AppRoute.allTasks, arguments: [true]);
              getListTask();
            },
            child: Container(
              height: 55.h,
              width: widget.size.width,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: ColorStyles.yellowFFD70A,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    SvgImg.task,
                    color: ColorStyles.black,
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        taskCounts(taskList.length),
                        style: CustomTextStyle.black_14_w400_171716,
                      ),
                      Text(
                        'Все задания',
                        style: CustomTextStyle.black_14_w400_171716,
                      )
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorStyles.whiteFFFFFF,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () async {
              await Navigator.of(context)
                  .pushNamed(AppRoute.archiveTasks, arguments: [true]);
              getListTask();
            },
            child: Container(
              height: 55.h,
              width: widget.size.width,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: ColorStyles.yellowFFD70A,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    SvgImg.archive,
                    color: ColorStyles.black,
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        taskCounts(taskList.length),
                        style: CustomTextStyle.black_14_w400_171716,
                      ),
                      Text(
                        'В архиве',
                        style: CustomTextStyle.black_14_w400_171716,
                      )
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorStyles.whiteFFFFFF,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Вас выбрали в ${contractorCountTask(taskList.length)}',
              style: CustomTextStyle.black_18_w500_171716,
            ),
          ),
          SizedBox(height: 30.h),
          Column(
            children: [
              itemButton(
                'Выполняются',
                taskCounts(taskList.length),
                SvgImg.inProgress,
                () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TaskAdditional(
                        title: 'Выполняются',
                        asCustomer: true,
                      );
                    }),
                  );
                  getListTask();
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 18.h),
              itemButton(
                'Выполненные',
                taskCounts(taskList.length),
                SvgImg.complete,
                () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TaskAdditional(
                        title: 'Выполнены',
                        asCustomer: true,
                      );
                    }),
                  );
                  getListTask();
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 18.h),
              itemButton(
                'Ждут подтверждения',
                taskCounts(taskList.length),
                SvgImg.needSuccess,
                () async {
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TaskAdditional(
                        title: 'Ждут подтверждения',
                        asCustomer: true,
                      );
                    }),
                  );
                  getListTask();
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomButton(
              onTap: () async {
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CeateTasks(
                        customer: false,
                        doublePop: true,
                        currentPage: 3,
                      );
                    },
                  ),
                );
                getListTask();
              },
              btnColor: ColorStyles.yellowFFD70A,
              textLabel: Text(
                'Создать новое',
                style: CustomTextStyle.black_16_w600_171716,
              ),
            ),
          ),
          SizedBox(height: 34.h),
        ],
      ),
    );
  }
}
