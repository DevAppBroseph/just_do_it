import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/data_formatter.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

class MoveTaskToTopButton extends StatelessWidget {
  const MoveTaskToTopButton(
      {super.key,
      required this.task,
      required this.user,
      required this.updateTask});
  final VoidCallback updateTask;
  final Task task;
  final UserRegModel? user;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TasksBloc, TasksState>(buildWhen: (previous, current) {
      if (current is UpdateTask) {
        return true;
      }
      if (previous != current) {
        return true;
      }
      return false;
    }, builder: (context, state) {
      if (task.isGradedNow!) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'before'.tr(),
              style: CustomTextStyle.black17w500171716,
            ),
            GestureDetector(
              onTap: () {
                if (task.owner?.id == user?.id) {
                  onTopDialog(context, 'raise_ad'.tr(),
                      'ad_is_fixed_in_the_top'.tr(), 'ad_is_now_above'.tr());
                } else {
                  helpOnTopDialog(context, 'raise_ad'.tr(), 'the_impact'.tr());
                }
              },
              child: Container(
                height: 30.h,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: ColorStyles.yellowFFCA0D,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/arrow_up_yellow.svg',
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        DateTime.parse(task.lastUpgrade!).toLocal().day ==
                                DateTime.now().day
                            ? "raised_in".tr()
                            : 'raised_yesterday_in'.tr(),
                        style: CustomTextStyle.black_11_w500_171716,
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        DataFormatter.formatHourAndMinute(
                            DateTime.parse(task.lastUpgrade!).toLocal()),
                        style: CustomTextStyle.black_11_w500_171716,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      } else if (task.owner?.id == user?.id && !task.status.isInactive) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'before'.tr(),
              style: CustomTextStyle.black17w500171716,
            ),
            GestureDetector(
              onTap: () async {
                final isOwner = task.owner?.id == user?.id;
                if (context.mounted) {
                  final accessToken = context.read<ProfileBloc>().access;
                  Task newTask = task..isGraded = true;
                  final isUpgradeSuccessful =
                      await Repository().editTask(accessToken, newTask);
                  if (isUpgradeSuccessful) {
                    if (context.mounted) {
                      context.read<TasksBloc>().add(
                            GetTasksEvent(),
                          );
                      updateTask();
                      context.read<TasksBloc>().add(UpdateTaskEvent());

                      BlocProvider.of<ProfileBloc>(context)
                          .add(GetProfileEvent());
                      if (isOwner) {
                        onTopDialog(
                            context,
                            'raise_ad'.tr(),
                            'ad_is_fixed_in_the_top'.tr(),
                            'ad_is_now_above'.tr());
                      } else {
                        onTopDialog(
                            context,
                            'up_to'.tr(),
                            'response_is_fixed_in_the_top'.tr(),
                            'your_ad_is_now_above_others'.tr());
                      }
                    }
                  } else {
                    if (context.mounted) {
                      log("IsOwner $isOwner");
                      if (isOwner) {
                        noMoney(
                            context, 'raise_task'.tr(), 'task_to_the_top'.tr());
                      } else {
                        noMoney(context, 'raise_offer'.tr(),
                            'the_offer_to_the_top'.tr());
                      }
                    }
                  }
                }
              },
              child: Container(
                height: 30.h,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: ColorStyles.purpleA401C4,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/arrow_up_purple.svg',
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    Text(
                      (task.owner?.id == user?.id ? 'raise_ad' : 'up_to').tr(),
                      style: CustomTextStyle.white_11,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      } else {
        return Text(
          'before'.tr(),
          style: CustomTextStyle.black17w500171716,
        );
      }
    });
  }
}
