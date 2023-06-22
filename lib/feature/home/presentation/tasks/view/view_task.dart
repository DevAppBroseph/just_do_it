import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/view/auth_page.dart';
import 'package:just_do_it/feature/auth/widget/formatter_upper.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply/reply_bloc.dart' as rep;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply_from_favourite/reply_fav_bloc.dart'
    as repf;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response/response_bloc.dart' as res;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response_from_favourite/response_fav_bloc.dart'
    as resf;
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/edit_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:open_file/open_file.dart';
import 'package:scale_button/scale_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskView extends StatefulWidget {
  Task selectTask;
  final Function(Owner?) openOwner;
  final bool canSelect;
  final bool canEdit;
  final bool fromFav;
  TaskView({
    super.key,
    required this.selectTask,
    required this.openOwner,
    this.canSelect = false,
    this.canEdit = false,
    this.fromFav = false,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  double? reviewRating;
  Task? selectTask;
  @override
  void initState() {
    super.initState();
    getTask();
    selectTask = widget.selectTask;
  }

  void getTask() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    if (await Repository().getTaskById(widget.selectTask.id!, access) != null) {
      widget.selectTask = (await Repository().getTaskById(widget.selectTask.id!, access))!;
    }
  }

  void getTaskList() {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<TasksBloc>().add(
          GetTasksEvent(
            access: access,
          ),
        );
    context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
  }

  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController descriptionTextController1 = TextEditingController();
  TextEditingController descriptionTextController2 = TextEditingController();
  TextEditingController descriptionTextController3 = TextEditingController();
  bool? isLiked;
  String? idWithChat;
  GlobalKey globalKey = GlobalKey();
  bool showMore = false;
  bool proverka = false;
  List<FavouriteOffers>? favouritesOrders;
  FavouriteOffers? selectFavouriteTask;

  getPersonAndTask(bool res, UserRegModel? user) {
    context.read<TasksBloc>().add(UpdateTaskEvent());

    BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));

    if (res) Navigator.pop(context);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    log(' (${widget.canSelect} ffh ${widget.selectTask.owner?.id} && ${widget.selectTask.isAnswered == null})');
    UserRegModel? user = BlocProvider.of<ProfileBloc>(context).user;
    return Container(
      color: ColorStyles.greyEAECEE,
      child: MediaQuery(
        data: const MediaQueryData(textScaleFactor: 1.0),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: ListView(
            physics: const ClampingScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    'openly'.tr(),
                    style: CustomTextStyle.black_12_w400,
                  ),
                  const Spacer(),
                  if (user?.id != selectTask?.owner?.id)
                    BlocBuilder<TasksBloc, TasksState>(buildWhen: (previous, current) {
                      if (current is UpdateTask) {
                        getTask();
                        return true;
                      }
                      if (previous != current) {
                        return true;
                      }
                      return false;
                    }, builder: (context, state) {
                      return BlocBuilder<FavouritesBloc, FavouritesState>(buildWhen: (previous, current) {
                        return true;
                      }, builder: (context, state) {
                        if (state is FavouritesLoaded) {
                          if (selectTask?.asCustomer == false) {
                            favouritesOrders = state.favourite?.favouriteOffers;
                          } else {
                            favouritesOrders = state.favourite?.favouriteOrder;
                          }
                          return GestureDetector(
                            onTap: () async {
                              if (selectTask?.isLiked != null) {
                                final access = await Storage().getAccessToken();
                                if (selectTask?.isLiked != null) {
                                  await Repository().deleteLikeOrder(selectTask!.isLiked!, access!);
                                }
                                getTaskList();
                                setState(() {
                                  selectTask?.isLiked = null;
                                });
                              } else {
                                proverka = true;
                                final access = await Storage().getAccessToken();

                                if (selectTask?.id != null) {
                                  await Repository().addLikeOrder(selectTask!.id!, access!);
                                }
                                selectTask = (await Repository().getTaskById(selectTask!.id!, access))!;
                                getTaskList();
                                setState(() {});
                              }
                            },
                            child: selectTask?.isLiked != null
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
                    onTap: () => taskMoreDialog(context, getWidgetPosition(globalKey), (index) {}, widget.selectTask),
                    child: SvgPicture.asset(
                      'assets/icons/more-circle.svg',
                      key: globalKey,
                      height: 20.h,
                      color: ColorStyles.greyBDBDBD,
                    ),
                  ),
                ],
              ),
              if (widget.canEdit)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return EditTasks(task: widget.selectTask);
                              },
                            ),
                          );
                        },
                        child: Text(
                          'edit'.tr(),
                          style: CustomTextStyle.black_12_w400,
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
                                content: Text('do_you_confirm_the_deletion_of_the_order'.tr()),
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
                                      style: CustomTextStyle.red_16_w400,
                                    ),
                                    onPressed: () async {
                                      final access = await Storage().getAccessToken();
                                      final res = await Repository().deleteTask(widget.selectTask, access!);
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
                          style: CustomTextStyle.black_12_w400.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 12.h,
              ),
              if (widget.selectTask.currency?.name == null)
                Text(
                  '${'before'.tr()} ${_textCurrency(widget.selectTask.priceTo)} ',
                  style: CustomTextStyle.black_17_w500_171716,
                ),
              if (widget.selectTask.currency?.name == 'Дирхам')
                Text(
                  '${'before'.tr()} ${_textCurrency(widget.selectTask.priceTo)} AED',
                  style: CustomTextStyle.black_17_w500_171716,
                ),
              if (widget.selectTask.currency?.name == 'Российский рубль')
                Text(
                  '${'before'.tr()} ${_textCurrency(widget.selectTask.priceTo)}  ₽',
                  style: CustomTextStyle.black_17_w500_171716,
                ),
              if (widget.selectTask.currency?.name == 'Доллар США')
                Text(
                  '${'before'.tr()} ${_textCurrency(widget.selectTask.priceTo)} \$',
                  style: CustomTextStyle.black_17_w500_171716,
                ),
              if (widget.selectTask.currency?.name == 'Евро')
                Text(
                  '${'before'.tr()} ${_textCurrency(widget.selectTask.priceTo)} €',
                  style: CustomTextStyle.black_17_w500_171716,
                ),
              SizedBox(height: 12.h),
              Text(
                widget.selectTask.name,
                style: CustomTextStyle.black_17_w800_171716,
              ),
              SizedBox(height: 18.h),
              if (widget.selectTask.activities != null)
                Row(
                  children: [
                    if (widget.selectTask.activities?.photo != null)
                      Image.network(
                        widget.selectTask.activities?.photo ?? '',
                        height: 24.h,
                      ),
                    SizedBox(width: 8.h),
                    SizedBox(
                      width: 260,
                      child: Text(
                        '${widget.selectTask.activities?.description ?? '-'}, ${widget.selectTask.subcategory?.description ?? '-'}',
                        style: CustomTextStyle.black_12_w400_292D32,
                        softWrap: true,
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 18.h),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: ColorStyles.whiteFFFFFF,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: ColorStyles.shadowFC6554,
                      offset: const Offset(0, 4),
                      blurRadius: 45.r,
                    )
                  ],
                ),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'description'.tr(),
                        style: CustomTextStyle.black_17_w800_171716,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        widget.selectTask.description,
                        overflow: TextOverflow.ellipsis,
                        maxLines: showMore ? 10000000 : 3,
                        style: CustomTextStyle.black_12_w400_292D32,
                      ),
                      if (!showMore) SizedBox(height: 8.h),
                      if (!showMore && widget.selectTask.description.length > 105)
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showMore = true;
                            });
                          },
                          child: Text(
                            'show_more'.tr(),
                            style: CustomTextStyle.blue_11_w400_336FEE,
                          ),
                        ),
                      if (widget.selectTask.files != null && widget.selectTask.files!.isNotEmpty)
                        SizedBox(
                          height: 60.h,
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: widget.selectTask.files!.length,
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              bool file = false;
                              if (widget.selectTask.files![index].linkUrl != null &&
                                  (widget.selectTask.files![index].linkUrl!.contains('.png') ||
                                      widget.selectTask.files![index].linkUrl!.contains('.jpg') ||
                                      widget.selectTask.files![index].linkUrl!.contains('.jpeg'))) {
                                file = false;
                              } else if (widget.selectTask.files![index].linkUrl != null &&
                                  (widget.selectTask.files![index].linkUrl!.contains('.pdf') ||
                                      widget.selectTask.files![index].linkUrl!.contains('.doc') ||
                                      widget.selectTask.files![index].linkUrl!.contains('.docx'))) {
                                file = true;
                              } else if (widget.selectTask.files![index].type == 'pdf' ||
                                  widget.selectTask.files![index].type == 'doc' ||
                                  widget.selectTask.files![index].type == 'docx') {
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
                                          if (widget.selectTask.files![index].file != null) {
                                            OpenFile.open(widget.selectTask.files![index].file!.path);
                                          } else {
                                            launch(widget.selectTask.files![index].linkUrl!.contains(server)
                                                ? widget.selectTask.files![index].linkUrl!
                                                : server + widget.selectTask.files![index].linkUrl!);
                                          }
                                        },
                                        child: Container(
                                          height: 50.h,
                                          width: 50.h,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: const [BoxShadow(color: Colors.black)],
                                              borderRadius: BorderRadius.circular(10.r)),
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
                                  if (widget.selectTask.files![index].file != null) {
                                    OpenFile.open(widget.selectTask.files![index].file!.path);
                                  } else {
                                    launch(widget.selectTask.files![index].linkUrl!.contains(server)
                                        ? widget.selectTask.files![index].linkUrl!
                                        : server + widget.selectTask.files![index].linkUrl!);
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
                                          borderRadius: BorderRadius.circular(10.r),
                                          child: widget.selectTask.files![index].byte != null
                                              ? Image.memory(
                                                  widget.selectTask.files![index].byte!,
                                                  fit: BoxFit.cover,
                                                )
                                              : CachedNetworkImage(
                                                  imageUrl: widget.selectTask.files![index].linkUrl!,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'term_of_execution'.tr(),
                                  style: CustomTextStyle.grey_14_w400,
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    Text(
                                      _textData(widget.selectTask.dateStart),
                                      style: CustomTextStyle.black_12_w400_292D32,
                                    ),
                                    SizedBox(width: 2.h),
                                    Text(
                                      '-',
                                      style: CustomTextStyle.black_12_w400_292D32,
                                    ),
                                    SizedBox(width: 2.h),
                                    Text(
                                      _textData(widget.selectTask.dateEnd),
                                      style: CustomTextStyle.black_12_w400_292D32,
                                    ),
                                  ],
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
                              color: ColorStyles.greyD9D9D9,
                              thickness: 1,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          SizedBox(
                            width: 100.w,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'region'.tr(),
                                  style: CustomTextStyle.grey_14_w400,
                                ),
                                SizedBox(height: 6.h),
                                Text(
                                  _textCountry(widget.selectTask),
                                  style: CustomTextStyle.black_12_w400_292D32,
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
              BlocBuilder<TasksBloc, TasksState>(buildWhen: (previous, current) {
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
                    log(widget.selectTask.owner.toString());
                    widget.openOwner(widget.selectTask.owner);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorStyles.whiteFFFFFF,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: ColorStyles.shadowFC6554,
                          offset: const Offset(0, 4),
                          blurRadius: 45.r,
                        )
                      ],
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                    child: Row(
                      children: [
                        if (widget.selectTask.owner?.photo != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(1000.r),
                            child: Image.network(
                              widget.selectTask.owner!.photo!,
                              height: 48.h,
                              width: 48.w,
                              fit: BoxFit.cover,
                            ),
                          ),
                        SizedBox(width: 15.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.selectTask.asCustomer ?? false ? 'customer'.tr() : 'executor'.tr(),
                                style: CustomTextStyle.grey_12_w400,
                              ),
                              SizedBox(
                                width: 260,
                                child: Text(
                                  '${widget.selectTask.owner?.firstname ?? '-'} ${widget.selectTask.owner?.lastname ?? '-'}',
                                  style: CustomTextStyle.black_17_w600_171716,
                                  softWrap: true,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              Row(
                                children: [
                                  Text(
                                    'rating'.tr(),
                                    style: CustomTextStyle.grey_14_w400,
                                  ),
                                  SizedBox(width: 8.w),
                                  SvgPicture.asset('assets/icons/star.svg'),
                                  SizedBox(width: 4.w),
                                  Text(
                                    widget.selectTask.owner?.ranking == null
                                        ? '0'
                                        : widget.selectTask.owner!.ranking.toString(),
                                    style: CustomTextStyle.black_13_w500_171716,
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
              if (user != null && widget.canSelect && user.id != widget.selectTask.owner?.id)
                CustomButton(
                  onTap: () async {
                    final chatBloc = BlocProvider.of<ChatBloc>(context);
                    chatBloc.editShowPersonChat(false);
                    chatBloc.editChatId(widget.selectTask.chatId);

                    chatBloc.messages = [];
                    final idChat = await Navigator.of(context).pushNamed(
                      AppRoute.personalChat,
                      arguments: [
                        '${widget.selectTask.chatId}',
                        '${widget.selectTask.owner?.firstname ?? ''} ${widget.selectTask.owner?.lastname ?? ''}',
                        '${widget.selectTask.owner?.id}',
                        '${widget.selectTask.owner?.photo}',
                      ],
                    );
                    chatBloc.editShowPersonChat(true);
                    chatBloc.editChatId(null);
                  },
                  btnColor: ColorStyles.yellowFFD70A,
                  textLabel: Text(
                    'write'.tr(),
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                ),
              SizedBox(height: 18.h),
              if (widget.canSelect &&
                  user?.id != widget.selectTask.owner?.id &&
                  widget.selectTask.isAnswered != null &&
                  widget.selectTask.isAnswered?.status == 'Progress')
                CustomButton(
                  onTap: () async {},
                  btnColor: ColorStyles.yellowFFD70A,
                  textLabel: Text(
                    widget.selectTask.asCustomer ?? false ? 'you_responded'.tr() : 'you_have_accepted_the_offer'.tr(),
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                ),
              if (widget.canSelect &&
                  user?.id != widget.selectTask.owner?.id &&
                  widget.selectTask.isAnswered != null &&
                  widget.selectTask.isAnswered?.status == 'Selected' &&
                  widget.selectTask.asCustomer! &&
                  widget.selectTask.status != 'Completed')
                CustomButton(
                  onTap: () async {},
                  btnColor: ColorStyles.yellowFFD70A,
                  textLabel: Text(
                    'you_have_been_chosen'.tr(),
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                ),

              if (widget.canSelect && user?.id != widget.selectTask.owner?.id && widget.selectTask.isAnswered == null)
                CustomButton(
                  onTap: () async {
                    if (user == null) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AuthPage(),
                          ));
                    } else {
                      if (user?.docInfo == '' || user?.docInfo == null) {
                        if (widget.fromFav) {
                          BlocProvider.of<repf.ReplyFromFavBloc>(context)
                              .add(repf.OpenSlidingPanelEvent(selectTask: selectTask));
                        } else {
                          BlocProvider.of<rep.ReplyBloc>(context)
                              .add(rep.OpenSlidingPanelEvent(selectTask: selectTask));
                        }
                      } else {
                        if (widget.fromFav) {
                          BlocProvider.of<resf.ResponseBlocFromFav>(context)
                              .add(resf.OpenSlidingPanelFromFavEvent(selectTask: selectTask));
                        } else {
                          log(widget.selectTask.toString());
                          BlocProvider.of<res.ResponseBloc>(context)
                              .add(res.OpenSlidingPanelEvent(selectTask: selectTask));
                        }
                      }
                    }
                  },
                  btnColor: ColorStyles.yellowFFD70A,
                  textLabel: Text(
                    widget.selectTask.asCustomer ?? false ? 'you_responded'.tr() : 'you_have_accepted_the_offer'.tr(),
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                ),
              //отзыв за исполнителя
              if (widget.canSelect &&
                  user?.id != widget.selectTask.owner?.id &&
                  widget.selectTask.isAnswered != null &&
                  widget.selectTask.status == 'Completed' &&
                  widget.selectTask.asCustomer!)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 90.h,
                      child: Padding(
                        padding: EdgeInsets.only(top: 15.h),
                        child: ScaleButton(
                          bound: 0.02,
                          onTap: () async {
                            final owner = await Repository()
                                .getRanking(widget.selectTask.owner?.id, BlocProvider.of<ProfileBloc>(context).access);
                            widget.openOwner(owner);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorStyles.whiteFFFFFF,
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: ColorStyles.shadowFC6554,
                                  offset: const Offset(0, 4),
                                  blurRadius: 45.r,
                                )
                              ],
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (widget.selectTask.isAnswered?.owner?.photo != null)
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(1000.r),
                                        child: Image.network(
                                          widget.selectTask.isAnswered!.owner!.photo!,
                                          height: 48.h,
                                          width: 48.w,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    SizedBox(width: 15.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 300.w,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 190.w,
                                                  child: Text(
                                                    '${widget.selectTask.isAnswered?.owner?.firstname ?? '-'} ${widget.selectTask.isAnswered?.owner?.lastname ?? '-'}',
                                                    style: CustomTextStyle.black_15_w600_171716,
                                                    softWrap: true,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Row(
                                            children: [
                                              SvgPicture.asset('assets/icons/star.svg'),
                                              SizedBox(width: 4.w),
                                              Text(
                                                widget.selectTask.isAnswered?.owner?.ranking == null
                                                    ? '0'
                                                    : widget.selectTask.isAnswered!.owner!.ranking.toString(),
                                                style: CustomTextStyle.black_13_w500_171716,
                                              ),
                                            ],
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
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      'leave_a_review'.tr(),
                      style: CustomTextStyle.black_17_w800,
                    ),
                    SizedBox(height: 15.h),
                    Text(
                      'points_are_credited_to_your_account_for_leaving_reviews_and_rating'.tr(),
                      style: CustomTextStyle.black_14_w500_171716,
                    ),
                    SizedBox(height: 30.h),
                    ScaleButton(
                      onTap: () {},
                      bound: 0.02,
                      child: Container(
                        height: 150.h,
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                        decoration: BoxDecoration(
                          color: ColorStyles.greyF9F9F9,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'custom_text'.tr(),
                              style: CustomTextStyle.grey_14_w400,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomTextField(
                                  height: 90.h,
                                  width: 285.w,
                                  autocorrect: true,
                                  maxLines: 8,
                                  onTap: () {
                                    setState(() {});
                                  },
                                  style: CustomTextStyle.black_14_w400_171716,
                                  textEditingController: descriptionTextController,
                                  fillColor: ColorStyles.greyF9F9F9,
                                  onChanged: (value) {},
                                  formatters: [
                                    UpperEveryTextInputFormatter(),
                                  ],
                                  hintText: '',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        Text(
                          'evaluate_the_customer'.tr(),
                          style: CustomTextStyle.black_17_w800,
                        ),
                        SizedBox(width: 15.h),
                        SvgPicture.asset(
                          SvgImg.help,
                          color: Colors.black,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                    SizedBox(height: 15.h),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 0,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: ColorStyles.yellowFFCA0D,
                      ),
                      onRatingUpdate: (rating) {
                        reviewRating = rating;
                      },
                    ),
                    SizedBox(height: 30.h),
                    CustomButton(
                      onTap: () {
                        if (widget.selectTask.owner!.hasReview!) {
                          CustomAlert().showMessage('have_you_already_left_a_review'.tr(), context);
                        } else {
                          int rating = 0;
                          if (reviewRating == 0.0) {
                            rating = 0;
                          }
                          if (reviewRating == 0.5) {
                            rating = 1;
                          }
                          if (reviewRating == 1.0) {
                            rating = 2;
                          }
                          if (reviewRating == 1.5) {
                            rating = 3;
                          }
                          if (reviewRating == 2.0) {
                            rating = 4;
                          }
                          if (reviewRating == 2.5) {
                            rating = 5;
                          }
                          if (reviewRating == 3.0) {
                            rating = 6;
                          }
                          if (reviewRating == 3.5) {
                            rating = 7;
                          }
                          if (reviewRating == 4.0) {
                            rating = 8;
                          }
                          if (reviewRating == 4.5) {
                            rating = 9;
                          }
                          if (reviewRating == 5.0) {
                            rating = 10;
                          }

                          Repository().addReviewsDetail(BlocProvider.of<ProfileBloc>(context).access,
                              widget.selectTask.owner?.id, descriptionTextController.text, rating);
                          context.read<TasksBloc>().add(UpdateTaskEvent());
                          BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                          Navigator.pop(context);
                        }
                      },
                      btnColor: ColorStyles.yellowFFD70A,
                      textLabel: Text(
                        'send_feedback'.tr(),
                        style: CustomTextStyle.black_16_w600_171716,
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    )
                  ],
                ),

              if (widget.selectTask.answers.isNotEmpty &&
                  (!widget.selectTask.asCustomer! || user?.id == widget.selectTask.owner?.id) &&
                  (widget.selectTask.answers.any((element) => element.status == 'Selected') ||
                      user?.id == widget.selectTask.owner?.id))
                Text(
                  'responses'.tr(),
                  style: CustomTextStyle.black_17_w800,
                ),
              if (widget.selectTask.answers.isNotEmpty &&
                  (!widget.selectTask.asCustomer! || user?.id == widget.selectTask.owner?.id) &&
                  (widget.selectTask.answers.any((element) => element.status == 'Selected') ||
                      user?.id == widget.selectTask.owner?.id))
                BlocBuilder<TasksBloc, TasksState>(buildWhen: (previous, current) {
                  if (current is UpdateTask) {
                    getTask();
                    return true;
                  }
                  if (previous != current) {
                    return true;
                  }
                  return false;
                }, builder: (context, state) {
                  return SizedBox(
                    height: widget.selectTask.status == 'Completed'
                        ? 600.h
                        : widget.selectTask.answers.every((element) => element.status != 'Selected')
                            ? 300.h * widget.selectTask.answers.length
                            : 300.h,
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.selectTask.answers.length,
                      itemBuilder: (context, index) {
                        log((widget.selectTask.answers.every((element) => element.status != 'Selected').toString()));
                        if (widget.selectTask.answers.every((element) => element.status != 'Selected') &&
                            user?.id == widget.selectTask.owner?.id) {
                          if (widget.selectTask.asCustomer!) {
                            return SizedBox(
                              height: widget.selectTask.answers[index].owner!.firstname!.length +
                                              widget.selectTask.answers[index].owner!.lastname!.length >
                                          16 ||
                                      widget.selectTask.answers[index].description!.length > 40
                                  ? 240.h
                                  : 220.h,
                              child: Padding(
                                padding: EdgeInsets.only(top: 15.h),
                                child: ScaleButton(
                                  bound: 0.02,
                                  onTap: () async {
                                    final owner = await Repository().getRanking(
                                        widget.selectTask.answers[index].owner?.id,
                                        BlocProvider.of<ProfileBloc>(context).access);
                                    widget.openOwner(owner);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorStyles.whiteFFFFFF,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorStyles.shadowFC6554,
                                          offset: const Offset(0, 4),
                                          blurRadius: 45.r,
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            if (widget.selectTask.answers[index].owner?.photo != null)
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(1000.r),
                                                child: Image.network(
                                                  widget.selectTask.answers[index].owner!.photo!,
                                                  height: 48.h,
                                                  width: 48.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 300.w,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 180.w,
                                                          child: RichText(
                                                            text: TextSpan(
                                                                style: CustomTextStyle.black_15_w600_171716,
                                                                text:
                                                                    '${widget.selectTask.answers[index].owner?.firstname ?? '-'} ${widget.selectTask.answers[index].owner?.lastname ?? '-'}',
                                                                children: [
                                                                  WidgetSpan(
                                                                    child: SizedBox(
                                                                      width: 10.w,
                                                                    ),
                                                                  ),
                                                                  WidgetSpan(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(bottom: 3.h),
                                                                      child: SvgPicture.asset('assets/icons/star.svg'),
                                                                    ),
                                                                  ),
                                                                  WidgetSpan(
                                                                    child: SizedBox(width: 4.w),
                                                                  ),
                                                                  WidgetSpan(
                                                                    child: Padding(
                                                                      padding: EdgeInsets.only(bottom: 1.h),
                                                                      child: Text(
                                                                        widget.selectTask.answers[index].owner
                                                                                    ?.ranking ==
                                                                                null
                                                                            ? '0'
                                                                            : widget.selectTask.answers[index].owner!
                                                                                .ranking
                                                                                .toString(),
                                                                        style: CustomTextStyle.black_13_w500_171716,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ]),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Text(
                                                          'before'.tr(),
                                                          style: CustomTextStyle.black_15_w600_171716,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  Row(
                                                    children: [
                                                      const Spacer(),
                                                      if (widget.selectTask.currency?.name == null &&
                                                          widget.selectTask.answers[index].price != null)
                                                        Text(
                                                          '${_textCurrency(widget.selectTask.answers[index].price!)} ',
                                                          style: CustomTextStyle.black_15_w600_171716,
                                                        ),
                                                      if (widget.selectTask.currency?.name == 'Дирхам' &&
                                                          widget.selectTask.answers[index].price != null)
                                                        Text(
                                                          '${_textCurrency(widget.selectTask.answers[index].price!)} AED',
                                                          style: CustomTextStyle.black_15_w600_171716,
                                                        ),
                                                      if (widget.selectTask.currency?.name == 'Российский рубль' &&
                                                          widget.selectTask.answers[index].price != null)
                                                        Text(
                                                          '${_textCurrency(widget.selectTask.answers[index].price!)}  ₽',
                                                          style: CustomTextStyle.black_15_w600_171716,
                                                        ),
                                                      if (widget.selectTask.currency?.name == 'Доллар США' &&
                                                          widget.selectTask.answers[index].price != null)
                                                        Text(
                                                          '${_textCurrency(widget.selectTask.answers[index].price!)} \$',
                                                          style: CustomTextStyle.black_15_w600_171716,
                                                        ),
                                                      if (widget.selectTask.currency?.name == 'Евро' &&
                                                          widget.selectTask.answers[index].price != null)
                                                        Text(
                                                          '${_textCurrency(widget.selectTask.answers[index].price!)} €',
                                                          style: CustomTextStyle.black_15_w600_171716,
                                                        ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        'completed_tasks'.tr(),
                                                        style: CustomTextStyle.grey_12_w400,
                                                      ),
                                                      SizedBox(width: 4.w),
                                                      if (widget.selectTask.answers[index].owner != null)
                                                        Text(
                                                          widget.selectTask.answers[index].owner!.countOrdersComplete
                                                              .toString(),
                                                          style: CustomTextStyle.black_12_w400,
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (widget.selectTask.answers[index].description != null)
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                        if (widget.selectTask.answers[index].description != null)
                                          Padding(
                                            padding: EdgeInsets.only(left: 10.w),
                                            child: Text(
                                              widget.selectTask.answers[index].description!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: CustomTextStyle.black_12_w400_292D32,
                                            ),
                                          ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 50.h,
                                              width: 140.w,
                                              child: CustomButton(
                                                onTap: () async {
                                                  final chatBloc = BlocProvider.of<ChatBloc>(context);
                                                  chatBloc.editShowPersonChat(false);
                                                  chatBloc.editChatId(widget.selectTask.chatId);
                                                  chatBloc.messages = [];
                                                  final idChat = await Navigator.of(context).pushNamed(
                                                    AppRoute.personalChat,
                                                    arguments: [
                                                      '${widget.selectTask.answers[index].chatId}',
                                                      '${widget.selectTask.answers[index].owner?.firstname ?? ''} ${widget.selectTask.answers[index].owner?.lastname ?? ''}',
                                                      '${widget.selectTask.answers[index].owner?.id}',
                                                      '${widget.selectTask.answers[index].owner?.photo}',
                                                    ],
                                                  );
                                                  chatBloc.editShowPersonChat(true);
                                                  chatBloc.editChatId(null);
                                                },
                                                btnColor: ColorStyles.greyDADADA,
                                                textLabel: Text(
                                                  'write_to_the_chat'.tr(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            SizedBox(
                                              height: 50.h,
                                              width: 140.w,
                                              child: CustomButton(
                                                onTap: () async {
                                                  log(widget.selectTask.answers[index].id!.toString());
                                                  Repository().updateStatusResponse(
                                                      BlocProvider.of<ProfileBloc>(context).access,
                                                      widget.selectTask.answers[index].id!,
                                                      'Selected');
                                                  context.read<TasksBloc>().add(UpdateTaskEvent());
                                                  user = BlocProvider.of<ProfileBloc>(context).user;
                                                  BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                                  if (widget.canEdit) {
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                btnColor: ColorStyles.yellowFFD70A,
                                                textLabel: Text(
                                                  'choose_a_executor'.tr(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500),
                                                ),
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
                          } else {
                            return SizedBox(
                              height: 205.h,
                              child: Padding(
                                padding: EdgeInsets.only(top: 15.h),
                                child: ScaleButton(
                                  bound: 0.02,
                                  onTap: () async {
                                    final owner = await Repository().getRanking(
                                        widget.selectTask.answers[index].owner?.id,
                                        BlocProvider.of<ProfileBloc>(context).access);
                                    widget.openOwner(owner);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorStyles.whiteFFFFFF,
                                      borderRadius: BorderRadius.circular(20.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ColorStyles.shadowFC6554,
                                          offset: const Offset(0, 4),
                                          blurRadius: 45.r,
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            if (widget.selectTask.answers[index].owner?.photo != null)
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(1000.r),
                                                child: Image.network(
                                                  widget.selectTask.answers[index].owner!.photo!,
                                                  height: 48.h,
                                                  width: 48.w,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            SizedBox(width: 15.w),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: 300.w,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          width: 110.w,
                                                          child: Text(
                                                            '${widget.selectTask.answers[index].owner?.firstname ?? '-'} ${widget.selectTask.answers[index].owner?.lastname ?? '-'}',
                                                            style: CustomTextStyle.black_15_w600_171716,
                                                            softWrap: true,
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        if (widget.selectTask.currency?.name == null &&
                                                            widget.selectTask.answers[index].price != null)
                                                          Text(
                                                            '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} ',
                                                            style: CustomTextStyle.black_15_w600_171716,
                                                          ),
                                                        if (widget.selectTask.currency?.name == 'Дирхам' &&
                                                            widget.selectTask.answers[index].price != null)
                                                          Text(
                                                            '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} AED',
                                                            style: CustomTextStyle.black_15_w600_171716,
                                                          ),
                                                        if (widget.selectTask.currency?.name == 'Российский рубль' &&
                                                            widget.selectTask.answers[index].price != null)
                                                          Text(
                                                            '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)}  ₽',
                                                            style: CustomTextStyle.black_15_w600_171716,
                                                          ),
                                                        if (widget.selectTask.currency?.name == 'Доллар США' &&
                                                            widget.selectTask.answers[index].price != null)
                                                          Text(
                                                            '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} \$',
                                                            style: CustomTextStyle.black_15_w600_171716,
                                                          ),
                                                        if (widget.selectTask.currency?.name == 'Евро' &&
                                                            widget.selectTask.answers[index].price != null)
                                                          Text(
                                                            '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} €',
                                                            style: CustomTextStyle.black_15_w600_171716,
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 6.h),
                                                  Row(
                                                    children: [
                                                      SvgPicture.asset('assets/icons/star.svg'),
                                                      SizedBox(width: 4.w),
                                                      Text(
                                                        widget.selectTask.answers[index].owner?.ranking == null
                                                            ? '0'
                                                            : widget.selectTask.answers[index].owner!.ranking
                                                                .toString(),
                                                        style: CustomTextStyle.black_13_w500_171716,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        if (widget.selectTask.answers[index].description != null)
                                          SizedBox(
                                            height: 15.h,
                                          ),
                                        if (widget.selectTask.answers[index].description != null)
                                          Padding(
                                            padding: EdgeInsets.only(left: 10.w),
                                            child: Text(
                                              widget.selectTask.answers[index].description!,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 3,
                                              style: CustomTextStyle.black_12_w400_292D32,
                                            ),
                                          ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(
                                              height: 50.h,
                                              width: 140.w,
                                              child: CustomButton(
                                                onTap: () async {
                                                  final chatBloc = BlocProvider.of<ChatBloc>(context);
                                                  chatBloc.editShowPersonChat(false);
                                                  chatBloc.editChatId(widget.selectTask.chatId);
                                                  chatBloc.messages = [];
                                                  final idChat = await Navigator.of(context).pushNamed(
                                                    AppRoute.personalChat,
                                                    arguments: [
                                                      '${widget.selectTask.answers[index].chatId}',
                                                      '${widget.selectTask.answers[index].owner?.firstname ?? ''} ${widget.selectTask.answers[index].owner?.lastname ?? ''}',
                                                      '${widget.selectTask.answers[index].owner?.id}',
                                                      '${widget.selectTask.answers[index].owner?.photo}',
                                                    ],
                                                  );
                                                  chatBloc.editShowPersonChat(true);
                                                  chatBloc.editChatId(null);
                                                },
                                                btnColor: ColorStyles.greyDADADA,
                                                textLabel: Text(
                                                  'write_to_the_chat'.tr(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w500),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            SizedBox(
                                              height: 50.h,
                                              width: 140.w,
                                              child: CustomButton(
                                                onTap: () async {},
                                                btnColor: ColorStyles.yellowFFD70A,
                                                textLabel: Text(
                                                  'you_have_been_chosen'.tr(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12.sp,
                                                      fontWeight: FontWeight.w700),
                                                ),
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
                        } else {
                          if (widget.selectTask.answers[index].status == 'Selected') {
                            if (widget.selectTask.status == 'Completed') {
                              if (user?.id == widget.selectTask.owner?.id) {
                                if (widget.selectTask.asCustomer!)
                                //отзыв за заказчика
                                {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 90.h,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 15.h),
                                          child: ScaleButton(
                                            bound: 0.02,
                                            onTap: () async {
                                              final owner = await Repository().getRanking(
                                                  widget.selectTask.answers[index].owner?.id,
                                                  BlocProvider.of<ProfileBloc>(context).access);
                                              widget.openOwner(owner);
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: ColorStyles.whiteFFFFFF,
                                                borderRadius: BorderRadius.circular(20.r),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: ColorStyles.shadowFC6554,
                                                    offset: const Offset(0, 4),
                                                    blurRadius: 45.r,
                                                  )
                                                ],
                                              ),
                                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      if (widget.selectTask.answers[index].owner?.photo != null)
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(1000.r),
                                                          child: Image.network(
                                                            widget.selectTask.answers[index].owner!.photo!,
                                                            height: 48.h,
                                                            width: 48.w,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      SizedBox(width: 15.w),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width: 300.w,
                                                              child: Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 190.w,
                                                                    child: Text(
                                                                      '${widget.selectTask.answers[index].owner?.firstname ?? '-'} ${widget.selectTask.answers[index].owner?.lastname ?? '-'}',
                                                                      style: CustomTextStyle.black_15_w600_171716,
                                                                      softWrap: true,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            SizedBox(height: 6.h),
                                                            Row(
                                                              children: [
                                                                SvgPicture.asset('assets/icons/star.svg'),
                                                                SizedBox(width: 4.w),
                                                                Text(
                                                                  widget.selectTask.answers[index].owner?.ranking ==
                                                                          null
                                                                      ? '0'
                                                                      : widget.selectTask.answers[index].owner!.ranking
                                                                          .toString(),
                                                                  style: CustomTextStyle.black_13_w500_171716,
                                                                ),
                                                              ],
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
                                      ),
                                      SizedBox(height: 30.h),
                                      Text(
                                        'leave_a_review'.tr(),
                                        style: CustomTextStyle.black_17_w800,
                                      ),
                                      SizedBox(height: 15.h),
                                      Text(
                                        'points_are_credited_to_your_account_for_leaving_reviews_and_rating'.tr(),
                                        style: CustomTextStyle.black_14_w500_171716,
                                      ),
                                      SizedBox(height: 30.h),
                                      ScaleButton(
                                        onTap: () {},
                                        bound: 0.02,
                                        child: Container(
                                          height: 150.h,
                                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                                          decoration: BoxDecoration(
                                            color: ColorStyles.greyF9F9F9,
                                            borderRadius: BorderRadius.circular(10.r),
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'custom_text'.tr(),
                                                style: CustomTextStyle.grey_14_w400,
                                              ),
                                              SizedBox(height: 3.h),
                                              Row(
                                                children: [
                                                  CustomTextField(
                                                    height: 90.h,
                                                    width: 285.w,
                                                    autocorrect: true,
                                                    maxLines: 8,
                                                    onTap: () {
                                                      setState(() {});
                                                    },
                                                    style: CustomTextStyle.black_14_w400_171716,
                                                    textEditingController: descriptionTextController1,
                                                    fillColor: ColorStyles.greyF9F9F9,
                                                    onChanged: (value) {},
                                                    formatters: [
                                                      UpperEveryTextInputFormatter(),
                                                    ],
                                                    hintText: '',
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 30.h),
                                      Row(
                                        children: [
                                          Text(
                                            'rate_the_executor'.tr(),
                                            style: CustomTextStyle.black_17_w800,
                                          ),
                                          SizedBox(width: 15.h),
                                          SvgPicture.asset(
                                            SvgImg.help,
                                            color: Colors.black,
                                            width: 20,
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 15.h),
                                      RatingBar.builder(
                                        initialRating: 0,
                                        minRating: 0,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        itemCount: 5,
                                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => const Icon(
                                          Icons.star,
                                          color: ColorStyles.yellowFFCA0D,
                                        ),
                                        onRatingUpdate: (rating) {
                                          reviewRating = rating;
                                        },
                                      ),
                                      SizedBox(height: 30.h),
                                      CustomButton(
                                        onTap: () {
                                          if (widget.selectTask.answers[index].owner!.hasReview!) {
                                            CustomAlert().showMessage('have_you_already_left_a_review'.tr(), context);
                                          } else {
                                            int rating = 0;
                                            if (reviewRating == 0.0) {
                                              rating = 0;
                                            }
                                            if (reviewRating == 0.5) {
                                              rating = 1;
                                            }
                                            if (reviewRating == 1.0) {
                                              rating = 2;
                                            }
                                            if (reviewRating == 1.5) {
                                              rating = 3;
                                            }
                                            if (reviewRating == 2.0) {
                                              rating = 4;
                                            }
                                            if (reviewRating == 2.5) {
                                              rating = 5;
                                            }
                                            if (reviewRating == 3.0) {
                                              rating = 6;
                                            }
                                            if (reviewRating == 3.5) {
                                              rating = 7;
                                            }
                                            if (reviewRating == 4.0) {
                                              rating = 8;
                                            }
                                            if (reviewRating == 4.5) {
                                              rating = 9;
                                            }
                                            if (reviewRating == 5.0) {
                                              rating = 10;
                                            }
                                            print(descriptionTextController1.text);

                                            Repository().addReviewsDetail(
                                                BlocProvider.of<ProfileBloc>(context).access,
                                                widget.selectTask.answers[index].owner?.id,
                                                descriptionTextController1.text,
                                                rating);
                                            context.read<TasksBloc>().add(UpdateTaskEvent());
                                            BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                            Navigator.pop(context);
                                          }
                                        },
                                        btnColor: ColorStyles.yellowFFD70A,
                                        textLabel: Text(
                                          'send_feedback'.tr(),
                                          style: CustomTextStyle.black_16_w600_171716,
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  if (widget.selectTask.isAnswered?.owner?.firstname != null) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 90.h,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 15.h),
                                            child: ScaleButton(
                                              bound: 0.02,
                                              onTap: () async {
                                                final owner = await Repository().getRanking(widget.selectTask.owner?.id,
                                                    BlocProvider.of<ProfileBloc>(context).access);
                                                widget.openOwner(owner);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ColorStyles.whiteFFFFFF,
                                                  borderRadius: BorderRadius.circular(20.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ColorStyles.shadowFC6554,
                                                      offset: const Offset(0, 4),
                                                      blurRadius: 45.r,
                                                    )
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        if (widget.selectTask.isAnswered?.owner?.photo != null)
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(1000.r),
                                                            child: Image.network(
                                                              widget.selectTask.isAnswered!.owner!.photo!,
                                                              height: 48.h,
                                                              width: 48.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        SizedBox(width: 15.w),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: 300.w,
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 190.w,
                                                                      child: Text(
                                                                        '${widget.selectTask.isAnswered?.owner?.firstname ?? '-'} ${widget.selectTask.isAnswered?.owner?.lastname ?? '-'}',
                                                                        style: CustomTextStyle.black_15_w600_171716,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 6.h),
                                                              Row(
                                                                children: [
                                                                  SvgPicture.asset('assets/icons/star.svg'),
                                                                  SizedBox(width: 4.w),
                                                                  Text(
                                                                    widget.selectTask.isAnswered?.owner?.ranking == null
                                                                        ? '0'
                                                                        : widget.selectTask.isAnswered!.owner!.ranking
                                                                            .toString(),
                                                                    style: CustomTextStyle.black_13_w500_171716,
                                                                  ),
                                                                ],
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
                                        ),
                                        SizedBox(height: 30.h),
                                        Text(
                                          'leave_a_review'.tr(),
                                          style: CustomTextStyle.black_17_w800,
                                        ),
                                        SizedBox(height: 15.h),
                                        Text(
                                          'points_are_credited_to_your_account_for_leaving_reviews_and_rating'.tr(),
                                          style: CustomTextStyle.black_14_w500_171716,
                                        ),
                                        SizedBox(height: 30.h),
                                        ScaleButton(
                                          onTap: () {},
                                          bound: 0.02,
                                          child: Container(
                                            height: 150.h,
                                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                                            decoration: BoxDecoration(
                                              color: ColorStyles.greyF9F9F9,
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'custom_text'.tr(),
                                                  style: CustomTextStyle.grey_14_w400,
                                                ),
                                                SizedBox(height: 3.h),
                                                Row(
                                                  children: [
                                                    CustomTextField(
                                                      height: 90.h,
                                                      width: 285.w,
                                                      autocorrect: true,
                                                      maxLines: 8,
                                                      onTap: () {
                                                        setState(() {});
                                                      },
                                                      style: CustomTextStyle.black_14_w400_171716,
                                                      textEditingController: descriptionTextController2,
                                                      fillColor: ColorStyles.greyF9F9F9,
                                                      onChanged: (value) {},
                                                      formatters: [
                                                        UpperEveryTextInputFormatter(),
                                                      ],
                                                      hintText: '',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30.h),
                                        Row(
                                          children: [
                                            Text(
                                              'evaluate_the_customer'.tr(),
                                              style: CustomTextStyle.black_17_w800,
                                            ),
                                            SizedBox(width: 15.h),
                                            SvgPicture.asset(
                                              SvgImg.help,
                                              color: Colors.black,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        RatingBar.builder(
                                          initialRating: 0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: ColorStyles.yellowFFCA0D,
                                          ),
                                          onRatingUpdate: (rating) {
                                            reviewRating = rating;
                                          },
                                        ),
                                        SizedBox(height: 30.h),
                                        CustomButton(
                                          onTap: () {
                                            if (widget.selectTask.owner!.hasReview!) {
                                              CustomAlert().showMessage('have_you_already_left_a_review'.tr(), context);
                                            } else {
                                              int rating = 0;
                                              if (reviewRating == 0.0) {
                                                rating = 0;
                                              }
                                              if (reviewRating == 0.5) {
                                                rating = 1;
                                              }
                                              if (reviewRating == 1.0) {
                                                rating = 2;
                                              }
                                              if (reviewRating == 1.5) {
                                                rating = 3;
                                              }
                                              if (reviewRating == 2.0) {
                                                rating = 4;
                                              }
                                              if (reviewRating == 2.5) {
                                                rating = 5;
                                              }
                                              if (reviewRating == 3.0) {
                                                rating = 6;
                                              }
                                              if (reviewRating == 3.5) {
                                                rating = 7;
                                              }
                                              if (reviewRating == 4.0) {
                                                rating = 8;
                                              }
                                              if (reviewRating == 4.5) {
                                                rating = 9;
                                              }
                                              if (reviewRating == 5.0) {
                                                rating = 10;
                                              }
                                              Repository().addReviewsDetail(
                                                  BlocProvider.of<ProfileBloc>(context).access,
                                                  widget.selectTask.owner?.id,
                                                  descriptionTextController2.text,
                                                  rating);
                                              context.read<TasksBloc>().add(UpdateTaskEvent());
                                              BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                              Navigator.pop(context);
                                            }
                                          },
                                          btnColor: ColorStyles.yellowFFD70A,
                                          textLabel: Text(
                                            'send_feedback'.tr(),
                                            style: CustomTextStyle.black_16_w600_171716,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        )
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 90.h,
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 15.h),
                                            child: ScaleButton(
                                              bound: 0.02,
                                              onTap: () async {
                                                final owner = await Repository().getRanking(
                                                    widget.selectTask.answers[index].owner?.id,
                                                    BlocProvider.of<ProfileBloc>(context).access);
                                                widget.openOwner(owner);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ColorStyles.whiteFFFFFF,
                                                  borderRadius: BorderRadius.circular(20.r),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: ColorStyles.shadowFC6554,
                                                      offset: const Offset(0, 4),
                                                      blurRadius: 45.r,
                                                    )
                                                  ],
                                                ),
                                                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        if (widget.selectTask.answers[index].owner?.photo != null)
                                                          ClipRRect(
                                                            borderRadius: BorderRadius.circular(1000.r),
                                                            child: Image.network(
                                                              widget.selectTask.answers[index].owner!.photo!,
                                                              height: 48.h,
                                                              width: 48.w,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        SizedBox(width: 15.w),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              SizedBox(
                                                                width: 300.w,
                                                                child: Row(
                                                                  children: [
                                                                    SizedBox(
                                                                      width: 190.w,
                                                                      child: Text(
                                                                        '${widget.selectTask.answers[index].owner?.firstname ?? '-'} ${widget.selectTask.answers[index].owner?.lastname ?? '-'}',
                                                                        style: CustomTextStyle.black_15_w600_171716,
                                                                        softWrap: true,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(height: 6.h),
                                                              Row(
                                                                children: [
                                                                  SvgPicture.asset('assets/icons/star.svg'),
                                                                  SizedBox(width: 4.w),
                                                                  Text(
                                                                    widget.selectTask.answers[index].owner?.ranking ==
                                                                            null
                                                                        ? '0'
                                                                        : widget
                                                                            .selectTask.answers[index].owner!.ranking
                                                                            .toString(),
                                                                    style: CustomTextStyle.black_13_w500_171716,
                                                                  ),
                                                                ],
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
                                        ),
                                        SizedBox(height: 30.h),
                                        Text(
                                          'leave_a_review'.tr(),
                                          style: CustomTextStyle.black_17_w800,
                                        ),
                                        SizedBox(height: 15.h),
                                        Text(
                                          'points_are_credited_to_your_account_for_leaving_reviews_and_rating'.tr(),
                                          style: CustomTextStyle.black_14_w500_171716,
                                        ),
                                        SizedBox(height: 30.h),
                                        ScaleButton(
                                          onTap: () {},
                                          bound: 0.02,
                                          child: Container(
                                            height: 150.h,
                                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                                            decoration: BoxDecoration(
                                              color: ColorStyles.greyF9F9F9,
                                              borderRadius: BorderRadius.circular(10.r),
                                            ),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'custom_text'.tr(),
                                                  style: CustomTextStyle.grey_14_w400,
                                                ),
                                                SizedBox(height: 3.h),
                                                Row(
                                                  children: [
                                                    CustomTextField(
                                                      height: 90.h,
                                                      width: 285.w,
                                                      autocorrect: true,
                                                      maxLines: 8,
                                                      onTap: () {
                                                        setState(() {});
                                                      },
                                                      style: CustomTextStyle.black_14_w400_171716,
                                                      textEditingController: descriptionTextController3,
                                                      fillColor: ColorStyles.greyF9F9F9,
                                                      onChanged: (value) {},
                                                      formatters: [
                                                        UpperEveryTextInputFormatter(),
                                                      ],
                                                      hintText: '',
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 30.h),
                                        Row(
                                          children: [
                                            Text(
                                              'evaluate_the_customer'.tr(),
                                              style: CustomTextStyle.black_17_w800,
                                            ),
                                            SizedBox(width: 15.h),
                                            SvgPicture.asset(
                                              SvgImg.help,
                                              color: Colors.black,
                                              width: 20,
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 15.h),
                                        RatingBar.builder(
                                          initialRating: 0,
                                          minRating: 0,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                          itemBuilder: (context, _) => const Icon(
                                            Icons.star,
                                            color: ColorStyles.yellowFFCA0D,
                                          ),
                                          onRatingUpdate: (rating) {
                                            reviewRating = rating;
                                          },
                                        ),
                                        SizedBox(height: 30.h),
                                        CustomButton(
                                          onTap: () {
                                            if (widget.selectTask.answers[index].owner!.hasReview!) {
                                              CustomAlert().showMessage('have_you_already_left_a_review'.tr(), context);
                                            } else {
                                              int rating = 0;
                                              if (reviewRating == 0.0) {
                                                rating = 0;
                                              }
                                              if (reviewRating == 0.5) {
                                                rating = 1;
                                              }
                                              if (reviewRating == 1.0) {
                                                rating = 2;
                                              }
                                              if (reviewRating == 1.5) {
                                                rating = 3;
                                              }
                                              if (reviewRating == 2.0) {
                                                rating = 4;
                                              }
                                              if (reviewRating == 2.5) {
                                                rating = 5;
                                              }
                                              if (reviewRating == 3.0) {
                                                rating = 6;
                                              }
                                              if (reviewRating == 3.5) {
                                                rating = 7;
                                              }
                                              if (reviewRating == 4.0) {
                                                rating = 8;
                                              }
                                              if (reviewRating == 4.5) {
                                                rating = 9;
                                              }
                                              if (reviewRating == 5.0) {
                                                rating = 10;
                                              }
                                              Repository().addReviewsDetail(
                                                  BlocProvider.of<ProfileBloc>(context).access,
                                                  widget.selectTask.owner?.id,
                                                  descriptionTextController3.text,
                                                  rating);
                                              context.read<TasksBloc>().add(UpdateTaskEvent());
                                              BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                              Navigator.pop(context);
                                            }
                                          },
                                          btnColor: ColorStyles.yellowFFD70A,
                                          textLabel: Text(
                                            'send_feedback'.tr(),
                                            style: CustomTextStyle.black_16_w600_171716,
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                }
                              } else {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 90.h,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: 15.h),
                                        child: ScaleButton(
                                          bound: 0.02,
                                          onTap: () async {
                                            final owner = await Repository().getRanking(
                                                widget.selectTask.answers[index].owner?.id,
                                                BlocProvider.of<ProfileBloc>(context).access);
                                            widget.openOwner(owner);
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: ColorStyles.whiteFFFFFF,
                                              borderRadius: BorderRadius.circular(20.r),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: ColorStyles.shadowFC6554,
                                                  offset: const Offset(0, 4),
                                                  blurRadius: 45.r,
                                                )
                                              ],
                                            ),
                                            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    if (widget.selectTask.answers[index].owner?.photo != null)
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(1000.r),
                                                        child: Image.network(
                                                          widget.selectTask.answers[index].owner!.photo!,
                                                          height: 48.h,
                                                          width: 48.w,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    SizedBox(width: 15.w),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(
                                                            width: 300.w,
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width: 190.w,
                                                                  child: Text(
                                                                    '${widget.selectTask.answers[index].owner?.firstname ?? '-'} ${widget.selectTask.answers[index].owner?.lastname ?? '-'}',
                                                                    style: CustomTextStyle.black_15_w600_171716,
                                                                    softWrap: true,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(height: 6.h),
                                                          Row(
                                                            children: [
                                                              SvgPicture.asset('assets/icons/star.svg'),
                                                              SizedBox(width: 4.w),
                                                              Text(
                                                                widget.selectTask.answers[index].owner?.ranking == null
                                                                    ? '0'
                                                                    : widget.selectTask.answers[index].owner!.ranking
                                                                        .toString(),
                                                                style: CustomTextStyle.black_13_w500_171716,
                                                              ),
                                                            ],
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
                                    ),
                                    SizedBox(height: 30.h),
                                    Text(
                                      'leave_a_review'.tr(),
                                      style: CustomTextStyle.black_17_w800,
                                    ),
                                    SizedBox(height: 15.h),
                                    Text(
                                      'points_are_credited_to_your_account_for_leaving_reviews_and_rating'.tr(),
                                      style: CustomTextStyle.black_14_w500_171716,
                                    ),
                                    SizedBox(height: 30.h),
                                    ScaleButton(
                                      onTap: () {},
                                      bound: 0.02,
                                      child: Container(
                                        height: 150.h,
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                                        decoration: BoxDecoration(
                                          color: ColorStyles.greyF9F9F9,
                                          borderRadius: BorderRadius.circular(10.r),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'custom_text'.tr(),
                                              style: CustomTextStyle.grey_14_w400,
                                            ),
                                            SizedBox(height: 3.h),
                                            Row(
                                              children: [
                                                CustomTextField(
                                                  height: 90.h,
                                                  width: 285.w,
                                                  autocorrect: true,
                                                  maxLines: 8,
                                                  onTap: () {
                                                    setState(() {});
                                                  },
                                                  style: CustomTextStyle.black_14_w400_171716,
                                                  textEditingController: descriptionTextController3,
                                                  fillColor: ColorStyles.greyF9F9F9,
                                                  onChanged: (value) {},
                                                  formatters: [
                                                    UpperEveryTextInputFormatter(),
                                                  ],
                                                  hintText: '',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                    Row(
                                      children: [
                                        Text(
                                          'rate_the_executor'.tr(),
                                          style: CustomTextStyle.black_17_w800,
                                        ),
                                        SizedBox(width: 15.h),
                                        SvgPicture.asset(
                                          SvgImg.help,
                                          color: Colors.black,
                                          width: 20,
                                          height: 20,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.h),
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 0,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: ColorStyles.yellowFFCA0D,
                                      ),
                                      onRatingUpdate: (rating) {
                                        reviewRating = rating;
                                      },
                                    ),
                                    SizedBox(height: 30.h),
                                    CustomButton(
                                      onTap: () {
                                        if (widget.selectTask.owner!.hasReview!) {
                                          CustomAlert().showMessage('have_you_already_left_a_review'.tr(), context);
                                        } else {
                                          int rating = 0;
                                          if (reviewRating == 0.0) {
                                            rating = 0;
                                          }
                                          if (reviewRating == 0.5) {
                                            rating = 1;
                                          }
                                          if (reviewRating == 1.0) {
                                            rating = 2;
                                          }
                                          if (reviewRating == 1.5) {
                                            rating = 3;
                                          }
                                          if (reviewRating == 2.0) {
                                            rating = 4;
                                          }
                                          if (reviewRating == 2.5) {
                                            rating = 5;
                                          }
                                          if (reviewRating == 3.0) {
                                            rating = 6;
                                          }
                                          if (reviewRating == 3.5) {
                                            rating = 7;
                                          }
                                          if (reviewRating == 4.0) {
                                            rating = 8;
                                          }
                                          if (reviewRating == 4.5) {
                                            rating = 9;
                                          }
                                          if (reviewRating == 5.0) {
                                            rating = 10;
                                          }
                                          Repository().addReviewsDetail(BlocProvider.of<ProfileBloc>(context).access,
                                              widget.selectTask.owner?.id, descriptionTextController3.text, rating);
                                          context.read<TasksBloc>().add(UpdateTaskEvent());
                                          BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                          Navigator.pop(context);
                                        }
                                      },
                                      btnColor: ColorStyles.yellowFFD70A,
                                      textLabel: Text(
                                        'send_feedback'.tr(),
                                        style: CustomTextStyle.black_16_w600_171716,
                                      ),
                                    ),
                                  ],
                                );
                              }
                            } else {
                              if (widget.selectTask.asCustomer == true ||
                                  widget.selectTask.answers[index].owner?.id == user?.id) {
                                return SizedBox(
                                  height: widget.selectTask.answers[index].owner!.firstname!.length +
                                                  widget.selectTask.answers[index].owner!.lastname!.length >
                                              16 ||
                                          widget.selectTask.answers[index].description!.length > 40
                                      ? 240.h
                                      : 220.h,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: ScaleButton(
                                      bound: 0.02,
                                      onTap: () async {
                                        final owner = await Repository().getRanking(
                                            widget.selectTask.answers[index].owner?.id,
                                            BlocProvider.of<ProfileBloc>(context).access);
                                        widget.openOwner(owner);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorStyles.whiteFFFFFF,
                                          borderRadius: BorderRadius.circular(20.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorStyles.shadowFC6554,
                                              offset: const Offset(0, 4),
                                              blurRadius: 45.r,
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                if (widget.selectTask.answers[index].owner?.photo != null)
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(1000.r),
                                                    child: Image.network(
                                                      widget.selectTask.answers[index].owner!.photo!,
                                                      height: 48.h,
                                                      width: 48.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                SizedBox(width: 15.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 300.w,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 180.w,
                                                              child: RichText(
                                                                text: TextSpan(
                                                                    style: CustomTextStyle.black_15_w600_171716,
                                                                    text:
                                                                        '${widget.selectTask.answers[index].owner?.firstname ?? '-'} ${widget.selectTask.answers[index].owner?.lastname ?? '-'}',
                                                                    children: [
                                                                      WidgetSpan(
                                                                        child: SizedBox(
                                                                          width: 10.w,
                                                                        ),
                                                                      ),
                                                                      WidgetSpan(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(bottom: 3.h),
                                                                          child:
                                                                              SvgPicture.asset('assets/icons/star.svg'),
                                                                        ),
                                                                      ),
                                                                      WidgetSpan(
                                                                        child: SizedBox(width: 4.w),
                                                                      ),
                                                                      WidgetSpan(
                                                                        child: Padding(
                                                                          padding: EdgeInsets.only(bottom: 1.h),
                                                                          child: Text(
                                                                            widget.selectTask.answers[index].owner
                                                                                        ?.ranking ==
                                                                                    null
                                                                                ? '0'
                                                                                : widget.selectTask.answers[index]
                                                                                    .owner!.ranking
                                                                                    .toString(),
                                                                            style: CustomTextStyle.black_13_w500_171716,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ]),
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            Text(
                                                              'before'.tr(),
                                                              style: CustomTextStyle.black_15_w600_171716,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      Row(
                                                        children: [
                                                          const Spacer(),
                                                          if (widget.selectTask.currency?.name == null &&
                                                              widget.selectTask.answers[index].price != null)
                                                            Text(
                                                              '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} ',
                                                              style: CustomTextStyle.black_15_w600_171716,
                                                            ),
                                                          if (widget.selectTask.currency?.name == 'Дирхам' &&
                                                              widget.selectTask.answers[index].price != null)
                                                            Text(
                                                              '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} AED',
                                                              style: CustomTextStyle.black_15_w600_171716,
                                                            ),
                                                          if (widget.selectTask.currency?.name == 'Российский рубль' &&
                                                              widget.selectTask.answers[index].price != null)
                                                            Text(
                                                              '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)}  ₽',
                                                              style: CustomTextStyle.black_15_w600_171716,
                                                            ),
                                                          if (widget.selectTask.currency?.name == 'Доллар США' &&
                                                              widget.selectTask.answers[index].price != null)
                                                            Text(
                                                              '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} \$',
                                                              style: CustomTextStyle.black_15_w600_171716,
                                                            ),
                                                          if (widget.selectTask.currency?.name == 'Евро' &&
                                                              widget.selectTask.answers[index].price != null)
                                                            Text(
                                                              '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} €',
                                                              style: CustomTextStyle.black_15_w600_171716,
                                                            ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          Text(
                                                            'completed_tasks'.tr(),
                                                            style: CustomTextStyle.grey_12_w400,
                                                          ),
                                                          SizedBox(width: 4.w),
                                                          if (widget.selectTask.answers[index].owner != null)
                                                            Text(
                                                              widget
                                                                  .selectTask.answers[index].owner!.countOrdersComplete
                                                                  .toString(),
                                                              style: CustomTextStyle.black_12_w400,
                                                            ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (widget.selectTask.answers[index].description != null)
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            if (widget.selectTask.answers[index].description != null)
                                              Padding(
                                                padding: EdgeInsets.only(left: 10.w),
                                                child: Text(
                                                  widget.selectTask.answers[index].description!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                  style: CustomTextStyle.black_12_w400_292D32,
                                                ),
                                              ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 50.h,
                                                  width: 140.w,
                                                  child: CustomButton(
                                                    onTap: () async {
                                                      final chatBloc = BlocProvider.of<ChatBloc>(context);
                                                      chatBloc.editShowPersonChat(false);
                                                      chatBloc.editChatId(widget.selectTask.chatId);
                                                      chatBloc.messages = [];
                                                      final idChat = await Navigator.of(context).pushNamed(
                                                        AppRoute.personalChat,
                                                        arguments: [
                                                          '${widget.selectTask.answers[index].chatId}',
                                                          '${widget.selectTask.answers[index].owner?.firstname ?? ''} ${widget.selectTask.answers[index].owner?.lastname ?? ''}',
                                                          '${widget.selectTask.answers[index].owner?.id}',
                                                          '${widget.selectTask.answers[index].owner?.photo}',
                                                        ],
                                                      );
                                                      chatBloc.editShowPersonChat(true);
                                                      chatBloc.editChatId(null);
                                                    },
                                                    btnColor: ColorStyles.greyDADADA,
                                                    textLabel: Text(
                                                      'write_to_the_chat'.tr(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  height: 50.h,
                                                  width: 140.w,
                                                  child: CustomButton(
                                                    onTap: () {
                                                      log(widget.selectTask.answers[index].id!.toString());
                                                      widget.selectTask.status = 'Completed';
                                                      Repository().editTaskPatch(
                                                          BlocProvider.of<ProfileBloc>(context).access,
                                                          widget.selectTask);

                                                      context.read<TasksBloc>().add(UpdateTaskEvent());
                                                      BlocProvider.of<ProfileBloc>(context)
                                                          .add(UpdateProfileEvent(user));
                                                      Navigator.pop(context);
                                                    },
                                                    btnColor: ColorStyles.yellowFFD70A,
                                                    textLabel: Text(
                                                      'dones'.tr(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500),
                                                    ),
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
                              } else {
                                return SizedBox(
                                  height: 205.h,
                                  child: Padding(
                                    padding: EdgeInsets.only(top: 15.h),
                                    child: ScaleButton(
                                      bound: 0.02,
                                      onTap: () async {
                                        final owner = await Repository().getRanking(
                                            widget.selectTask.answers[index].owner?.id,
                                            BlocProvider.of<ProfileBloc>(context).access);
                                        widget.openOwner(owner);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorStyles.whiteFFFFFF,
                                          borderRadius: BorderRadius.circular(20.r),
                                          boxShadow: [
                                            BoxShadow(
                                              color: ColorStyles.shadowFC6554,
                                              offset: const Offset(0, 4),
                                              blurRadius: 45.r,
                                            )
                                          ],
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                if (widget.selectTask.answers[index].owner?.photo != null)
                                                  ClipRRect(
                                                    borderRadius: BorderRadius.circular(1000.r),
                                                    child: Image.network(
                                                      widget.selectTask.answers[index].owner!.photo!,
                                                      height: 48.h,
                                                      width: 48.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                SizedBox(width: 15.w),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width: 300.w,
                                                        child: Row(
                                                          children: [
                                                            SizedBox(
                                                              width: 110.w,
                                                              child: Text(
                                                                '${widget.selectTask.answers[index].owner?.firstname ?? '-'} ${widget.selectTask.answers[index].owner?.lastname ?? '-'}',
                                                                style: CustomTextStyle.black_15_w600_171716,
                                                                softWrap: true,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            if (widget.selectTask.currency?.name == null &&
                                                                widget.selectTask.answers[index].price != null)
                                                              Text(
                                                                '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} ',
                                                                style: CustomTextStyle.black_15_w600_171716,
                                                              ),
                                                            if (widget.selectTask.currency?.name == 'Дирхам' &&
                                                                widget.selectTask.answers[index].price != null)
                                                              Text(
                                                                '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} AED',
                                                                style: CustomTextStyle.black_15_w600_171716,
                                                              ),
                                                            if (widget.selectTask.currency?.name ==
                                                                    'Российский рубль' &&
                                                                widget.selectTask.answers[index].price != null)
                                                              Text(
                                                                '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)}  ₽',
                                                                style: CustomTextStyle.black_15_w600_171716,
                                                              ),
                                                            if (widget.selectTask.currency?.name == 'Доллар США' &&
                                                                widget.selectTask.answers[index].price != null)
                                                              Text(
                                                                '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} \$',
                                                                style: CustomTextStyle.black_15_w600_171716,
                                                              ),
                                                            if (widget.selectTask.currency?.name == 'Евро' &&
                                                                widget.selectTask.answers[index].price != null)
                                                              Text(
                                                                '${'before'.tr()} ${_textCurrency(widget.selectTask.answers[index].price!)} €',
                                                                style: CustomTextStyle.black_15_w600_171716,
                                                              ),
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(height: 6.h),
                                                      Row(
                                                        children: [
                                                          SvgPicture.asset('assets/icons/star.svg'),
                                                          SizedBox(width: 4.w),
                                                          Text(
                                                            widget.selectTask.answers[index].owner?.ranking == null
                                                                ? '0'
                                                                : widget.selectTask.answers[index].owner!.ranking
                                                                    .toString(),
                                                            style: CustomTextStyle.black_13_w500_171716,
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (widget.selectTask.answers[index].description != null)
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                            if (widget.selectTask.answers[index].description != null)
                                              Padding(
                                                padding: EdgeInsets.only(left: 10.w),
                                                child: Text(
                                                  widget.selectTask.answers[index].description!,
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 3,
                                                  style: CustomTextStyle.black_12_w400_292D32,
                                                ),
                                              ),
                                            SizedBox(
                                              height: 30.h,
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 50.h,
                                                  width: 140.w,
                                                  child: CustomButton(
                                                    onTap: () async {
                                                      final chatBloc = BlocProvider.of<ChatBloc>(context);
                                                      chatBloc.editShowPersonChat(false);
                                                      chatBloc.editChatId(widget.selectTask.chatId);
                                                      chatBloc.messages = [];
                                                      final idChat = await Navigator.of(context).pushNamed(
                                                        AppRoute.personalChat,
                                                        arguments: [
                                                          '${widget.selectTask.answers[index].chatId}',
                                                          '${widget.selectTask.answers[index].owner?.firstname ?? ''} ${widget.selectTask.answers[index].owner?.lastname ?? ''}',
                                                          '${widget.selectTask.answers[index].owner?.id}',
                                                          '${widget.selectTask.answers[index].owner?.photo}',
                                                        ],
                                                      );
                                                      chatBloc.editShowPersonChat(true);
                                                      chatBloc.editChatId(null);
                                                    },
                                                    btnColor: ColorStyles.greyDADADA,
                                                    textLabel: Text(
                                                      'write_to_the_chat'.tr(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                SizedBox(
                                                  height: 50.h,
                                                  width: 140.w,
                                                  child: CustomButton(
                                                    onTap: () async {},
                                                    btnColor: ColorStyles.yellowFFD70A,
                                                    textLabel: Text(
                                                      'you_have_been_chosen'.tr(),
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12.sp,
                                                          fontWeight: FontWeight.w700),
                                                    ),
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
                            }
                          } else {
                            Container();
                          }
                        }
                        return null;
                      },
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  String _textCurrency(int data) {
    if (data >= 1000) {
      var formatter = NumberFormat('#,###');

      return formatter.format(data).replaceAll(',', ' ');
    } else {
      return data.toString();
    }
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

  String _textCountry(Task task) {
    var text = '';
    for (var country in task.countries) {
      text += '${country.name}, ';
    }
    for (var region in task.regions) {
      text += '${region.name}, ';
    }
    for (var town in task.towns) {
      text += '${town.name}, ';
    }
    if (text.isNotEmpty) text = text.substring(0, text.length - 2);
    if (text.isEmpty) text = 'all_countries_selected'.tr();

    return text;
  }
}
