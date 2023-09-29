import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/auth/view/auth_page.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply/reply_bloc.dart'
    as rep;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply_from_favourite/reply_fav_bloc.dart'
    as repf;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response/response_bloc.dart'
    as res;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response_from_favourite/response_fav_bloc.dart'
    as resf;
import 'package:just_do_it/feature/home/presentation/tasks/view/task_page_widgets/block_reason_widget.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/data_updater.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/network/repository.dart';

class TaskStatusActionWidget extends StatelessWidget {
  const TaskStatusActionWidget(
      {super.key,
      required this.task,
      required this.isTaskOwner,
      required this.fromFav,
      required this.updateTask});

  final Task task;
  final bool isTaskOwner;
  final bool fromFav;
  final VoidCallback updateTask;

  @override
  Widget build(BuildContext context) {
    print("TaskActionWidgetIsAnswered ${task.isAnswered}");
    if (isTaskOwner) {
      if (task.isBanned!) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocReasonWidget(
              task: task,
              isTaskOwner: isTaskOwner,
            ),
            Row(
              children: [
                const Spacer(),
                GestureDetector(
                    onTap: () {
                      helpOnTopDialog(context, ''.tr(), 'comply_with'.tr());
                    },
                    child: SvgPicture.asset(SvgImg.help)),
              ],
            ),
            SizedBox(height: 5.h),
            CustomButton(
              onTap: () async {
                if (task.canAppellate) {
                  final isSuccess = await Repository().resendTaskForModeration(
                      BlocProvider.of<ProfileBloc>(context).access, task.id!);
                  if (isSuccess&&context.mounted) {
                    DataUpdater().updateTasksAndProfileData(context);
                    updateTask();
                  }
                }
              },
              btnColor: task.canAppellate
                  ? ColorStyles.yellowFFD70A
                  : ColorStyles.greyDADADA,
              textLabel: Text(
                'resend'.tr(),
                style: task.canAppellate
                    ? CustomTextStyle.black_16_w600_171716
                    : CustomTextStyle.grey_14_w600.copyWith(fontSize: 16),
              ),
            ),
          ],
        );
      }
    } else {
      if (task.isAnswered?.status == 'Progress') {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomButton(
              onTap: () {},
              btnColor: ColorStyles.greyEAECEE,
              textLabel: Text(
                'you_responded'.tr(),
                style: CustomTextStyle.black_16_w600_171716,
              ),
            ),
            if (task.isBanned!) ...[
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        helpOnTopDialog(
                            context, ''.tr(), 'task_has_been_blocked'.tr());
                      },
                      child: SvgPicture.asset(SvgImg.help)),
                ],
              ),
              SizedBox(height: 5.h),
              CustomButton(
                onTap: () async {
                  final answer = task.answers.firstWhere((element) =>
                      element.owner?.id ==
                      context.read<ProfileBloc>().user?.id);
                  await Repository().deleteResponse(
                      BlocProvider.of<ProfileBloc>(context).access, answer.id!);
                  if (context.mounted) {
                    DataUpdater().updateTasksAndProfileData(context);
                  }
                },
                btnColor: ColorStyles.yellowFFD70A,
                textLabel: Text(
                  'cance_response'.tr(),
                  style: CustomTextStyle.black_16_w600_171716,
                ),
              ),
            ]
          ],
        );
      } else if (task.isAnswered?.status == 'Selected' &&
          task.status != TaskStatus.completed) {
        CustomButton(
          onTap: () async {},
          btnColor: ColorStyles.greyEAECEE,
          textLabel: Text(
            'you_have_been_chosen'.tr(),
            style: CustomTextStyle.black_16_w600_171716,
          ),
        );
      } else if (task.isAnswered == null && !task.isBanned!) {
        return CustomButton(
          onTap: () async {
            final user = context.read<ProfileBloc>().user;
            if (user == null) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AuthPage(),
                  ));
            } else {
              if (user.isBanned!) {
                if (task.isTask!) {
                  banDialog(context, 'responses_to_tasks_is'.tr());
                } else {
                  banDialog(context, 'responses_to_offers_is'.tr());
                }
              } else {
                if (user.docInfo?.isEmpty ?? true) {
                  if (fromFav) {
                    BlocProvider.of<repf.ReplyFromFavBloc>(context)
                        .add(repf.OpenSlidingPanelEvent(selectTask: task));
                  } else {
                    BlocProvider.of<rep.ReplyBloc>(context)
                        .add(rep.OpenSlidingPanelEvent(selectTask: task));
                  }
                } else {
                  if (fromFav) {
                    BlocProvider.of<resf.ResponseBlocFromFav>(context).add(
                        resf.OpenSlidingPanelFromFavEvent(selectTask: task));
                  } else {
                    BlocProvider.of<res.ResponseBloc>(context)
                        .add(res.OpenSlidingPanelEvent(selectTask: task));
                  }
                }
              }
            }
          },
          btnColor: ColorStyles.yellowFFD70A,
          textLabel: Text(
            task.isTask! ? 'respond'.tr() : 'accept_the_offer'.tr(),
            style: CustomTextStyle.black_16_w600_171716,
          ),
        );
      }
    }

    return const SizedBox();
  }
}
