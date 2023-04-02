import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/models/review.dart';

class RatingPage extends StatefulWidget {
  const RatingPage({super.key});

  @override
  State<RatingPage> createState() => _RatingPageState();
}

class _RatingPageState extends State<RatingPage> {
  int type = 1;
  bool state = false;
  PageController pageController = PageController();
  int stageRegistration = 1;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        body:
            BlocBuilder<RatingBloc, RatingState>(builder: (context, snapshot) {
          if (snapshot is LoadingRatingState) {
            return const CupertinoActivityIndicator();
          }
          Reviews reviews = BlocProvider.of<RatingBloc>(context).reviews;
          return SafeArea(
            child: Column(
              children: [
                header(reviews),
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
                          itemCount: reviews.reviewsDetail.length,
                          itemBuilder: ((context, index) {
                            return itemComment(reviews.reviewsDetail[index]);
                          }),
                        ),
                        SizedBox(height: 50.h),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget itemComment(ReviewsDetail review) {
    double width = MediaQuery.of(context).size.width - (24 * 2);
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      width: width.w,
      padding:
          EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h, bottom: 12.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorStyles.whiteFFFFFF,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
            child: SizedBox.fromSize(
                size: Size.fromRadius(25.r),
                child: review.reviewerDetails.photo == null
                    ? Container(
                        height: 34.h,
                        width: 34.h,
                        decoration: const BoxDecoration(
                            color: ColorStyles.shadowFC6554),
                      )
                    : CachedNetworkImage(
                        height: 34.h,
                        width: 34.h,
                        imageUrl: review.reviewerDetails.photo!,
                        fit: BoxFit.cover,
                      )
                // : Image.network(
                //     BlocProvider.of<ProfileBloc>(context)
                //         .user!
                //         .photoLink!,
                //     fit: BoxFit.cover,
                //   ),
                ),
          ),
          // Container(
          //   decoration: BoxDecoration(
          //     color: ColorStyles.shadowFC6554,
          //     borderRadius: BorderRadius.circular(50.r),
          //   ),
          // ),
          SizedBox(width: 16.w),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: width - (66 + 50),
                child: Row(
                  children: [
                    Text(
                      '${review.reviewerDetails.firstname} ${review.reviewerDetails.lastname}',
                      style: CustomTextStyle.black_13_w500_171716,
                    ),
                    const Spacer(),
                    Text(
                      '01.04.2023',
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
                    '${review.mark}/10',
                    style: CustomTextStyle.black_13_w400_171716,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: width - (66 + 50),
                child: Text(
                  review.message,
                  style: CustomTextStyle.black_11_w400_515150,
                  maxLines: null,
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(
                width: width - (66 + 50),
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

  Widget header(Reviews reviews) {
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
                          reviews.ranking == null
                              ? '-'
                              : (reviews.ranking!).toString(),
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
                'Вы выполнили ${reviews.reviewsDetail.length} задания',
                style: CustomTextStyle.black_13_w400_515150,
              ),
            ],
          )
        ],
      ),
    );
  }
}
