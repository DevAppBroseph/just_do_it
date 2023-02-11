import 'dart:math';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';

class PersonalChat extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 66.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Transform.rotate(
                  angle: pi,
                  child: SvgPicture.asset('assets/icons/arrow_right.svg'),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                'Floyd Miles',
                style: CustomTextStyle.black_20_w700,
              ),
              const Spacer(),
              SvgPicture.asset('assets/icons/more-circle.svg'),
            ]),
          ),
          const Spacer(),
          ListView.builder(
            shrinkWrap: true,
            itemCount: 2,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
            itemBuilder: ((context, index) {
              return Padding(
                padding:  EdgeInsets.only(bottom: 24.h),
                child: Align(
                    alignment: Alignment.bottomRight, child: Text('data$index')),
              );
            }),
          ),
          // ),
          Container(
            height: 109.h,
            decoration: BoxDecoration(
              color: ColorStyles.whiteFFFFFF,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -4),
                  color: ColorStyles.shadowFC6554,
                  blurRadius: 55.r,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 19.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(
                    width: 327.w,
                    hintText: 'Введите сообщение',
                    textEditingController: TextEditingController(),
                    fillColor: ColorStyles.greyF9F9F9,
                    contentPadding:
                        EdgeInsets.only(left: 16.w, top: 20.h, bottom: 20.h),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
