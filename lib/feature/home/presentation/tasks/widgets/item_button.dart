import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:scale_button/scale_button.dart';

Widget itemButton(String title, String subtitle, String icon, Function onTap) {
  return ScaleButton(
    onTap: () => onTap(),
    bound: 0.02,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      color: Colors.transparent,
      height: 41.h,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset(
                icon,
                height: 18.h,
                width: 18.h,
              ),
            ],
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomTextStyle.black_14_w400_000000,
              ),
              SizedBox(height: 6.h),
              Text(
                subtitle,
                style: CustomTextStyle.grey_14_w400,
              )
            ],
          ),
          const Spacer(),
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: const Icon(
              Icons.keyboard_arrow_right_rounded,
              color: ColorStyles.greyBDBDBD,
            ),
          ),
        ],
      ),
    ),
  );
}
