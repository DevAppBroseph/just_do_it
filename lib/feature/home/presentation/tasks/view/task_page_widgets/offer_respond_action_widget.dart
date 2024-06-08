import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/data_formatter.dart';
import 'package:just_do_it/helpers/data_updater.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';

class OfferRespondActionWidget extends StatefulWidget {
  const OfferRespondActionWidget(
      {super.key,
      required this.task,
      required this.index,
      required this.openOwner,
      required this.canEdit});

  final Task task;
  final int index;
  final Function(Owner?) openOwner;
  final bool canEdit;

  @override
  State<OfferRespondActionWidget> createState() =>
      _OfferRespondActionWidgetState();
}

class _OfferRespondActionWidgetState extends State<OfferRespondActionWidget> {
  late final index = widget.index;
  late final user = BlocProvider.of<ProfileBloc>(context).user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15.h),
      child: ScaleButton(
        bound: 0.02,
        onTap: () async {
          if (user!.isBanned!) {
            banDialog(context, 'profile_viewing_is_currently_restricted'.tr());
          } else {
            final owner = await Repository().getRanking(
                widget.task.answers[index].owner?.id,
                BlocProvider.of<ProfileBloc>(context).access);
            widget.openOwner(owner);
          }
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
                  if (widget.task.answers[index].owner?.photo != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(1000.r),
                      child: Image.network(
                        widget.task.answers[index].owner!.photo!,
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
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AutoSizeText(
                                    "${widget.task.answers[index].owner?.firstname ?? '-'} ${widget.task.answers[index].owner?.lastname ?? '-'}",
                                    wrapWords: false,
                                    style: CustomTextStyle.black_17_w600_171716,
                                    maxLines: 2,
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
                                        widget.task.answers[index].owner
                                                    ?.ranking ==
                                                null
                                            ? '0'
                                            : widget.task.answers[index].owner!
                                                .ranking
                                                .toString(),
                                        style: CustomTextStyle
                                            .black_13_w500_171716,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'before'.tr(),
                              style: CustomTextStyle.black_15_w600_171716,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              '${DataFormatter.addSpacesToNumber(widget.task.answers[index].price ?? 0)} ${DataFormatter.convertCurrencyNameIntoSymbol(widget.task.currency?.name)} ',
                              style: CustomTextStyle.black_15_w600_171716,
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Row(
                          children: [
                            Text(
                              'completed_tasks'.tr(),
                              style: CustomTextStyle.grey_12_w400,
                            ),
                            SizedBox(width: 4.w),
                            if (widget.task.answers[index].owner != null)
                              Text(
                                widget.task.answers[index].owner!
                                    .countOrdersComplete
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
              if (widget.task.answers[index].description != null)
                SizedBox(
                  height: 15.h,
                ),
              if (widget.task.answers[index].description != null)
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: Text(
                    widget.task.answers[index].description!,
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
                        if (user!.isBanned!) {
                          banDialog(context,
                              'access_to_chat_is_currently_restricted'.tr());
                        } else {
                          final chatBloc = BlocProvider.of<ChatBloc>(context);
                          chatBloc.editShowPersonChat(false);
                          chatBloc.editChatId(widget.task.chatId);
                          chatBloc.messages = [];
                          chatBloc.editShowPersonChat(true);
                          chatBloc.editChatId(null);
                        }
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
                  if (widget.task.owner?.id == user?.id) ...[
                    SizedBox(
                      height: 50.h,
                      width: 140.w,
                      child: CustomButton(
                        onTap: () async {},
                        btnColor: Colors.white,
                        textLabel: Text(
                          'you_have_been_chosen'.tr(),
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ] else ...[
                    SizedBox(
                      height: 50.h,
                      width: 140.w,
                      child: CustomButton(
                        onTap: () {
                          widget.task.status = TaskStatus.completed;
                          Repository().editTaskPatch(
                              BlocProvider.of<ProfileBloc>(context).access,
                              widget.task);
                          DataUpdater().updateTasksAndProfileData(context);
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
                  ]
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
