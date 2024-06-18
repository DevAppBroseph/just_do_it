import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/edit_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page_widgets/review_creation_widget.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page_widgets/review_overview_widget.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page_widgets/task_status_action_widget.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/move_task_to_top_button.dart';
import 'package:just_do_it/helpers/data_formatter.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:open_file/open_file.dart';
import 'package:scale_button/scale_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskPage extends StatefulWidget {
  final Task task;
  final Function(Owner?) openOwner;
  final bool canEdit;
  final bool canOnTop;
  final bool fromFav;
  final bool showResponses;

  const TaskPage({
    super.key,
    required this.task,
    required this.openOwner,
    this.canEdit = false,
    this.fromFav = false,
    this.canOnTop = true,
    this.showResponses = false,
  });

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  late final isTaskOwner = user?.id == widget.task.owner?.id;
  late Task task;
  UserRegModel? user;
  late Future<Task?> _data;

  @override
  void initState() {
    super.initState();
    task = widget.task;
    user = BlocProvider.of<ProfileBloc>(context).user;
    _data = Repository()
        .getTaskById(task.id!, BlocProvider.of<ProfileBloc>(context).access);
    context.read<ChatBloc>().stream.listen((state) {
      if (state is SocketEventReceivedState) {
        getTask();
      }
    });
  }

  void getTask() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    task = (await (Repository().getTaskById(task.id!, access)))!;
    if (mounted) {
      setState(() {});
    }
  }

  void getTaskList() {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
  }

  GlobalKey globalKey = GlobalKey();
  bool showMore = false;
  FavouriteOffers? selectFavouriteTask;
  Owner? ownerw;
  bool taskSnapshotWasInitialized = false;
  getPersonAndTask(bool res, UserRegModel? user) {
    context.read<TasksBloc>().add(UpdateTaskEvent());
    BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
    if (res) Navigator.pop(context);
    Navigator.pop(context);
  }

  void assignSnapshotDataToTaskWhenInitialized(AsyncSnapshot<Task?> snapshot) {
    if (!taskSnapshotWasInitialized && snapshot.data != null) {
      task = snapshot.data!;
      taskSnapshotWasInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LightAppColors.greyPrimary,
      body: FutureBuilder(
          future: _data,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text('error'.tr()),
              );
            }
            assignSnapshotDataToTaskWhenInitialized(snapshot);
            return MediaQuery(
              data: const MediaQueryData(
                textScaler: TextScaler.linear(1.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ListView(
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        if (task.isBanned == null || !task.isBanned!)
                          Text(
                            task.status.isInactive
                                ? 'close'.tr()
                                : 'openly'.tr(),
                            style: CustomTextStyle.sf13w400(
                                LightAppColors.blackSecondary),
                          ),
                        if (task.isBanned != null && task.isBanned!)
                          Text(
                            'blocked'.tr(),
                            style: CustomTextStyle.sf12w400(
                                LightAppColors.redSecondary),
                          ),
                        const Spacer(),
                        if (user?.id != task.owner?.id)
                          BlocBuilder<TasksBloc, TasksState>(
                              buildWhen: (previous, current) {
                            if (current is UpdateTask) {
                              getTask();
                              return true;
                            }
                            if (current is TasksLoaded) {
                              getTask();
                              return true;
                            }
                            if (previous != current) {
                              return true;
                            }
                            return false;
                          }, builder: (context, state) {
                            return BlocBuilder<FavouritesBloc, FavouritesState>(
                                buildWhen: (previous, current) {
                              return true;
                            }, builder: (context, state) {
                              if (state is FavouritesLoaded) {
                                return GestureDetector(
                                  onTap: () async {
                                    final access = Storage().getAccessToken();

                                    if (task.isLiked != null) {
                                      Repository()
                                          .deleteLikeOrder(
                                              task.isLiked!, access!)
                                          .then((isDeleteSuccessful) {
                                        if (isDeleteSuccessful) {
                                          setState(() {
                                            task.isLiked = null;
                                          });
                                          getTaskList();
                                        }
                                      });
                                    } else {
                                      task.isLiked = -1;
                                      final isSuccess = await Repository()
                                          .addLikeOrder(task.id!, access!);
                                      if (isSuccess) {
                                        task = (await Repository()
                                            .getTaskById(task.id!, access))!;
                                        setState(() {});
                                        getTaskList();
                                      }
                                    }
                                  },
                                  child: task.isLiked != null
                                      ? SvgPicture.asset(
                                          'assets/icons/heart_yellow.svg',
                                          height: 20.h,
                                        )
                                      : SvgPicture.asset(
                                          'assets/icons/heart.svg',
                                          height: 20.h,
                                        ),
                                );
                              }
                              return Container();
                            });
                          }),
                        SizedBox(width: 10.w),
                        GestureDetector(
                          onTap: () => taskMoreDialog(
                              context,
                              getWidgetPosition(globalKey),
                              (index) {},
                              task,
                              user),
                          child: SvgPicture.asset(
                            'assets/icons/more-circle.svg',
                            key: globalKey,
                            height: 20.h,
                            color: LightAppColors.greySecondary,
                          ),
                        ),
                      ],
                    ),
                    if (task.status != TaskStatus.completed && widget.canEdit)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                final needsUpdateTaskData =
                                    await Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return EditTasks(
                                                  task: task,
                                                  customer: task.isTask!);
                                            },
                                          ),
                                        ) ??
                                        false;
                                if (needsUpdateTaskData) {
                                  getTask();
                                }
                              },
                              child: Text(
                                'edit'.tr(),
                                style: CustomTextStyle.sf13w400(
                                    LightAppColors.blackSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (widget.canEdit)
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.h),
                        child: Row(
                          children: [
                            const Spacer(),
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text('delete'.tr()),
                                      content: Text(
                                          'do_you_confirm_the_deletion_of_the_order'
                                              .tr()),
                                      actions: [
                                        CupertinoButton(
                                          child: Text('cancel'.tr()),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        CupertinoButton(
                                          child: Text(
                                            'delete'.tr(),
                                            style: CustomTextStyle.sf17w400(
                                                LightAppColors.redSecondary),
                                          ),
                                          onPressed: () async {
                                            final access =
                                                Storage().getAccessToken();
                                            final res = await Repository()
                                                .deleteTask(task, access!);
                                            getPersonAndTask(res, user);
                                          },
                                        )
                                      ],
                                    );
                                  },
                                );
                              },
                              child: Text(
                                'delete'.tr(),
                                style: CustomTextStyle.sf13w400(Colors.red),
                              ),
                            ),
                          ],
                        ),
                      ),
                    SizedBox(
                      height: 12.h,
                    ),
                    if (widget.canOnTop && !(task.isBanned ?? true))
                      MoveTaskToTopButton(
                        task: task,
                        user: user,
                        updateTask: () => getTask(),
                      ),
                    Text(
                      '${DataFormatter.addSpacesToNumber(task.priceTo)} ${DataFormatter.convertCurrencyNameIntoSymbol(task.currency?.name)} ',
                      style: CustomTextStyle.sf17w400(
                              LightAppColors.blackSecondary)
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 12.h),
                    Text(task.name,
                        style: CustomTextStyle.sf18w800(
                            LightAppColors.blackSecondary)),
                    SizedBox(height: 18.h),
                    if (task.category != null)
                      Row(
                        children: [
                          if (task.category?.photo != null)
                            Expanded(
                              child: Image.network(
                                task.category?.photo ?? '',
                                height: 24.h,
                              ),
                            ),
                          SizedBox(width: 8.h),
                          SizedBox(
                            width: 260,
                            child: Text(
                              '${user?.rus ?? true && context.locale.languageCode == 'ru' ? task.category?.description ?? '-' : task.category?.engDescription ?? '-'}, ${user?.rus ?? true && context.locale.languageCode == 'ru' ? task.subcategory?.description ?? '-' : task.subcategory?.engDescription}',
                              style: CustomTextStyle.sf17w400(
                                  LightAppColors.blackError),
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 18.h),
                    SizedBox(height: 8.h),
                    Container(
                      decoration: BoxDecoration(
                        color: LightAppColors.whitePrimary,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: LightAppColors.shadowPrimary,
                            offset: const Offset(0, 4),
                            blurRadius: 45.r,
                          )
                        ],
                      ),
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 12.h),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'description'.tr(),
                              style: CustomTextStyle.sf18w800(
                                  LightAppColors.blackSecondary),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              task.description,
                              overflow: TextOverflow.ellipsis,
                              maxLines: showMore ? 10000000 : 3,
                              style: CustomTextStyle.sf17w400(
                                  LightAppColors.blackError),
                            ),
                            if (!showMore) SizedBox(height: 8.h),
                            if (!showMore && task.description.length > 105)
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showMore = true;
                                  });
                                },
                                child: Text(
                                  'show_more'.tr(),
                                  style: CustomTextStyle.sf12w400(
                                      LightAppColors.blueSecondary),
                                ),
                              ),
                            if (task.files != null && task.files!.isNotEmpty)
                              SizedBox(
                                height: 60.h,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: task.files!.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    bool file = false;
                                    if (task.files![index].linkUrl != null &&
                                        (task.files![index].linkUrl!
                                                .contains('.png') ||
                                            task.files![index].linkUrl!
                                                .contains('.jpg') ||
                                            task.files![index].linkUrl!
                                                .contains('.jpeg'))) {
                                      file = false;
                                    } else if (task.files![index].linkUrl !=
                                            null &&
                                        (task.files![index].linkUrl!
                                                .contains('.pdf') ||
                                            task.files![index].linkUrl!
                                                .contains('.doc') ||
                                            task.files![index].linkUrl!
                                                .contains('.docx'))) {
                                      file = true;
                                    } else if (task.files![index].type ==
                                            'pdf' ||
                                        task.files![index].type == 'doc' ||
                                        task.files![index].type == 'docx') {
                                      file = true;
                                    }

                                    if (file) {
                                      return SizedBox(
                                        height: 60.h,
                                        width: 60.h,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                if (task.files![index].file !=
                                                    null) {
                                                  OpenFile.open(widget
                                                      .task
                                                      .files![index]
                                                      .file!
                                                      .path);
                                                } else {
                                                  launch(widget
                                                          .task
                                                          .files![index]
                                                          .linkUrl!
                                                          .contains(server)
                                                      ? widget
                                                          .task
                                                          .files![index]
                                                          .linkUrl!
                                                      : server +
                                                          task.files![index]
                                                              .linkUrl!);
                                                }
                                              },
                                              child: Container(
                                                height: 50.h,
                                                width: 50.h,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    boxShadow: const [
                                                      BoxShadow(
                                                          color: Colors.black)
                                                    ],
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.r)),
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    SvgImg.documentText,
                                                    height: 25.h,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        if (task.files![index].file != null) {
                                          OpenFile.open(
                                              task.files![index].file!.path);
                                        } else {
                                          launch(task.files![index].linkUrl!
                                                  .contains(server)
                                              ? task.files![index].linkUrl!
                                              : server +
                                                  task.files![index].linkUrl!);
                                        }
                                      },
                                      child: SizedBox(
                                        height: 60.h,
                                        width: 60.h,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            SizedBox(
                                              height: 50.h,
                                              width: 50.h,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10.r),
                                                child:
                                                    task.files![index].byte !=
                                                            null
                                                        ? Image.memory(
                                                            task.files![index]
                                                                .byte!,
                                                            fit: BoxFit.cover,
                                                          )
                                                        : CachedNetworkImage(
                                                            imageUrl: task
                                                                .files![index]
                                                                .linkUrl!,
                                                            fit: BoxFit.cover,
                                                          ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            SizedBox(
                              height: 15.h,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 150.w,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'term_of_execution'.tr(),
                                        style: CustomTextStyle.sf15w400(
                                            LightAppColors.greySecondary),
                                      ),
                                      SizedBox(height: 6.h),
                                      FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          "${_textData(task.dateStart)}-${_textData(task.dateEnd)}",
                                          maxLines: 1,
                                          style: CustomTextStyle.sf17w400(
                                              LightAppColors.blackError),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 5.w,
                                ),
                                SizedBox(
                                  height: 40.h,
                                  child: const VerticalDivider(
                                    color: LightAppColors.greyActive,
                                    thickness: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'region'.tr(),
                                        style: CustomTextStyle.sf15w400(
                                            LightAppColors.greySecondary),
                                      ),
                                      SizedBox(height: 6.h),
                                      AutoSizeText(
                                        _textCountry(task, user),
                                        wrapWords: false,
                                        style: CustomTextStyle.sf17w400(
                                            LightAppColors.blackError),
                                        maxLines: null,
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
                    SizedBox(height: 20.h),
                    BlocBuilder<TasksBloc, TasksState>(
                        buildWhen: (previous, current) {
                      if (current is UpdateTask) {
                        getTask();
                        return true;
                      }
                      if (previous != current) {
                        return true;
                      }
                      return false;
                    }, builder: (context, state) {
                      return ScaleButton(
                        bound: 0.02,
                        onTap: () {
                          if (user!.isBanned!) {
                            banDialog(context,
                                'profile_viewing_is_currently_restricted'.tr());
                          } else {
                            widget.openOwner(task.owner);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: LightAppColors.whitePrimary,
                            borderRadius: BorderRadius.circular(20.r),
                            boxShadow: [
                              BoxShadow(
                                color: LightAppColors.shadowPrimary,
                                offset: const Offset(0, 4),
                                blurRadius: 45.r,
                              )
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 13.h),
                          child: Row(
                            children: [
                              if (task.owner?.photo != null)
                                SizedBox(
                                  width: 48.w,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(1000.r),
                                    child: Image.network(
                                      task.owner!.photo!,
                                      height: 48.h,
                                      width: 48.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 15.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.isTask ?? false
                                          ? 'customer'.tr()
                                          : 'executor'.tr(),
                                      style: CustomTextStyle.sf13w400(
                                          LightAppColors.greySecondary),
                                    ),
                                    SizedBox(
                                      width: 260.w,
                                      child: AutoSizeText(
                                        "${task.owner?.firstname ?? '-'} ${task.owner?.lastname ?? '-'}",
                                        wrapWords: false,
                                        style: CustomTextStyle.sf18w800(
                                                LightAppColors.blackSecondary)
                                            .copyWith(
                                                fontWeight: FontWeight.w600),
                                        maxLines: 2,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Row(
                                      children: [
                                        Text(
                                          'rating'.tr(),
                                          style: CustomTextStyle.sf15w400(
                                              LightAppColors.greySecondary),
                                        ),
                                        SizedBox(width: 8.w),
                                        SvgPicture.asset(
                                            'assets/icons/star.svg'),
                                        SizedBox(width: 4.w),
                                        Text(
                                          task.owner?.ranking == null
                                              ? '0'
                                              : task.owner!.ranking.toString(),
                                          style: CustomTextStyle.sf17w400(
                                                  LightAppColors.blackSecondary)
                                              .copyWith(
                                                  fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 20.h),
                    if (!isTaskOwner)
                      CustomButton(
                        onTap: () async {
                          if (user!.isBanned!) {
                            banDialog(context,
                                'access_to_chat_is_currently_restricted'.tr());
                          } else {
                            final chatBloc = BlocProvider.of<ChatBloc>(context);
                            chatBloc.editShowPersonChat(false);
                            chatBloc.editChatId(task.chatId);

                            // final idChat =
                            await Navigator.of(context).pushNamed(
                              AppRoute.personalChat,
                              arguments: [
                                '${task.chatId}',
                                '${task.owner?.firstname ?? ''} ${task.owner?.lastname ?? ''}',
                                '${task.owner?.id}',
                                '${task.owner?.photo}',
                                task.category?.id,
                              ],
                            );
                            chatBloc.editShowPersonChat(true);
                            chatBloc.editChatId(null);
                          }
                        },
                        btnColor: LightAppColors.yellowPrimary,
                        textLabel: Text(
                          'write'.tr(),
                          style: CustomTextStyle.sf17w600(
                              LightAppColors.blackSecondary),
                        ),
                      ),
                    SizedBox(height: 18.h),
                    TaskStatusActionWidget(
                      task: task,
                      isTaskOwner: isTaskOwner,
                      fromFav: widget.fromFav,
                      updateTask: getTask,
                    ),
                    SizedBox(height: 18.h),
                    ReviewCreationWidget(
                      task: task,
                      isTaskOwner: isTaskOwner,
                      openOwner: widget.openOwner,
                    ),
                    if (widget.showResponses)
                      ReviewOverviewWidget(
                        task: task,
                        isTaskOwner: isTaskOwner,
                        openOwner: widget.openOwner,
                        canEdit: widget.canEdit,
                        getTask: getTask,
                        onNewUser: (newUser) {
                          setState(() {
                            user = newUser;
                          });
                        },
                      ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  String _textData(String data) {
    String text = '';
    String day = '';
    String month = '';
    String year = '';
    List<String> parts = [];
    parts = data.split('-');
    year = parts[0].trim();
    day = parts[2].trim();
    month = parts[1].trim();
    text = '$day.$month.$year';
    return text;
  }

  String _textCountry(Task task, UserRegModel? user) {
    var text = '';
    for (var country in task.countries) {
      text += '${user?.rus ?? true ? country.name : country.engName}, ';
    }
    for (var region in task.regions) {
      text += '${user?.rus ?? true ? region.name : region.engName}, ';
    }
    for (var town in task.towns) {
      text += '${user?.rus ?? true ? town.name : town.engName}, ';
    }
    if (text.isNotEmpty) text = text.substring(0, text.length - 2);
    if (text.isEmpty) text = 'all_countries_selected'.tr();

    return text;
  }
}
