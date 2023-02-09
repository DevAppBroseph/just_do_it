import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/helpers/router.dart';

class PersonalAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Transform.rotate(
                        angle: pi,
                        child: SvgPicture.asset(
                          'assets/icons/arrow_right.svg',
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Личный кабинет',
                      style: CustomTextStyle.black_20_w700,
                    ),
                    const Spacer(),
                    Stack(
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
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: ListView(
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
                              style: CustomTextStyle.black_16_w500_171716,
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
                    Container(
                      color: Colors.transparent,
                      height: 50.h,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/icons/coin_account.svg',
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            'Баллы',
                            style: CustomTextStyle.black_16_w500_171716,
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
                              style: CustomTextStyle.black_16_w500_171716,
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
                        BlocProvider.of<ProfileBloc>(context).setAccess(null);
                        BlocProvider.of<ProfileBloc>(context).setUser(null);
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            AppRoute.home, (route) => false);
                      },
                      child: Container(
                        color: Colors.transparent,
                        height: 50.h,
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/logout_account.svg',
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              'Выйти из аккаунта',
                              style: CustomTextStyle.black_16_w500_171716,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                'Удалить аккаунт',
                style: CustomTextStyle.black_14_w500_171716,
              ),
              SizedBox(height: 72.h),
            ],
          ),
        ),
      ),
    );
  }
}
