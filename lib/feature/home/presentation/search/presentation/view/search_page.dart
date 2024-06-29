import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search_list.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/task/task_subcategory.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:skeleton_loader/skeleton_loader.dart';

class SearchPage extends StatefulWidget {
  final Function() onBackPressed;
  final Function() clearId;
  final Function(int) onSelect;
  final String text;
  final int? taskId;

  const SearchPage({
    super.key,
    required this.onBackPressed,
    required this.clearId,
    required this.onSelect,
    required this.text,
    this.taskId,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TaskSubcategory? selectSubCategory;
  List<Task> taskList = [];

  Task? selectTask;
  Owner? owner;
  late UserRegModel? user;
  String? access;
  List<String> historySearch = [];

  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool searchListEnable = false;
  bool searchList = false;
  List<String> searchChoose = [];

  double lastPosition = 0;

  @override
  void initState() {
    super.initState();
    searchController.text = widget.text;
    initFunc();
    getTaskList();
    if (widget.taskId != null) getTask();
    final access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
    user = BlocProvider.of<ProfileBloc>(context).user;

    scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      final nextPageUrl = BlocProvider.of<TasksBloc>(context).nextPageUrl;
      if (nextPageUrl != null) {
        context.read<TasksBloc>().add(LoadMoreTasksEvent(nextPageUrl));
      }
    }
  }

  void initFunc() {
    BlocProvider.of<TasksBloc>(context).emit(TasksLoading());
    access = BlocProvider.of<ProfileBloc>(context).access;
  }

  void getTaskList() {
    context.read<TasksBloc>().add(
          GetTasksEvent(
            query: searchController.text,
            dateEnd: null,
            dateStart: null,
            priceFrom: null,
            priceTo: null,
            subcategory: [],
            countFilter: null,
            customer: null,
            access: access,
          ),
        );
  }

  void getTask() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    final task = await Repository().getTaskById(widget.taskId!, access);
    widget.clearId();
    setState(() {
      selectTask = task;
    });
  }

