import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Row(
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
                color: groupValue == value ? Colors.black : Colors.transparent,
              ),
            ),
          ],
        ),
        SizedBox(width: 10.w),
        Text(
          label,
          style: TextStyle(
            color: groupValue == value
                ? const Color(0xFF171716)
                : const Color(0xFFBDBDBD),
          ),
        )
      ],
    );
  }
}
