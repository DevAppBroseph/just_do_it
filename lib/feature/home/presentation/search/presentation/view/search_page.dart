import 'dart:developer';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search_list.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class SearchPage extends StatefulWidget {
  final Function() onBackPressed;
  final Function(int) onSelect;
  final String text;

  const SearchPage({
    super.key,
    required this.onBackPressed,
    required this.onSelect,
    required this.text,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  Subcategory? selectSubCategory;
  List<Task> taskList = [];

  Task? selectTask;
  Owner? owner;

  String? access;
  List<String> historySearch = [];

  TextEditingController searchController = TextEditingController();

  bool searchList = false;
  List<String> searchChoose = [];

  @override
  void initState() {
    super.initState();
    searchController.text = widget.text;
    initFunc();
    getTaskList();
    if (Platform.isAndroid) {
      FirebaseDynamicLinks.instance.getInitialLink().then((value) {
        if (value != null) parseTripRefCode(value);
      });
    }
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      parseTripRefCode(event);
    });
  }
  
  void parseTripRefCode(PendingDynamicLinkData event) async {
    String? taskId = event.link.queryParameters['task_id'];
    taskList = await BlocProvider.of<TasksBloc>(context).tasks;
     if (taskId != null) {
     log(taskId.toString());
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TaskView(
          selectTask: taskList[0],
          openOwner: (owner) {
            this.owner = owner;
            setState(() {});
          },
          canSelect: true,
        ),
        ),
      );
    }
    taskList.clear();
  }

  void initFunc() {
    BlocProvider.of<TasksBloc>(context).emit(TasksLoading());
    access = BlocProvider.of<ProfileBloc>(context).access;
  }

  void getHistoryList() async {
    final List<String> list = await Storage().getListHistory();
    final List<String> listReversed = list.reversed.toList();
    searchChoose.clear();
    searchChoose.addAll(listReversed);
  }

  void getTaskList() {
    context.read<TasksBloc>().add(
          GetTasksEvent(
            access: access,
            query: searchController.text,
            dateEnd: null,
            dateStart: null,
            priceFrom: null,
            priceTo: null,
            subcategory: [],
            countFilter: null,
            customer: null,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    String? access = BlocProvider.of<ProfileBloc>(context).access;

    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              height: searchList ? 100.h : 130.h,
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
                        const Spacer(),
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
                            textEditingController: searchController,
                            onTap: () async {
                              if (owner != null) {
                                setState(() {
                                  owner = null;
                                });
                              } else if (selectTask != null) {
                                setState(() {
                                  selectTask = null;
                                });
                              }
                              setState(() {
                                searchList = true;
                              });
                              getHistoryList();
                            },
                            onFieldSubmitted: (value) {
                              setState(() {
                                searchList = false;
                              });
                              FocusScope.of(context).unfocus();
                              searchController.text = value;
                              Storage().setListHistory(value);
                              getTaskList();
                            },
                            onChanged: (value) async {
                              if (value.isEmpty) {
                                getHistoryList();
                              }
                              List<Activities> activities =
                                  BlocProvider.of<ProfileBloc>(context)
                                      .activities;
                              searchChoose.clear();
                              if (value.isNotEmpty) {
                                for (var element1 in activities) {
                                  for (var element2 in element1.subcategory) {
                                    if (element2.description!
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) &&
                                        !searchChoose.contains(element2
                                            .description!
                                            .toLowerCase())) {
                                      searchChoose.add(element2.description!);
                                    }
                                  }
                                }
                              }
                              setState(() {});
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
                  if (!searchList) Container(height: 30.h),
                ],
              ),
            ),
            if (selectTask == null && !searchList) SizedBox(height: 16.h),
            if (selectTask == null)
              searchList
                  ? SearchList(
                      heightScreen,
                      bottomInsets,
                      (value) {
                        setState(() {
                          searchList = false;
                        });
                        FocusScope.of(context).unfocus();
                        Storage().setListHistory(value);

                        searchController.text = value;
                        getTaskList();
                      },
                      searchChoose,
                    )
                  : Padding(
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
                            onTap: () {
                              BlocProvider.of<SearchBloc>(context)
                                  .add(OpenSlidingPanelEvent());
                            },
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
                                          SizedBox(width: 4.w),
                                          Text(
                                            'Фильтр',
                                            style: CustomTextStyle
                                                .black_14_w400_171716,
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
                                        child:
                                            BlocBuilder<TasksBloc, TasksState>(
                                                builder: (context, state) {
                                          if (state is TasksLoaded) {
                                            return Text(
                                              state.countFilter != 0 &&
                                                      state.countFilter != null
                                                  ? state.countFilter.toString()
                                                  : '0',
                                              style:
                                                  CustomTextStyle.white_10_w700,
                                            );
                                          } else {
                                            return Text(
                                              '',
                                              style:
                                                  CustomTextStyle.white_10_w700,
                                            );
                                          }
                                        }),
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
            if (selectTask == null && !searchList) SizedBox(height: 30.h),
            if (selectTask == null && !searchList)
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
                    children: taskList
                        .map((e) => itemTask(e, (task) {
                              setState(() {
                                selectTask = task;
                              });
                            }))
                        .toList(),
                  );
                }),
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
      log(selectTask!.id.toString());
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
