import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';

class RatingPage extends StatefulWidget {
  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int type = 1;
  bool state = false;
  PageController pageController = PageController();
  int stageRegistragion = 1;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        body: SafeArea(
          child: Column(
            children: [
              header(),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: ColorStyles.greyF7F7F8,
                  ),
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    shrinkWrap: true,
                    children: [
                      SizedBox(height: 30.h),
                      Text(
                        'Отзывы о вашей работе',
                        style: CustomTextStyle.black_16_w800,
                      ),
                      SizedBox(height: 30.h),
                      Container(
                        padding: EdgeInsets.only(
                            left: 16.w, right: 16.w, top: 16.h, bottom: 12.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          color: ColorStyles.whiteFFFFFF,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  height: 34.h,
                                  width: 34.h,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(50.r),
                                  ),
                                ),
                                Column(
                                  children: [
                                    Text('data'),
                                    Text('data'),
                                  ],
                                )
                              ],
                            ),
                            Row(
                              children: [],
                            ),
                            Row(
                              children: [],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
              // SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget header() {
    final bloc = BlocProvider.of<ProfileBloc>(context);
    return SizedBox(
      height: 274.h,
      child: Column(
        children: [
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Рейтинг',
                    style: CustomTextStyle.black_20_w700,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Transform.rotate(
                      angle: pi,
                      child: SvgPicture.asset(
                        'assets/icons/arrow_right.svg',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 40.h),
          Row(
            children: [
              SizedBox(width: 24.w),
              Text(
                '${bloc.user?.firstname}\n${bloc.user?.lastname}',
                style: CustomTextStyle.black_32_w800_171716,
                overflow: TextOverflow.ellipsis,
                maxLines: null,
              ),
              const Spacer(),
              Container(
                height: 76.h,
                width: 130.h,
                padding: EdgeInsets.only(
                    left: 16.w, right: 16.w, top: 4.h, bottom: 4.h),
                decoration: BoxDecoration(
                  color: ColorStyles.greyF3F3F3,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.r),
                    bottomLeft: Radius.circular(10.r),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ваш рейтинг',
                      style: CustomTextStyle.black_12_w400_515150,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/star.svg'),
                        SizedBox(width: 4.w),
                        Text(
                          '7.5',
                          style: CustomTextStyle.black_18_w600,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          Row(
            children: [
              SizedBox(width: 24.w),
              Text(
                'Вы выполнили 23 задания',
                style: CustomTextStyle.black_12_w400_515150,
              ),
            ],
          )
        ],
      ),
    );
  }
}
