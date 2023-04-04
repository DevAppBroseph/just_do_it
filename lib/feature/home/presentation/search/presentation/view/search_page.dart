import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/task.dart';
import 'package:scale_button/scale_button.dart';

class SearchPage extends StatelessWidget {
  final Function() onBackPressed;

  SearchPage({required this.onBackPressed});
  List<Task> taskList = [
    Task(
      icon: 'assets/images/pen.png',
      task: 'Сделать инфографику',
      typeLocation: 'Можно выполнить удаленно',
      whenStart: 'Начать сегодня',
      coast: '1 000',
    ),
    Task(
      icon: 'assets/images/laptop.png',
      task: 'На сайте у товаров поменять цены по прайсу',
      typeLocation: 'Можно выполнить удаленно',
      whenStart: 'Начать завтра, с 15:00',
      coast: '1 500',
    ),
    Task(
      icon: 'assets/images/bag.png',
      task: 'Оформить доверенность',
      typeLocation: 'Москва',
      whenStart: 'Начать 22.12.2023, с 15:00',
      coast: '2 000',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(
              height: 130.h,
              decoration: BoxDecoration(
                color: ColorStyles.whiteFFFFFF,
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.shadowFC6554,
                    offset: const Offset(0, -4),
                    blurRadius: 55.r,
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 60.h,
                    color: ColorStyles.whiteFFFFFF,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 28.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: onBackPressed,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Transform.rotate(
                              angle: pi,
                              child: SvgPicture.asset(
                                'assets/icons/arrow_right.svg',
                                height: 20.h,
                                width: 20.w,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 15.w),
                        SizedBox(
                          width: 240.w,
                          height: 36.h,
                          child: CustomTextField(
                            fillColor: ColorStyles.greyF7F7F8,
                            prefixIcon: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/search1.svg',
                                  height: 12.h,
                                ),
                              ],
                            ),
                            hintText: 'Поиск',
                            textEditingController: TextEditingController(),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 11.w, vertical: 11.h),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(width: 23.w),
                        GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoute.menu);
                            },
                            child:
                                SvgPicture.asset('assets/icons/category.svg')),
                      ],
                    ),
                  ),
                  Container(height: 30.h),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Text(
                    'Все задачи',
                    style: CustomTextStyle.black_17_w800,
                  ),
                  const Spacer(),
                  ScaleButton(
                    bound: 0.01,
                    onTap: () => BlocProvider.of<SearchBloc>(context)
                        .add(OpenSlidingPanelEvent()),
                    child: SizedBox(
                      height: 40.h,
                      width: 90.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 36.h,
                            width: 90.h,
                            decoration: BoxDecoration(
                              color: ColorStyles.greyF7F7F8,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.h),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/candle.svg',
                                    height: 16.h,
                                    color: ColorStyles.yellowFFD70B,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Фильтр',
                                    style: CustomTextStyle.black_13_w400_171716,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 15.h,
                              width: 15.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(369.r),
                                color: ColorStyles.black171716,
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: CustomTextStyle.white_9_w700,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                padding: EdgeInsets.zero,
                children: taskList.map((e) => itemTask(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemTask(Task task) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
      child: ScaleButton(
        bound: 0.01,
        child: Container(
          decoration: BoxDecoration(
            color: ColorStyles.whiteFFFFFF,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.shadowFC6554,
                offset: const Offset(0, -4),
                blurRadius: 55.r,
              )
            ],
          ),
          width: 327.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 50.h,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            task.icon,
                            height: 34.h,
                            width: 34.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              task.task,
                              style: CustomTextStyle.black_13_w500_171716,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.typeLocation,
                      style: CustomTextStyle.black_11_w500_515150,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.whenStart,
                      style: CustomTextStyle.grey_11_w400,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'до ${task.coast} ₽',
                      style: CustomTextStyle.black_13_w500_171716,
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/card.svg',
                      height: 16.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
