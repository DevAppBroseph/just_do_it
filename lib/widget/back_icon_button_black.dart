import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIconButtonBlack extends StatelessWidget {
  Function onBackPressed;
  Icon icon;
  Color? color;

  CustomIconButtonBlack({
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
        color: Colors.black,
        alignment: Alignment.center,
        icon: icon,
      ),
    );
  }

  // Widget _icon() {
  //   return Transform.rotate(
  //     angle: pi,
  //     child: SvgPicture.asset(
  //       icon,
  //       height: 20.h,
  //       width: 20.w,
  //       color: color,
  //     ),
  //   );
  // }
}
