import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/models/task/task.dart';

class BlockReasonWidget extends StatefulWidget {
  const BlockReasonWidget(
      {super.key, required this.task, required this.isTaskOwner});

  final Task task;
  final bool isTaskOwner;

  @override
  State<BlockReasonWidget> createState() => _BlockReasonWidgetState();
}

class _BlockReasonWidgetState extends State<BlockReasonWidget> {
  bool isOpen = false;
  @override
  Widget build(BuildContext context) {
    if ((widget.task.isBanned ?? false) && widget.isTaskOwner) {
      return Padding(
        padding: EdgeInsets.only(bottom: 20.h),
        child: Stack(
          children: [
            if (isOpen)
              AnimatedContainer(
                width: 330.w,
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: ColorStyles.whiteFFFFFF,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 50.h, bottom: 12.h, left: 16.w, right: 16.w),
                  child: SizedBox(
                    width: 250.w,
                    child: Text(
                      widget.task.banReason ?? ("unknown_reason".tr()),
                      style: CustomTextStyle.black_14_w400_515150,
                    ),
                  ),
                ),
              ),
            Container(
              height: 42.h,
              decoration: BoxDecoration(
                color: ColorStyles.redFC6554.withOpacity(0.19),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: InkWell(
                onTap: () {
                  if (isOpen) {
                    isOpen = false;
                  } else {
                    isOpen = true;
                  }
                  setState(() {});
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 23.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: SvgPicture.asset('assets/icons/info_circle.svg'),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        child: Text(
                          "ban_reason".tr(),
                          textAlign: TextAlign.start,
                          style: CustomTextStyle.red11w400171716,
                        ),
                      ),
                      const Spacer(),
                      isOpen
                          ? Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: const Icon(
                                Icons.keyboard_arrow_up,
                                size: 30,
                                color: ColorStyles.redFF5151,
                              ),
                            )
                          : Padding(
                              padding: EdgeInsets.only(top: 5.h),
                              child: const Icon(
                                Icons.keyboard_arrow_down,
                                size: 30,
                                color: ColorStyles.redFF5151,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
