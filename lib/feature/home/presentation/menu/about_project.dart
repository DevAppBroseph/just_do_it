import 'dart:math' as math;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/models/question.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:open_file/open_file.dart';

class AboutProject extends StatefulWidget {
  @override
  State<AboutProject> createState() => _AboutProjectState();
}

class _AboutProjectState extends State<AboutProject> {
  About? about;
  int? selectIndex;

  @override
  void initState() {
    super.initState();
    getQuestions();
  }

  void getQuestions() async {
    about = await Repository().aboutList();
    setState(() {});
  }

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
                        CustomIconButton(
                          onBackPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: SvgImg.arrowRight,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'О проекте',
                              style: CustomTextStyle.black_22_w700,
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
                      SizedBox(height: 10.h),
                      Container(color: ColorStyles.yellowFFD70A,
                        child: SizedBox(height: 50.h)),
                      Container(
                        color: ColorStyles.yellowFFD70A,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 50.w),
                          child: Center(
                            child: Text(
                              'jobyfine'.toUpperCase(),
                              style: CustomTextStyle.black_39_w900_171716
                                  .copyWith(color: ColorStyles.black),
                            ),
                          ),
                        ),
                      ),
                      Container(color: ColorStyles.yellowFFD70A, child: SizedBox(height: 40.h)),
                      Container(
                        color: ColorStyles.yellowFFD70A,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40.w),
                          child: Text(
                            about?.about ?? '',
                            style: CustomTextStyle.black_14_w400_515150,
                          ),
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 40.w),
                      //   child: Text(
                      //     'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud ametAmet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet',
                      //     style: CustomTextStyle.black_13_w400_515150,
                      //   ),
                      // ),
                      Container(color: ColorStyles.yellowFFD70A, child: SizedBox(height: 40.h)),
                     
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          'Вопрос-ответ',
                          style: CustomTextStyle.black_22_w700_171716,
                        ),
                      ),
                      SizedBox(height: 30.h),
                      if (about != null)
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: about!.question.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: itemQuestion(
                                index,
                                about!.question[index].question,
                                about!.question[index].answer,
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: GestureDetector(
                          onTap: () async {
                            final res = await Repository()
                                .getFile(about?.confidence ?? '');
                            if (res != null) await OpenFile.open(res);
                          },
                          child: Text(
                            "Пользовательское соглашение",
                            style: CustomTextStyle.blue_16_w400_336FEE
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: GestureDetector(
                          onTap: () async {
                            final res = await Repository()
                                .getFile(about?.agreement ?? '');
                            if (res != null) await OpenFile.open(res);
                          },
                          child: Text(
                            "Согласие на обработку персональных данных",
                            style: CustomTextStyle.blue_16_w400_336FEE
                                .copyWith(decoration: TextDecoration.underline),
                          ),
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

  List<Widget> itemQuestion(int index, String question, String answer) {
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
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question,
                  textAlign: TextAlign.start,
                  style: CustomTextStyle.black_16_w600_171716,
                ),
              ),
              selectIndex == index
                  ? const Icon(
                      Icons.keyboard_arrow_up,
                      color: ColorStyles.blue336FEE,
                    )
                  : const Icon(
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
        child: Text(
          answer,
          style: CustomTextStyle.black_14_w400_515150,
        ),
      ),
      SizedBox(height: 10.h),
    ];
  }
}
