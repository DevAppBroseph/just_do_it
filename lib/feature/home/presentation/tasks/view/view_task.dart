import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/view/auth_page.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply/reply_bloc.dart'
    as rep;
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/edit_task.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:open_file/open_file.dart';
import 'package:scale_button/scale_button.dart';
import 'package:url_launcher/url_launcher.dart';

class TaskView extends StatefulWidget {
  Task selectTask;
  Function(Owner?) openOwner;
  bool canSelect;
  bool canEdit;
  TaskView({
    super.key,
    required this.selectTask,
    required this.openOwner,
    this.canSelect = false,
    this.canEdit = false,
  });

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  GlobalKey globalKey = GlobalKey();
  bool showMore = false;

  @override
  Widget build(BuildContext context) {
    final user = BlocProvider.of<ProfileBloc>(context).user;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          SizedBox(height: 10.h),
          Row(
            children: [
              Text(
                'Открыто',
                style: CustomTextStyle.grey_12_w400,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => taskMoreDialog(
                    context,
                    getWidgetPosition(globalKey),
                    (index) {},
                    widget.selectTask),
                child: SvgPicture.asset(
                  'assets/icons/more-circle.svg',
                  key: globalKey,
                  height: 20.h,
                  color: ColorStyles.black515150,
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
                      'Редактировать',
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
                            title: const Text('Удалить'),
                            content:
                                const Text('Вы подтверждаете удаление заказа?'),
                            actions: [
                              CupertinoButton(
                                child: const Text('Отмена'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              CupertinoButton(
                                child: Text(
                                  'Удалить',
                                  style: CustomTextStyle.red_16_w400,
                                ),
                                onPressed: () async {
                                  final access =
                                      await Storage().getAccessToken();
                                  final res = await Repository()
                                      .deleteTask(widget.selectTask, access!);
                                  if (res) Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          );
                        },
                      );
                    },
                    child: Text(
                      'Удалить',
                      style: CustomTextStyle.black_12_w400
                          .copyWith(color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          if (widget.selectTask.currency?.name == null)
            Text(
              'до ${widget.selectTask.priceTo} ',
              style: CustomTextStyle.black_17_w500_171716,
            ),
          if (widget.selectTask.currency?.name == 'Дирхам')
            Text(
              'до ${widget.selectTask.priceTo} AED',
              style: CustomTextStyle.black_17_w500_171716,
            ),
          if (widget.selectTask.currency?.name == 'Российский рубль')
            Text(
              'до ${widget.selectTask.priceTo}  ₽',
              style: CustomTextStyle.black_17_w500_171716,
            ),
          if (widget.selectTask.currency?.name == 'Доллар США')
            Text(
              'до ${widget.selectTask.priceTo} \$',
              style: CustomTextStyle.black_17_w500_171716,
            ),
          if (widget.selectTask.currency?.name == 'Евро')
            Text(
              'до ${widget.selectTask.priceTo} €',
              style: CustomTextStyle.black_17_w500_171716,
            ),
          SizedBox(height: 12.h),
          Text(
            widget.selectTask.name,
            style: CustomTextStyle.black_17_w800_171716,
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Image.network(
                '$server${widget.selectTask.activities?.photo ?? ''}',
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
          Text(
            'Описание',
            style: CustomTextStyle.grey_14_w400,
          ),
          SizedBox(height: 8.h),
          Container(
            decoration: BoxDecoration(
              color: ColorStyles.whiteFFFFFF,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: ColorStyles.shadowFC6554,
                  offset: const Offset(0, 4),
                  blurRadius: 45.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.selectTask.description,
                  overflow: TextOverflow.ellipsis,
                  maxLines: showMore ? 10000000 : 3,
                  style: CustomTextStyle.black_12_w400_292D32,
                ),
                if (!showMore) SizedBox(height: 8.h),
                if (!showMore && widget.selectTask.description.length > 80)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showMore = true;
                      });
                    },
                    child: Text(
                      'Показать больше',
                      style: CustomTextStyle.blue_11_w400_336FEE,
                    ),
                  )
              ],
            ),
          ),
          SizedBox(height: 15.h),
          if (widget.selectTask.files != null &&
              widget.selectTask.files!.isNotEmpty)
            SizedBox(
              height: 60.h,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.selectTask.files!.length,
                scrollDirection: Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  bool file = false;
                  if (widget.selectTask.files![index].linkUrl != null &&
                      (widget.selectTask.files![index].linkUrl!
                              .contains('.png') ||
                          widget.selectTask.files![index].linkUrl!
                              .contains('.jpg') ||
                          widget.selectTask.files![index].linkUrl!
                              .contains('.jpeg'))) {
                    file = false;
                  } else if (widget.selectTask.files![index].linkUrl != null &&
                      (widget.selectTask.files![index].linkUrl!
                              .contains('.pdf') ||
                          widget.selectTask.files![index].linkUrl!
                              .contains('.doc') ||
                          widget.selectTask.files![index].linkUrl!
                              .contains('.docx'))) {
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
                              if (widget.selectTask.files![index].file !=
                                  null) {
                                OpenFile.open(
                                    widget.selectTask.files![index].file!.path);
                              } else {
                                launch(widget.selectTask.files![index].linkUrl!
                                        .contains(server)
                                    ? widget.selectTask.files![index].linkUrl!
                                    : server +
                                        widget
                                            .selectTask.files![index].linkUrl!);
                              }
                            },
                            child: Container(
                              height: 50.h,
                              width: 50.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black)
                                  ],
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
                        OpenFile.open(
                            widget.selectTask.files![index].file!.path);
                      } else {
                        launch(widget.selectTask.files![index].linkUrl!
                                .contains(server)
                            ? widget.selectTask.files![index].linkUrl!
                            : server +
                                widget.selectTask.files![index].linkUrl!);
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
                              child:
                                  widget.selectTask.files![index].byte != null
                                      ? Image.memory(
                                          widget.selectTask.files![index].byte!,
                                          fit: BoxFit.cover,
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: widget.selectTask
                                              .files![index].linkUrl!,
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
          SizedBox(height: 15.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 150.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Регион',
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
              const Spacer(),
              SizedBox(
                width: 150.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Срок исполнения',
                      style: CustomTextStyle.grey_14_w400,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      widget.selectTask.dateEnd,
                      style: CustomTextStyle.black_12_w400_292D32,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 50.h),
          Text(
            widget.selectTask.asCustomer ?? false ? 'Заказчик' : 'Исполнитель',
            style: CustomTextStyle.grey_14_w400,
          ),
          SizedBox(height: 6.h),
          ScaleButton(
            bound: 0.02,
            onTap: () {
              widget.openOwner(widget.selectTask.owner);
            },
            child: Container(
              decoration: BoxDecoration(
                color: ColorStyles.whiteFFFFFF,
                borderRadius: BorderRadius.circular(10.r),
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
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              'Рейтинг',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                            SizedBox(width: 8.w),
                            SvgPicture.asset('assets/icons/star.svg'),
                            SizedBox(width: 4.w),
                            Text(
                              '-',
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
          ),
          SizedBox(height: 38.h),
          if (user != null &&
              widget.canSelect &&
              user.id != widget.selectTask.owner?.id)
            CustomButton(
              onTap: () async {
                final chatBloc = BlocProvider.of<ChatBloc>(context);
                chatBloc.editShowPersonChat(false);
                chatBloc.editChatId(widget.selectTask.chatId);
                chatBloc.messages = [];
                await Navigator.of(context).pushNamed(
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
                'Написать',
                style: CustomTextStyle.black_16_w600_171716,
              ),
            ),
          SizedBox(height: 18.h),
          if (widget.canSelect && user?.id != widget.selectTask.owner?.id)
            CustomButton(
              onTap: () {
                if (user == null) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AuthPage(),
                      ));
                } else {
                  BlocProvider.of<rep.ReplyBloc>(context)
                      .add(rep.OpenSlidingPanelEvent());
                }
              },
              btnColor: ColorStyles.yellowFFD70A,
              textLabel: Text(
                'Откликнуться',
                style: CustomTextStyle.black_16_w600_171716,
              ),
            ),
          SizedBox(height: 20.h),
        ],
      ),
    );
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
    if (text.isEmpty) text = 'Выбраны все страны';

    return text;
  }
}
