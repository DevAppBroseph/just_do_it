import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scale_button/scale_button.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    super.key,
    required this.onTap,
    required this.btnColor,
    required this.textLabel,
  });

  Function onTap;
  Color btnColor;
  Widget textLabel;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ScaleButton(
        duration: const Duration(milliseconds: 50),
        bound: 0.01,
        onTap: () => onTap(),
        child: Container(
          height: 55.h,
          decoration: BoxDecoration(
            color: btnColor,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: textLabel,
          ),
        ),
      ),
    );
  }
}
