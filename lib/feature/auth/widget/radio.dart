import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';

class CustomCircleRadioButtonItem extends StatelessWidget {
  final String label;
  final int value;
  final int groupValue;

  const CustomCircleRadioButtonItem({
    super.key,
    required this.label,
    required this.value,
    required this.groupValue,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 18.h,
                width: 18.h,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEAECEE),
                ),
              ),
              Container(
                height: 10.h,
                width: 10.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      groupValue == value ? Colors.black : Colors.transparent,
                ),
              ),
            ],
          ),
          SizedBox(width: 10.w),
          Text(
            label,
            style: groupValue == value
                ? CustomTextStyle.sf17w400(AppColors.blackSecondary)
                : CustomTextStyle.grey14w400,
          )
        ],
      ),
    );
  }
}