  void getHistoryList() async {
    final List<String> list = await Storage().getListHistory();
    final List<String> listReversed = list.reversed.toList();
    searchChoose.clear();
    searchChoose.addAll(listReversed);
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor:
          SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
              ? DarkAppColors.whitePrimary
              : LightAppColors.whitePrimary,
      body: MediaQuery(
        data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
        child: BlocBuilder<ChatBloc, ChatState>(buildWhen: (previous, current) {
          if (current is UpdateListMessageItemState) {
            if (current.chatId != null) {
              for (int i = 0; i < taskList.length; i++) {
                if (taskList[i].id == selectTask!.id) {
                  taskList[i].chatId = current.chatId;
                  selectTask?.chatId = current.chatId;
                  break;
                }
              }
              return true;
            }
            return false;
          }
          return false;
        }, builder: (context, snapshot) {
          return Column(
            children: [
              Container(
                height: searchList ? 100.h : 120.h,
                decoration: const BoxDecoration(),
                child: Column(
                  children: [
                    Container(
                      height: 60.h,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 15.w, right: 28.w),
                      child: Row(
                        children: [
                          searchListEnable
                              ? CustomIconButton(
                                  onBackPressed: () {
                                    setState(() {
                                      searchListEnable = false;
                                      searchList = false;
                                    });
                                  },
                                  icon: SvgImg.arrowRight,
                                )
                              : CustomIconButton(
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
                          searchListEnable
                              ? SizedBox(
                                  width: 240.w,
                                  height: 36.h,
                                  child: CustomTextField(
                                    fillColor: LightAppColors.greyAccent,
                                    prefixIcon: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/search1.svg',
                                          height: 12.h,
                                        ),
                                      ],
                                    ),
                                    hintText: 'search'.tr(),
                                    textEditingController: searchController,
                                    onTap: () async {
                                      owner = null;
                                      selectTask = null;
                                      searchList = true;
                                      setState(() {});
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
                                      List<TaskCategory> activities =
                                          BlocProvider.of<ProfileBloc>(context)
                                              .activities;
                                      searchChoose.clear();
                                      if (value.isNotEmpty) {
                                        for (var element1 in activities) {
                                          for (var element2
                                              in element1.subcategory) {
                                            if (element2.description!
                                                    .toLowerCase()
                                                    .contains(
                                                        value.toLowerCase()) &&
                                                !searchChoose.contains(element2
                                                    .description!
                                                    .toLowerCase())) {
                                              searchChoose
                                                  .add(element2.description!);
                                            }
                                          }
                                        }
                                      }
                                      setState(() {});
                                    },
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 11.w, vertical: 11.h),
                                  ),
                                )
                              : user != null
                                  ? Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                AppRoute.notification);
                                          },
                                          child: Stack(
                                            alignment: Alignment.topRight,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/notification_main.svg',
                                              ),
                                              user!.hasNotifications!
                                                  ? Container(
                                                      height: 10.w,
                                                      width: 10.w,
                                                      decoration: BoxDecoration(
                                                        color: LightAppColors
                                                            .yellowSecondary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20.r),
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        GestureDetector(
                                          onTap: () async {
                                            setState(() {
                                              searchListEnable = true;
                                            });
                                          },
                                          child: SvgPicture.asset(
                                              'assets/icons/search3.svg'),
                                        ),
                                      ],
                                    )
                                  : Container(),
                          SizedBox(width: 10.w),
                          GestureDetector(
                              onTap: () async {
                                final accessToken = Storage().getAccessToken();
                                if (context.mounted) {
                                  if (accessToken != null) {
                                    Navigator.of(context)
                                        .pushNamed(AppRoute.menu, arguments: [
                                      (page) {},
                                      false
                                    ]).then((value) {
                                      if (value != null) {
                                        if (value == 'create') {
                                          widget.onSelect(0);
                                        }
                                        if (value == 'search') {
                                          widget.onSelect(1);
                                        } else if (value == 'tasks') {
                                          widget.onSelect(2);
                                        }
                                        if (value == 'chat') {
                                          widget.onSelect(3);
                                        }
                                      }
                                    });
                                  } else {
                                    Navigator.of(context)
                                        .pushNamed(AppRoute.auth);
                                  }
                                }
                              },
                              child: SvgPicture.asset(
                                  'assets/icons/category2.svg')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
                              'all_tasks'.tr(),
                              style: SettingsScope.themeOf(context)
                                  .theme
                                  .getStyle(
                                      (lightStyles) =>
                                          lightStyles.sf19w800BlackSec,
                                      (darkStyles) =>
                                          darkStyles.sf19w800BlackSec),
                            ),
                            const Spacer(),
                            Flexible(
                              child: ScaleButton(
                                bound: 0.01,
                                onTap: () {
                                  BlocProvider.of<SearchBloc>(context)
                                      .add(OpenSlidingPanelEvent());
                                },
                                child: SizedBox(
                                  height: 40.h,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Container(
                                        height: 36.h,
                                        width: 110.h,
                                        decoration: BoxDecoration(
                                          color: SettingsScope.themeOf(context)
                                                      .theme
                                                      .mode ==
                                                  ThemeMode.dark
                                              ? DarkAppColors.whitePrimary
                                              : LightAppColors.whitePrimary,
                                          //LightAppColors.greyAccent,
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.h),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/candle.svg',
                                                height: 16.h,
                                                color: LightAppColors
                                                    .yellowSecondary,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                'filter'.tr(),
                                                style: SettingsScope.themeOf(
                                                        context)
                                                    .theme
                                                    .getStyle(
                                                        (lightStyles) =>
                                                            lightStyles
                                                                .sf17w400BlackSec,
                                                        (darkStyles) => darkStyles
                                                            .sf17w400BlackSec),
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
                                            color:
                                                LightAppColors.blackSecondary,
                                          ),
                                          child: Center(
                                            child: BlocBuilder<TasksBloc,
                                                    TasksState>(
                                                builder: (context, state) {
                                              if (state is TasksLoaded) {
                                                return Text(
                                                  state.countFilter != 0 &&
                                                          state.countFilter !=
                                                              null
                                                      ? state.countFilter
                                                          .toString()
                                                      : '0',
                                                  style:
                                                      CustomTextStyle.sf11w400(
                                                          LightAppColors
                                                              .whitePrimary),
                                                );
                                              } else {
                                                return Text(
                                                  '',
                                                  style:
                                                      CustomTextStyle.sf11w400(
                                                          LightAppColors
                                                              .whitePrimary),
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
                            ),
                          ],
                        ),
                      ),
              if (selectTask == null && !searchList) SizedBox(height: 30.h),
              Expanded(
                child: Stack(
                  children: [
                    BlocBuilder<TasksBloc, TasksState>(
                      builder: (context, state) {
                        taskList = BlocProvider.of<TasksBloc>(context).tasks;

                        if (state is TasksLoading) {
                          return SkeletonLoader(
                            items: 4,
                            baseColor: LightAppColors.whitePrimary,
                            highlightColor: LightAppColors.greyActive,
                            builder: Container(
                              margin: EdgeInsets.only(
                                  left: 24.w, right: 24.w, bottom: 24.w),
                              height: 100.h,
                              decoration: BoxDecoration(
                                color:
                                    SettingsScope.themeOf(context).theme.mode ==
                                            ThemeMode.dark
                                        ? DarkAppColors.whitePrimary
                                        : LightAppColors.whitePrimary,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: LightAppColors.shadowPrimary,
                                    offset: const Offset(0, -4),
                                    blurRadius: 55.r,
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                        if (state is TasksLoaded || state is TasksLoadingMore) {
                          return ListView(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            controller: scrollController,
                            padding: EdgeInsets.zero,
                            children: taskList
                                .map((e) => itemTask(
                                      e,
                                      (task) {
                                        if (Storage.isAuthorized) {
                                          setState(() {
                                            selectTask = task;

                                            lastPosition =
                                                scrollController.offset;
                                          });
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed(AppRoute.auth);
                                        }
                                      },
                                      BlocProvider.of<ProfileBloc>(context)
                                          .user,
                                      context,
                                    ))
                                .toList(),
                          );
                        }
                        if (state is TasksLoadingMore) {
                          return Column(
                            children: [
                              ListView(
                                shrinkWrap: true,
                                physics: const ClampingScrollPhysics(),
                                controller: scrollController,
                                padding: EdgeInsets.zero,
                                children: taskList
                                    .map((e) => itemTask(
                                          e,
                                          (task) {
                                            if (Storage.isAuthorized) {
                                              setState(() {
                                                selectTask = task;

                                                lastPosition =
                                                    scrollController.offset;
                                              });
                                            } else {
                                              Navigator.of(context)
                                                  .pushNamed(AppRoute.auth);
                                            }
                                          },
                                          BlocProvider.of<ProfileBloc>(context)
                                              .user,
                                          context,
                                        ))
                                    .toList(),
                              ),
                              SizedBox(height: 10.h),
                              const Center(
                                child: const CircularProgressIndicator(),
                              ),
                              SizedBox(height: 20.h),
                            ],
                          );
                        }
                        return Container();
                      },
                    ),
                    view(),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget view() {
    if (owner != null) {
      return Scaffold(
        backgroundColor: LightAppColors.greyPrimary,
        body: ProfileView(owner: owner!),
      );
    }

    if (selectTask != null) {
      return TaskPage(
        task: selectTask!,
        openOwner: (owner) {
          this.owner = owner;
          setState(() {});
        },
      );
    }
    return const SizedBox();
  }
}
