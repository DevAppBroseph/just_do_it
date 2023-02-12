import 'dart:math';

import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';

class PersonalChat extends StatefulWidget {
  @override
  State<PersonalChat> createState() => _PersonalChatState();
}

class _PersonalChatState extends State<PersonalChat> {
  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: ColorStyles.whiteFFFFFF,
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
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 9,
              controller: scrollController,
              physics: const ClampingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.w),
              itemBuilder: ((context, index) {
                if (index % 2 == 0) {
                  return Padding(
                    padding: EdgeInsets.only(top: 15.h),
                    child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 40.h,
                              width: 40.h,
                              decoration: BoxDecoration(
                                color: ColorStyles.greyE0E6EE,
                                borderRadius: BorderRadius.circular(50.r),
                              ),
                            ),
                            SizedBox(width: 8.h),
                            Column(
                              children: [
                                CupertinoCard(
                                  radius: BorderRadius.circular(25.r),
                                  color: ColorStyles.greyF9F9F9,
                                  margin: EdgeInsets.zero,
                                  elevation: 0,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.w),
                                    child: Text('привет $index'),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  '${++index} минут назад',
                                  style: CustomTextStyle.grey_10_w400DADADA,
                                ),
                              ],
                            )
                          ],
                        )),
                  );
                }
                return Padding(
                  padding: EdgeInsets.only(top: 15.h),
                  child: Align(
                      alignment: Alignment.bottomRight,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CupertinoCard(
                            radius: BorderRadius.circular(25.r),
                            color: ColorStyles.greyF9F9F9,
                            margin: EdgeInsets.zero,
                            elevation: 0,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.w, vertical: 16.w),
                              child: Text('салам $index'),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            '${++index} минут назад',
                            style: CustomTextStyle.grey_10_w400DADADA,
                          ),
                        ],
                      )),
                );
              }),
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          Container(
            height: 109.h,
            width: MediaQuery.of(context).size.width,
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
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    width: 327.w,
                    height: 56.h,
                    child: Stack(
                      children: [
                        CustomTextField(
                          width: 327.w,
                          height: 56.h,
                          hintText: 'Введите сообщение',
                          textEditingController: TextEditingController(),
                          fillColor: ColorStyles.greyF9F9F9,
                          onTap: () {
                            Future.delayed(const Duration(milliseconds: 400),
                                () {
                              scrollController.animateTo(
                                scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 100),
                                curve: Curves.linear,
                              );
                            });
                          },
                          contentPadding: EdgeInsets.only(
                              left: 16.w, top: 20.h, bottom: 20.h, right: 90.h),
                        ),
                        SizedBox(
                          width: 327.w,
                          height: 56.h,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/add.svg',
                                  color: ColorStyles.greyBDBDBD,
                                ),
                                SizedBox(width: 18.w),
                                SvgPicture.asset(
                                  'assets/icons/send-2.svg',
                                  color: ColorStyles.black515150,
                                ),
                                SizedBox(width: 16.w),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
    );
  }
}
