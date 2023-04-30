import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButton extends StatelessWidget {
  Function onBackPressed;
  String icon;
  Color? color;

  CustomIconButton({
    required this.onBackPressed,
    required this.icon,
    this.color,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onBackPressed(),
      child: Container(
        color: Colors.transparent,
        height: 30.h,
        width: 30.w,
        child: Align(
          alignment: Alignment.center,
          child: Transform.rotate(
            angle: pi,
            child: SvgPicture.asset(
              icon,
              height: 20.h,
              width: 20.w,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
