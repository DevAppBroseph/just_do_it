import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Logo extends StatelessWidget {
  const Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      'JUSTDOIT',
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 40.sp,
        letterSpacing: 0.1,
      ),
    );
  }
}
