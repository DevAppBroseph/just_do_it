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
    return SizedBox(
      height: 40.h,
      width: 40.w,
      child: IconButton(
        onPressed: () => onBackPressed(),
        color: Colors.transparent,
        alignment: Alignment.center,
        icon: _icon(),
      ),
    );
  }

  Widget _icon() {
    return Transform.rotate(
      angle: pi,
      child: SvgPicture.asset(
        icon,
        height: 20.h,
        width: 20.w,
        color: color,
      ),
    );
  }
}
