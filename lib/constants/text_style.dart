import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';

class LightTextStyles {
  final TextStyle sf22w700BlackSec =
      CustomTextStyle.sf22w700(LightAppColors.blackSecondary);

  final TextStyle sf21w700BlackSec =
      CustomTextStyle.sf21w700(LightAppColors.blackSecondary);

  final TextStyle sf19w800BlackSec =
      CustomTextStyle.sf19w800(LightAppColors.blackSecondary);

  final TextStyle sf18w800BlackSec =
      CustomTextStyle.sf18w800(LightAppColors.blackSecondary);

  final TextStyle sf17w400BlackSec =
      CustomTextStyle.sf17w400(LightAppColors.blackPrimary);

  final TextStyle sf15w400BlackSec =
      CustomTextStyle.sf15w400(LightAppColors.blackPrimary);

  final TextStyle sf13w400BlackSec =
      CustomTextStyle.sf13w400(LightAppColors.blackPrimary);

  final TextStyle sf12w400BlackSec =
      CustomTextStyle.sf12w400(LightAppColors.blackPrimary);

  final TextStyle style1 =
      CustomTextStyle.sf21w700(LightAppColors.blackPrimary);

  final TextStyle style3 =
      CustomTextStyle.sf18w800(LightAppColors.blackPrimary);
}

class DarkTextStyles {
  final TextStyle sf22w700BlackSec =
      CustomTextStyle.sf22w700(DarkAppColors.blackSecondary);

  final TextStyle sf21w700BlackSec =
      CustomTextStyle.sf21w700(DarkAppColors.blackSecondary);

  final TextStyle sf19w800BlackSec =
      CustomTextStyle.sf19w800(DarkAppColors.blackSecondary);

  final TextStyle sf18w800BlackSec =
      CustomTextStyle.sf18w800(DarkAppColors.blackSecondary);

  final TextStyle sf17w400BlackSec =
      CustomTextStyle.sf17w400(DarkAppColors.blackPrimary);

  final TextStyle sf15w400BlackSec =
      CustomTextStyle.sf15w400(DarkAppColors.blackPrimary);

  final TextStyle sf13w400BlackSec =
      CustomTextStyle.sf13w400(DarkAppColors.blackPrimary);
  final TextStyle sf12w400BlackSec =
      CustomTextStyle.sf12w400(DarkAppColors.blackPrimary);

  final TextStyle style1 = CustomTextStyle.sf21w700(DarkAppColors.blackPrimary);
  final TextStyle style2 = CustomTextStyle.sf19w800(DarkAppColors.whitePrimary);
  final TextStyle style3 = CustomTextStyle.sf18w800(DarkAppColors.whitePrimary);
}

class AppTextStyles {
  final LightTextStyles lightTextStyles;
  final DarkTextStyles darkTextStyles;

  AppTextStyles({
    required this.lightTextStyles,
    required this.darkTextStyles,
  });
}

class CustomTextStyle {
  static TextStyle sf11w400(Color? color) {
    return TextStyle(
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf12w400(Color color) {
    return TextStyle(
      fontSize: 12.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf13w400(Color? color) {
    return TextStyle(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf14w400(Color color) {
    return TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf15w400(Color color) {
    return TextStyle(
      fontSize: 15.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf16w400(Color color) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf16w600(Color color) {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf17w600(Color color) {
    return TextStyle(
      fontSize: 17.sp,
      fontWeight: FontWeight.w600,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf17w400(Color color) {
    return TextStyle(
      fontSize: 17.sp,
      fontWeight: FontWeight.w400,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf18w800(Color color) {
    return TextStyle(
      fontSize: 18.sp,
      fontWeight: FontWeight.w800,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf19w800(Color color) {
    return TextStyle(
      fontSize: 19.sp,
      fontWeight: FontWeight.w800,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf21w700(Color color) {
    return TextStyle(
      fontSize: 21.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle sf22w700(Color color) {
    return TextStyle(
      fontSize: 22.sp,
      fontWeight: FontWeight.w700,
      fontFamily: 'SFPro',
      color: color,
    );
  }

  static TextStyle blackEmpty = const TextStyle(
    color: Colors.black,
  );
}
