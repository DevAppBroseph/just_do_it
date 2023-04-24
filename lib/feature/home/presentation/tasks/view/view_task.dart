import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:scale_button/scale_button.dart';

class TaskView extends StatefulWidget {
  Task selectTask;
  Function(Owner?) openOwner;
  bool canSelect;
  TaskView({
    super.key,
    required this.selectTask,
    required this.openOwner,
    this.canSelect = false,
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
              Spacer(),
              GestureDetector(
                onTap: () => taskMoreDialog(
                  context,
                  getWidgetPosition(globalKey),
                  (index) {
                    // Navigator.pop(context);
                  },
                ),
                child: SvgPicture.asset(
                  'assets/icons/more-circle.svg',
                  key: globalKey,
                  height: 20.h,
                  color: ColorStyles.black515150,
                ),
              ),
            ],
          ),
          SizedBox(height: 22.h),
          Text(
            'до ${widget.selectTask.priceTo} ₽',
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
                '$server ${widget.selectTask.activities?.photo ?? ''}',
                height: 24.h,
              ),
              SizedBox(width: 8.h),
              Text(
                '${widget.selectTask.activities?.description ?? '-'}, ${widget.selectTask.subcategory?.description ?? '-'}',
                style: CustomTextStyle.black_12_w400_292D32,
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
                if (!showMore && widget.selectTask.description.length > 150)
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
          SizedBox(height: 30.h),
          Row(
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
                      widget.selectTask.region,
                      style: CustomTextStyle.black_12_w400_292D32,
                    ),
                  ],
                ),
              ),
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
                  Column(
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
                ],
              ),
            ),
          ),
          SizedBox(height: 38.h),
          if (widget.canSelect && user?.id != widget.selectTask.owner?.id)
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
              onTap: () {},
              btnColor: ColorStyles.yellowFFD70A,
              textLabel: Text(
                'Откликнуться',
                style: CustomTextStyle.black_16_w600_171716,
              ),
            )
        ],
      ),
    );
  }
}
