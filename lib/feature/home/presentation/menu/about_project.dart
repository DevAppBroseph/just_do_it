import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';

class AboutProject extends StatefulWidget {
  @override
  State<AboutProject> createState() => _AboutProjectState();
}

class _AboutProjectState extends State<AboutProject> {
  int? selectIndex;
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 66.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 28.w),
                  child: SizedBox(
                    height: 24.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: Transform.rotate(
                              angle: pi,
                              child: SvgPicture.asset(
                                  'assets/icons/arrow_right.svg')),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'О проекте',
                              style: CustomTextStyle.black_21_w700,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      SizedBox(height: 50.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 50.w),
                        child: Center(
                          child: Text(
                            'jobyfine'.toUpperCase(),
                            style: CustomTextStyle.black_32_w900_171716
                                .copyWith(color: ColorStyles.yellowFFD70B),
                          ),
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.\n\n',
                          style: CustomTextStyle.black_13_w400_515150,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud ametAmet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet',
                          style: CustomTextStyle.black_13_w400_515150,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Container(
                          height: 1.h,
                          color: ColorStyles.greyDADADA,
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          'Вопрос ответ',
                          style: CustomTextStyle.black_21_w700_171716,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Column(children: itemQuestion(0)),
                      SizedBox(height: 30.h),
                      Column(children: itemQuestion(1)),
                      SizedBox(height: 30.h),
                      Column(children: itemQuestion(2)),
                      SizedBox(height: 30.h),
                      Column(children: itemQuestion(3)),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "Пользовательское соглашение",
                          style: CustomTextStyle.blue_15_w400_336FEE
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          "Согласие на обработку персональных данных",
                          style: CustomTextStyle.blue_15_w400_336FEE
                              .copyWith(decoration: TextDecoration.underline),
                        ),
                      ),
                      SizedBox(height: 175.h),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> itemQuestion(int index) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: GestureDetector(
          onTap: () {
            if (selectIndex == index) {
              selectIndex = null;
            } else {
              selectIndex = index;
            }
            setState(() {});
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
                  style: CustomTextStyle.black_15_w600_171716,
                ),
              ),
              selectIndex == index
                  ? Icon(
                      Icons.keyboard_arrow_up,
                      color: ColorStyles.blue336FEE,
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorStyles.greyD9D9D9,
                    ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10.h),
      AnimatedContainer(
        height: selectIndex != null
            ? selectIndex == index
                ? 60.h
                : 0
            : 0,
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        duration: const Duration(milliseconds: 300),
        child: Container(
          child: Text(
            'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
            style: CustomTextStyle.black_13_w400_515150,
          ),
        ),
      ),
    ];
  }
}
