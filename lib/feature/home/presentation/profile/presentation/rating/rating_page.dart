import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

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
    return Scaffold(
      backgroundColor: AppColors.greyAccent,
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          final user = context.read<ProfileBloc>().user;
          if (user == null) {
            return const Center(child: CupertinoActivityIndicator());
          }
          return BlocBuilder<RatingBloc, RatingState>(
              builder: (context, snapshot) {
            if (snapshot is LoadingRatingState) {
              return const CupertinoActivityIndicator();
            }
            Reviews? reviews = BlocProvider.of<RatingBloc>(context).reviews;
            return SafeArea(
              top: false,
              bottom: false,
              child: MediaQuery(
                data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
                child: Column(
                  children: [
                    header(reviews, user),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.greyAccent,
                        ),
                        child: ListView(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          shrinkWrap: true,
                          children: [
                            SizedBox(height: 30.h),
                            Text(
                              'reviews_of_your_work'.tr(),
                              style: CustomTextStyle.sf18w800(
                                  AppColors.blackSecondary),
                            ),
                            SizedBox(height: 30.h),
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: reviews?.reviewsDetail.length,
                              itemBuilder: ((context, index) {
                                if (reviews != null) {
                                  return itemComment(
                                      reviews.reviewsDetail[index]);
                                }
                                return null;
                              }),

                              // ListView.builder(
                              //   physics: const NeverScrollableScrollPhysics(),
                              //   shrinkWrap: true,
                              //   itemCount: _reviews.length,
                              //   itemBuilder: ((context, index) {
                              //     return itemCommentNew(_reviews[index]);
                              //   }),
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget itemCommentNew(ReviewsDetail review) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.whitePrimary,
      ),
      padding: EdgeInsets.all(16.w),
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
                      decoration:
                          const BoxDecoration(color: AppColors.shadowPrimary),
                    )
                  : CachedNetworkImage(
                      height: 34.h,
                      width: 34.h,
                      imageUrl: review.reviewerDetails.photo!,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 225.w,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${review.reviewerDetails.firstname} ${review.reviewerDetails.lastname}',
                      style: CustomTextStyle.sf17w400(
                        Colors.black,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '01.04.2023',
                      style: CustomTextStyle.sf13w400(AppColors.greySecondary),
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
                    '${review.mark}/5',
                    style: CustomTextStyle.sf17w400(AppColors.blackSecondary),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                child: Text(
                  review.message,
                  style: CustomTextStyle.sf13w400(AppColors.blackAccent),
                  maxLines: null,
                ),
              ),
              SizedBox(height: 18.h),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 229.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 36.h,
                        decoration: BoxDecoration(
                          color: AppColors.whiteSecondary,
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
                                style: CustomTextStyle.sf17w400(
                                    AppColors.blueSecondary),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
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
        color: AppColors.whitePrimary,
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
                        decoration:
                            const BoxDecoration(color: AppColors.shadowPrimary),
                      )
                    : CachedNetworkImage(
                        height: 34.h,
                        width: 34.h,
                        imageUrl: review.reviewerDetails.photo!,
                        fit: BoxFit.cover,
                      )),
          ),
          SizedBox(width: 16.w),
          Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 150.w,
                        child: Text(
                          '${review.reviewerDetails.firstname} ${review.reviewerDetails.lastname}',
                          style: CustomTextStyle.sf17w400(
                            AppColors.blackSecondary,
                          ).copyWith(fontWeight: FontWeight.w500),
                        ),
                      ),
                      Text(
                        _textData(review.date),
                        style:
                            CustomTextStyle.sf13w400(AppColors.greySecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SvgPicture.asset('assets/icons/star.svg'),
                      SizedBox(width: 4.w),
                      Text(
                        '${review.mark}/5',
                        style:
                            CustomTextStyle.sf17w400(AppColors.blackSecondary),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    width: width - (66 + 50),
                    child: Text(
                      review.message,
                      style: CustomTextStyle.sf13w400(AppColors.blackAccent),
                      maxLines: null,
                    ),
                  ),
                  SizedBox(height: 18.h),
                  SizedBox(
                    width: width - (66 + 55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: 38.h,
                          decoration: BoxDecoration(
                            color: AppColors.whiteSecondary,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.h),
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/icons/translate.svg'),
                                SizedBox(
                                  width: 9.w,
                                ),
                                SizedBox(
                                  height: 25.h,
                                  child: Text(
                                    'Перевод',
                                    style: CustomTextStyle.sf17w400(
                                        AppColors.blueSecondary),
                                  ),
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
        ],
      ),
    );
  }

  Widget header(Reviews? reviews, UserRegModel? user) {
    final bloc = BlocProvider.of<ProfileBloc>(context);
    return SizedBox(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'rating'.tr(),
                    style: CustomTextStyle.sf22w700(AppColors.blackSecondary),
                  ),
                ),
                CustomIconButton(
                  onBackPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: SvgImg.arrowRight,
                  color: AppColors.greySecondary,
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          if (reviews != null) ...[
            Container(
              color: AppColors.yellowPrimary,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 127.h,
                    child: Row(
                      children: [
                        SizedBox(width: 24.w),
                        SizedBox(
                          width: 188.w,
                          child: AutoSizeText(
                            '${bloc.user?.firstname}\n${bloc.user?.lastname}',
                            style: CustomTextStyle.sf19w800(
                                    AppColors.blackSecondary)
                                .copyWith(
                              fontSize: 34,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          height: 76.h,
                          padding: EdgeInsets.only(
                              left: 16.w, right: 16.w, top: 4.h, bottom: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.greyActive,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              bottomLeft: Radius.circular(10.r),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'your_rating'.tr(),
                                style: CustomTextStyle.sf17w400(
                                    AppColors.blackAccent),
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
                                    style: CustomTextStyle.sf19w800(
                                            AppColors.whitePrimary)
                                        .copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 53.h,
                    child: Row(
                      children: [
                        SizedBox(width: 24.w),
                        Text(
                          '${'you_have_completed'.tr()} ${user?.countOrdersCompleteAsExecutor == null ? '0' : user!.countOrdersCompleteAsExecutor!.toString()} ${'taskss'.tr()}',
                          style:
                              CustomTextStyle.sf17w400(AppColors.blackAccent),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  String _textData(String data) {
    String text = '';
    String day = '';
    String month = '';
    String year = '';
    List<String> parts = [];
    parts = data.split('-');
    year = parts[0].trim();
    day = parts[2].trim();
    month = parts[1].trim();
    text = '$day.$month.$year';
    return text;
  }
}
