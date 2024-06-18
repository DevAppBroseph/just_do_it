import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';

class CustomTextStyle {
  static TextStyle sf11w400(Color color) {
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

  static TextStyle sf12w600 = TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.purplePrimary,
    fontFamily: 'SFPro',
  );

  static TextStyle black12ellipsis = TextStyle(
    fontSize: 13.sp,
    color: Colors.black,
    overflow: TextOverflow.ellipsis,
    fontFamily: 'SFPro',
  );
  static TextStyle sf13w400(Color color) {
    return TextStyle(
        fontSize: 13.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf14w400(Color color) {
    return TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf15w400(Color color) {
    return TextStyle(
        fontSize: 15.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle grey14w400 = TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.greySecondary,
    fontFamily: 'SFPro',
  );

  static TextStyle sf16w400(Color color) {
    return TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf16w600(Color color) {
    return TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf17w600(Color color) {
    return TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w600,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle black_16_w600_171716 = TextStyle(
    fontSize: 17.sp,
    fontWeight: FontWeight.w600,
    color: AppColors.blackSecondary,
    fontFamily: 'SFPro',
  );
  static TextStyle sf17w400(Color color) {
    return TextStyle(
        fontSize: 17.sp,
        fontWeight: FontWeight.w400,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf18w800(Color color) {
    return TextStyle(
        fontSize: 18.sp,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf19w800(Color color) {
    return TextStyle(
        fontSize: 19.sp,
        fontWeight: FontWeight.w800,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf21w700(Color color) {
    return TextStyle(
        fontSize: 21.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle sf22w700(Color color) {
    return TextStyle(
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'SFPro',
        color: color);
  }

  static TextStyle black_22_w700_171716 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.blackSecondary,
    fontFamily: 'SFPro',
  );

  static TextStyle black_22_w700 = TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.blackSecondary,
    fontFamily: 'SFPro',
  );

  static TextStyle blackEmpty = const TextStyle(
    color: Colors.black,
  );
}
