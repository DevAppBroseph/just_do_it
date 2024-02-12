import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/formatter_upper.dart';
import 'package:just_do_it/feature/auth/widget/loader.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/data_updater.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';

class ReviewCreationWidget extends StatefulWidget {
  const ReviewCreationWidget(
      {super.key,
      required this.task,
      required this.isTaskOwner,
      required this.openOwner});

  final Task task;
  final bool isTaskOwner;
  final Function(Owner?) openOwner;

  factory ReviewCreationWidget.customer(
          Task task, Function(Owner?) openOwner) =>
      ReviewCreationWidget(task: task, isTaskOwner: true, openOwner: openOwner);

  factory ReviewCreationWidget.agent(Task task, Function(Owner?) openOwner) =>
      ReviewCreationWidget(
          task: task, isTaskOwner: false, openOwner: openOwner);

  @override
  State<ReviewCreationWidget> createState() => _ReviewCreationWidgetState();
}

class _ReviewCreationWidgetState extends State<ReviewCreationWidget> {
  bool hasJustReviewed = false;
  double reviewRating = 1;
  final descriptionTextController = TextEditingController();
  late final user = BlocProvider.of<ProfileBloc>(context).user;
  late final agentOrCustomer = widget.isTaskOwner
      ? widget.task.answers
          .firstWhere((element) => element.status == "Selected")
          .owner
      : OwnerOrder.fromOwner(widget.task.owner!);
  Future<void> sendReview() async {
    if (user!.isBanned!) {
      banDialog(context, 'giving_feedback_is_currently_restricted'.tr());
    } else {
      final owner = await Repository().getRanking(
          agentOrCustomer?.id, BlocProvider.of<ProfileBloc>(context).access);
      final hasAlreadyReviewed =
          owner?.reviews?.any((element) => element.taskId == widget.task.id);
      if (context.mounted) {
        if ((hasAlreadyReviewed ?? false) || hasJustReviewed) {
          CustomAlert().showMessage('you_have_already_left_a_review'.tr());
        } else if (descriptionTextController.text.trim().isEmpty) {
          CustomAlert().showMessage('leave_comment_on_review'.tr());
        } else {
          showLoaderWrapperWhite(context);
          hasJustReviewed = true;
          final addReviewsDetailSuccess = await Repository().addReviewsDetail(
              BlocProvider.of<ProfileBloc>(context).access,
              agentOrCustomer?.id,
              descriptionTextController.text,
              reviewRating,
              widget.task.id);
          if (context.mounted) {
            if (addReviewsDetailSuccess) {
              DataUpdater().updateTasksAndProfileData(context);
              widget.openOwner(widget.task.owner);
              scoreDialog(context, '50', 'left_a_review'.tr());
            }
            Future.delayed(const Duration(seconds: 2), () {
              Loader.hide();
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.task.answers.isNotEmpty &&
        widget.task.status == TaskStatus.completed &&
        !widget.task.isBanned! &&
        widget.task.answers.any((answer) => answer.status == "Selected")) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(color: Colors.red,height: 100,),
          if (widget.isTaskOwner) ...[
            Padding(
              padding: EdgeInsets.only(top: 15.h),
              child: ScaleButton(
                bound: 0.02,
                onTap: () async {
                  if (user!.isBanned!) {
                    banDialog(context,
                        'profile_viewing_is_currently_restricted'.tr());
                  } else {
                    final owner = await Repository().getRanking(
                        agentOrCustomer?.id,
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 13.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (agentOrCustomer?.photo != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(1000.r),
                              child: Image.network(
                                agentOrCustomer!.photo!,
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
                                  child: Text(
                                    '${agentOrCustomer?.firstname ?? '-'} ${agentOrCustomer?.lastname ?? '-'}',
                                    style: CustomTextStyle.black_15_w600_171716,
                                    softWrap: true,
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                Row(
                                  children: [
                                    SvgPicture.asset('assets/icons/star.svg'),
                                    SizedBox(width: 4.w),
                                    Text(
                                      (agentOrCustomer?.ranking == null)
                                          ? '0'
                                          : agentOrCustomer!.ranking.toString(),
                                      style:
                                          CustomTextStyle.black_13_w500_171716,
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
          ],

          SizedBox(height: 30.h),
          Text(
            'leave_a_review'.tr(),
            style: CustomTextStyle.black_17_w800,
          ),
          SizedBox(height: 15.h),
          Text(
            'points_are_credited_to_your_account_for_leaving_reviews_and_rating'
                .tr(),
            style: CustomTextStyle.black_14_w500_171716,
          ),
          SizedBox(height: 30.h),
          ScaleButton(
            onTap: () {},
            bound: 0.02,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
              decoration: BoxDecoration(
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: CustomTextField(
                height: 90.h,
                width: double.infinity,
                autocorrect: true,
                maxLines: 8,
                onTap: () {
                  setState(() {});
                },
                hintStyle: const TextStyle(color: Colors.black),
                style: CustomTextStyle.black_14_w400_171716,
                textEditingController: descriptionTextController,
                fillColor: ColorStyles.greyF9F9F9,
                onChanged: (value) {},
                formatters: [
                  UpperEveryTextInputFormatter(),
                ],
                hintText: 'custom_text'.tr(),
              ),
            ),
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              Text(
                (widget.isTaskOwner
                        ? 'rate_the_executor'
                        : 'evaluate_the_customer')
                    .tr(),
                style: CustomTextStyle.black_17_w800,
              ),
              SizedBox(width: 15.h),
              GestureDetector(
                onTap: () {
                  helpOnTopDialog(
                      context,
                      (widget.isTaskOwner
                              ? 'rate_the_executor'
                              : 'evaluate_the_customer')
                          .tr(),
                      'please_provide_a_rating'.tr());
                },
                child: SvgPicture.asset(
                  SvgImg.help,
                  color: Colors.black,
                  width: 20,
                  height: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          RatingBar.builder(
            initialRating: 0,
            minRating: 0,
            direction: Axis.horizontal,
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
              sendReview();
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
    }
    return const SizedBox();
  }
}
