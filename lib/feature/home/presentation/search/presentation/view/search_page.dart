import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

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

  String? access;

  @override
  void initState() {
    super.initState();
    getTaskList();
  }

  void getTaskList() {
    BlocProvider.of<TasksBloc>(context).emit(TasksLoading());
    access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<TasksBloc>().add(
          GetTasksEvent(
            access,
            '',
            null,
            null,
            null,
            null,
            [],
            [],
            null,
            null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<TasksBloc>().add(GetTasksEvent(
          access,
          '',
          '',
          '',
          0,
          500000,
          [],
          [],
          null,
          null,
        ));

    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
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
                    padding: EdgeInsets.only(left: 15.w, right: 28.w),
                    child: Row(
                      children: [
                        CustomIconButton(
                          onBackPressed: () {
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
                          icon: SvgImg.arrowRight,
                        ),
                        Spacer(),
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
                            onChanged: (value) async {
                              context.read<TasksBloc>().add(GetTasksEvent(
                                    access,
                                    value,
                                    '',
                                    '',
                                    0,
                                    500000,
                                    [],
                                    [],
                                    null,
                                    null,
                                  ));
                            },
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 11.w, vertical: 11.h),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(width: 23.w),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoute.menu,
                                  arguments: [(page) {}, false]).then((value) {
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
            if (selectTask == null) SizedBox(height: 16.h),
            if (selectTask == null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    Text(
                      'Все задачи',
                      style: CustomTextStyle.black_18_w800,
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
                              child: Center(
                                child: BlocBuilder<TasksBloc, TasksState>(
                                    builder: (context, state) {
                                  if (state is TasksLoaded) {
                                    return Text(
                                      state.countFilter != 0
                                          ? state.countFilter.toString()
                                          : '0',
                                      style: CustomTextStyle.white_10_w700,
                                    );
                                  } else {
                                    return Text(
                                      '',
                                      style: CustomTextStyle.white_10_w700,
                                    );
                                  }
                                }),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                height: 15.h,
                                width: 15.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(369.r),
                                  color: ColorStyles.black171716,
                                ),
                                child: Center(
                                  child: Text(
                                    '2',
                                    style: CustomTextStyle.white_10_w700,
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
            if (selectTask == null) SizedBox(height: 30.h),
            if (selectTask == null)
              Expanded(
                child: BlocBuilder<TasksBloc, TasksState>(
                    builder: (context, state) {
                  taskList = BlocProvider.of<TasksBloc>(context).tasks;
                  if (state is TasksLoading) {
                    return SkeletonLoader(
                      items: 4,
                      baseColor: ColorStyles.whiteFFFFFF,
                      highlightColor: ColorStyles.greyF3F3F3,
                      builder: Container(
                        margin: EdgeInsets.only(
                            left: 24.w, right: 24.w, bottom: 24.w),
                        height: 100.h,
                        decoration: BoxDecoration(
                          color: ColorStyles.whiteFFFFFF,
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: ColorStyles.shadowFC6554,
                              offset: const Offset(0, -4),
                              blurRadius: 55.r,
                            )
                          ],
                        ),
                      ),
                    );
                  }
                  if (taskList.isEmpty) return Container();

                  return ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: taskList.map((e) => itemTask(e)).toList(),
                  );
                }),
              ),
            view(),
          ],
        ),
      ),
    );
  }

  Widget itemTask(Task task) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
      child: ScaleButton(
        bound: 0.01,
        onTap: () {
          setState(() {
            selectTask = task;
          });
        },
        child: Container(
          height: 100.h,
          decoration: BoxDecoration(
            color: ColorStyles.whiteFFFFFF,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.shadowFC6554,
                offset: const Offset(0, -4),
                blurRadius: 55.r,
              )
            ],
          ),
          width: 327.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
            child: Row(
              children: [
                Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: server + task.activities!.photo!,
                      height: 34.h,
                      width: 34.h,
                    ),
                    const Spacer(),
                  ],
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 235.w,
                      child: Text(
                        task.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: CustomTextStyle.black_14_w500_171716,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: 235.w,
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.region,
                                style: CustomTextStyle.black_12_w400,
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                task.dateEnd,
                                style: CustomTextStyle.grey_12_w400,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Text(
                            'до ${task.priceTo} ₽',
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          SizedBox(width: 5.w),
                          SizedBox(
                            width: 16.h,
                            child: SvgPicture.asset(
                              'assets/icons/card.svg',
                              height: 16.h,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
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
