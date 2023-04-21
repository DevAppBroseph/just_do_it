import 'dart:developer' as dev;
import 'dart:developer';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';

class SearchPage extends StatefulWidget {
  final Function() onBackPressed;
  final Function(int) onSelect;

  SearchPage({required this.onBackPressed, required this.onSelect});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Subcategory? selectSubCategory;
  List<Task> taskList = [];
  Task? selectTask;
  Owner? owner;

  @override
  void initState() {
    super.initState();
    getListTask();
  }

  void getListTask() async {
    List<Task> res = await Repository().getTaskList(
      BlocProvider.of<ProfileBloc>(context).access!,
      null,
      [],
      null,
      null,
      null,
      null,
      null,
    );
    taskList.clear();
    taskList.addAll(res.reversed);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<TasksBloc>().add(
        GetTasksEvent(access, '', '', '', 0, 500000, [], selectSubCategory));
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 130.h,
              decoration: BoxDecoration(
                color: ColorStyles.whiteFFFFFF,
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.shadowFC6554,
                    offset: const Offset(0, -4),
                    blurRadius: 55.r,
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 60.h,
                    color: ColorStyles.whiteFFFFFF,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 28.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (owner != null) {
                              setState(() {
                                owner = null;
                              });
                            } else if (selectTask != null) {
                              setState(() {
                                selectTask = null;
                              });
                            } else {
                              widget.onBackPressed();
                            }
                          },
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Transform.rotate(
                              angle: pi,
                              child: SvgPicture.asset(
                                'assets/icons/arrow_right.svg',
                                height: 20.h,
                                width: 20.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        SizedBox(
                          width: 240.w,
                          height: 36.h,
                          child: CustomTextField(
                            fillColor: ColorStyles.greyF7F7F8,
                            prefixIcon: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/search1.svg',
                                  height: 12.h,
                                ),
                              ],
                            ),
                            hintText: 'Поиск',
                            textEditingController: TextEditingController(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 11.w, vertical: 11.h),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(width: 23.w),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoute.menu,
                                  arguments: [(page) {}]).then((value) {
                                if (value != null) {
                                  if (value == 'create') {
                                    widget.onSelect(0);
                                  }
                                  if (value == 'search') {
                                    widget.onSelect(1);
                                  }
                                  if (value == 'chat') {
                                    widget.onSelect(3);
                                  }
                                }
                              });
                            },
                            child:
                                SvgPicture.asset('assets/icons/category.svg')),
                      ],
                    ),
                  ),
                  Container(height: 30.h),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            if (selectTask == null)
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        children: [
                          Text(
                            'Все задачи',
                            style: CustomTextStyle.black_17_w800,
                          ),
                          const Spacer(),
                          ScaleButton(
                            bound: 0.01,
                            onTap: () => BlocProvider.of<SearchBloc>(context)
                                .add(OpenSlidingPanelEvent()),
                            child: SizedBox(
                              height: 40.h,
                              width: 90.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    height: 36.h,
                                    width: 100.h,
                                    decoration: BoxDecoration(
                                      color: ColorStyles.greyF7F7F8,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.h),
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/icons/candle.svg',
                                            height: 16.h,
                                            color: ColorStyles.yellowFFD70B,
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(
                                            'Фильтр',
                                            style: CustomTextStyle
                                                .black_13_w400_171716,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 15.h,
                                      width: 15.h,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(369.r),
                                        color: ColorStyles.black171716,
                                      ),
                                      child: Center(
                                        child: Text(
                                          '2',
                                          style: CustomTextStyle.white_9_w700,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Expanded(
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
                    ),
                  ],
                ),
              ),
            view(),
          ],
        ),
      ),
    );
  }

  Widget view() {
    if (owner != null) {
      return Expanded(child: ProfileView(owner: owner!));
    }
    if (selectTask != null) {
      return Expanded(
        child: TaskView(
          selectTask: selectTask!,
          openOwner: (owner) {
            this.owner = owner;
            setState(() {});
          },
          canSelect: true,
        ),
      );
    }
    return Container();
  }
}
