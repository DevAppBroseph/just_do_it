import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class PersonalAccountPage extends StatefulWidget {
  const PersonalAccountPage({super.key});

  @override
  State<PersonalAccountPage> createState() => _PersonalAccountPageState();
}

class _PersonalAccountPageState extends State<PersonalAccountPage> {
  Timer? timer;

  @override
  void initState() {
    super.initState();
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    BlocProvider.of<RatingBloc>(context).add(GetRatingEvent(access));
    timer = Timer.periodic(
        const Duration(seconds: 30), (Timer t) => BlocProvider.of<RatingBloc>(context).add(UpdateRatingEvent(access)));
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        body: BlocBuilder<RatingBloc, RatingState>(builder: (context, snapshot) {
          return SafeArea(
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      CustomIconButton(
                        onBackPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: SvgImg.arrowRight,
                      ),
                      const Spacer(),
                      Text(
                        'Личный кабинет',
                        style: CustomTextStyle.black_22_w700,
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoute.notification);
                        },
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/notification_account.svg',
                            ),
                            Container(
                              height: 10.w,
                              width: 10.w,
                              decoration: BoxDecoration(
                                color: ColorStyles.yellowFFD70B,
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: ListView(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      GestureDetector(
                        onTap: () {
                          
                          Navigator.of(context).pushNamed(AppRoute.profile);
                          
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 50.h,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/profile_account.svg',
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Профиль',
                                style: CustomTextStyle.black_18_w500_171716,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorStyles.greyBDBDBD,
                                size: 16.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoute.score);
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 50.h,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/coin_account.svg',
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Грейды',
                                style: CustomTextStyle.black_18_w500_171716,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorStyles.greyBDBDBD,
                                size: 16.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoute.rating);
                        },
                        child: Container(
                          color: Colors.transparent,
                          height: 50.h,
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/icons/like_account.svg',
                              ),
                              SizedBox(width: 12.w),
                              Text(
                                'Рейтинг и отзывы',
                                style: CustomTextStyle.black_18_w500_171716,
                              ),
                              const Spacer(),
                              Icon(
                                Icons.arrow_forward_ios,
                                color: ColorStyles.greyBDBDBD,
                                size: 16.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(height: 72.h),
              ],
            ),
          );
        }),
      ),
    );
  }
}
