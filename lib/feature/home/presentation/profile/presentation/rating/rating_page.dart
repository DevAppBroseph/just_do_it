import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/comment.dart';

class RatingPage extends StatefulWidget {
  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int type = 1;
  bool state = false;
  PageController pageController = PageController();
  int stageRegistragion = 1;

  List<Comment> listComment = [
    Comment(
      name: 'Guy Hawkins',
      date: '18.20.2022',
      score: '10',
      text:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet.',
    ),
    Comment(
      name: 'Kristin Watson',
      date: '18.20.2022',
      score: '9',
      text:
          'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. ',
    ),
    Comment(
      name: 'Darlene Robertson',
      date: '18.20.2022',
      score: '10',
      text: 'Amet minim mollit non deserunt ullamco',
    ),
  ];

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
                        style: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w800),
                      ),
                      SizedBox(height: 30.h),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: listComment.length,
                        itemBuilder: ((context, index) {
                          return itemComment(listComment[index]);
                        }),
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemComment(Comment comment) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      width: 327.w,
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorStyles.whiteFFFFFF,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 34.h,
            width: 34.h,
            decoration: BoxDecoration(
              color: ColorStyles.shadowFC6554,
              borderRadius: BorderRadius.circular(50.r),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 245.w,
                child: Row(
                  children: [
                    Text(
                      comment.name,
                      style: CustomTextStyle.black_13_w500_171716,
                    ),
                    const Spacer(),
                    Text(
                      comment.date,
                      style: CustomTextStyle.grey_11_w400,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset('assets/icons/star.svg'),
                  SizedBox(width: 4.w),
                  Text(
                    '${comment.score}/10',
                    style: CustomTextStyle.black_13_w400_171716,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: 245.w,
                child: Text(
                  comment.text,
                  style: CustomTextStyle.black_11_w400_515150,
                  maxLines: null,
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                // todo do not make the width fixed cause it varies from one phone to another
                width: 245.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      height: 36.h,
                      decoration: BoxDecoration(
                        color: ColorStyles.whiteF5F5F5,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(10.h),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/translate.svg'),
                            SizedBox(width: 8.h),
                            Text(
                              'Перевод',
                              style: CustomTextStyle.blue_13_w400_336FEE,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ],
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
                    style: CustomTextStyle.black_21_w700,
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
                // style: CustomTextStyle.black_32_w800_171716,
                style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.w800),
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
                      style: CustomTextStyle.black_13_w400_515150,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        SvgPicture.asset('assets/icons/star.svg'),
                        SizedBox(width: 4.w),
                        Text(
                          '7.5',
                          style: CustomTextStyle.black_19_w600,
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
                style: CustomTextStyle.black_13_w400_515150,
              ),
            ],
          )
        ],
      ),
    );
  }
}
