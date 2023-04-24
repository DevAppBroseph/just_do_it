import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/bloc_score/score_bloc.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class ScorePage extends StatefulWidget {
  const ScorePage({super.key});

  @override
  State<ScorePage> createState() => _ScorePageState();
}

class _ScorePageState extends State<ScorePage> {
  late UserRegModel? user;
  final PageController _pageController = PageController(initialPage: 0);
  int page = 0;

  @override
  void initState() {
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    user = BlocProvider.of<ProfileBloc>(context).user;
    context.read<ScoreBloc>().add(GetScoreEvent(access));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;
    return BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
      if (state is ScoreLoaded) {
        final levels = state.levels;

        return user?.balance != null && levels != null
            ? MediaQuery(
                data: const MediaQueryData(textScaleFactor: 1.0),
                child: Scaffold(
                  backgroundColor: ColorStyles.whiteFFFFFF,
                  resizeToAvoidBottomInset: false,
                  body: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 284.h,
                        color: ColorStyles.purpleA401C4,
                        child: Stack(
                          children: [
                            Column(
                              children: [
                                SizedBox(height: 60.h),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 25.w, right: 28.w),
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Баллы',
                                              style:
                                                  CustomTextStyle.white_22_w700,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 30.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.w),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Column(
                                        children: [
                                          if (user!.balance! <
                                              levels[0].mustCoins!)
                                            Image.network(
                                              levels[0].bwImage != null
                                                  ? '${levels[0].bwImage}'
                                                  : '',
                                              height: 113,
                                              width: 113,
                                              fit: BoxFit.fill,
                                            ),
                                          if (user!.balance! >=
                                                  levels[0].mustCoins! &&
                                              user!.balance! <
                                                  levels[1].mustCoins!)
                                            Image.network(
                                              levels[0].image != null
                                                  ? '${levels[0].image}'
                                                  : '',
                                              height: 113,
                                              width: 113,
                                              fit: BoxFit.fill,
                                            ),
                                          if (user!.balance! >=
                                                  levels[1].mustCoins! &&
                                              user!.balance! <
                                                  levels[2].mustCoins!)
                                            Image.network(
                                              levels[1].image != null
                                                  ? '${levels[1].image}'
                                                  : '',
                                              height: 113,
                                              width: 113,
                                              fit: BoxFit.fill,
                                            ),
                                          if (user!.balance! >=
                                                  levels[2].mustCoins! &&
                                              user!.balance! <
                                                  levels[3].mustCoins!)
                                            Image.network(
                                              levels[2].image != null
                                                  ? '${levels[2].image}'
                                                  : '',
                                              height: 113,
                                              width: 113,
                                              fit: BoxFit.fill,
                                            ),
                                          if (user!.balance! >=
                                                  levels[3].mustCoins! &&
                                              user!.balance! <
                                                  levels[4].mustCoins!)
                                            Image.network(
                                              levels[3].image != null
                                                  ? '${levels[3].image}'
                                                  : '',
                                              height: 113,
                                              width: 113,
                                              fit: BoxFit.fill,
                                            ),
                                          if (user!.balance! >=
                                              levels[4].mustCoins!)
                                            Image.network(
                                              levels[4].image != null
                                                  ? '${levels[4].image}'
                                                  : '',
                                              height: 113,
                                              width: 113,
                                              fit: BoxFit.fill,
                                            ),
                                          SizedBox(height: 12.h),
                                          if (user!.balance! >=
                                                  levels[0].mustCoins! &&
                                              user!.balance! <
                                                  levels[1].mustCoins!)
                                            Text(
                                              levels[0].name?.toUpperCase() ??
                                                  '',
                                              style:
                                                  CustomTextStyle.white_12_w900,
                                            ),
                                          if (user!.balance! >=
                                                  levels[1].mustCoins! &&
                                              user!.balance! <
                                                  levels[2].mustCoins!)
                                            Text(
                                              levels[1].name?.toUpperCase() ??
                                                  '',
                                              style:
                                                  CustomTextStyle.white_12_w900,
                                            ),
                                          if (user!.balance! >=
                                                  levels[2].mustCoins! &&
                                              user!.balance! <
                                                  levels[3].mustCoins!)
                                            Text(
                                              levels[2].name?.toUpperCase() ??
                                                  '',
                                              style:
                                                  CustomTextStyle.white_12_w900,
                                            ),
                                          if (user!.balance! >=
                                                  levels[3].mustCoins! &&
                                              user!.balance! <
                                                  levels[4].mustCoins!)
                                            Text(
                                              levels[3].name?.toUpperCase() ??
                                                  '',
                                              style:
                                                  CustomTextStyle.white_12_w900,
                                            ),
                                          if (user!.balance! >=
                                              levels[4].mustCoins!)
                                            Text(
                                              levels[4].name?.toUpperCase() ??
                                                  '',
                                              style:
                                                  CustomTextStyle.white_12_w900,
                                            )
                                        ],
                                      ),
                                      SizedBox(width: 23.h),
                                      SizedBox(
                                        height: 160.h,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              user!.balance!.toString(),
                                              style:
                                                  CustomTextStyle.white_34_w800,
                                            ),
                                            // Text(
                                            //   'Баллов',
                                            //   style: CustomTextStyle.white_32_w800,
                                            // ),
                                            GestureDetector(
                                              onTap: () {
                                                if (page == 0) {
                                                  page = 1;
                                                  _pageController.nextPage(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.linear);
                                                } else {
                                                  page = 0;
                                                  _pageController.previousPage(
                                                      duration: const Duration(
                                                          milliseconds: 300),
                                                      curve: Curves.linear);
                                                }
                                                setState(() {});
                                              },
                                              child: Text(
                                                page == 1
                                                    ? 'Сколько уровней я могу\nдостичь?'
                                                    : 'Узнайте, куда можно потратить\nбаллы и как их заработать?',
                                                style: CustomTextStyle
                                                    .white_14_w400
                                                    .copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .underline),
                                              ),
                                            ),
                                            SizedBox(height: 12.h),
                                            GestureDetector(
                                              onTap: () {
                                                page = 1;
                                                // _pageController.nextPage(
                                                //     duration: const Duration(
                                                //         microseconds: 100),
                                                //     curve: Curves.bounceIn);
                                                // setState(() {});
                                              },
                                              child: Container(
                                                height: 29.h,
                                                // width: 160.w,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 12.w,
                                                  vertical: 8.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                  color:
                                                      ColorStyles.whiteFFFFFF,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Поделиться статусом',
                                                      style: CustomTextStyle
                                                          .black_11_w500_171716,
                                                    ),
                                                    const SizedBox(
                                                      width: 9,
                                                    ),
                                                    SvgPicture.asset(
                                                      'assets/icons/share.svg',
                                                      color: ColorStyles.black,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          // pageSnapping: false,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 60.h),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Image.asset(
                                        'assets/images/group.png',
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10.w, vertical: 20.h),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              firstPageItemScore(
                                                  user!.balance! >=
                                                          levels[0].mustCoins!
                                                      ? '${levels[0].image}'
                                                      : '${levels[0].bwImage}',
                                                  levels[0].name ?? '',
                                                  user!.balance!,
                                                  levels[1].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >=
                                                          levels[1].mustCoins!
                                                      ? '${levels[1].image}'
                                                      : '${levels[1].bwImage}',
                                                  levels[1].name ?? '',
                                                  user!.balance!,
                                                  levels[1].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >=
                                                          levels[2].mustCoins!
                                                      ? '$server${levels[2].image}'
                                                      : '${levels[2].bwImage}',
                                                  levels[2].name ?? '',
                                                  user!.balance!,
                                                  levels[2].mustCoins!),
                                            ],
                                          ),
                                          SizedBox(height: 50.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              firstPageItemScore(
                                                  user!.balance! >=
                                                          levels[5].mustCoins!
                                                      ? '${levels[5].image}'
                                                      : '${levels[5].bwImage}',
                                                  levels[5].name ?? '',
                                                  user!.balance!,
                                                  levels[5].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >=
                                                          levels[4].mustCoins!
                                                      ? '${levels[4].image}'
                                                      : '${levels[4].bwImage}',
                                                  levels[4].name ?? '',
                                                  user!.balance!,
                                                  levels[4].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >=
                                                          levels[3].mustCoins!
                                                      ? '${levels[3].image}'
                                                      : '${levels[3].bwImage}',
                                                  levels[3].name ?? '',
                                                  user!.balance!,
                                                  levels[3].mustCoins!),
                                            ],
                                          ),
                                          SizedBox(height: 55.h),
                                          Center(
                                            child: firstPageItemScore(
                                                user!.balance! >=
                                                        levels[5].mustCoins!
                                                    ? '${levels[6].image}'
                                                    : '${levels[6].bwImage}',
                                                levels[6].name ?? '',
                                                user!.balance!,
                                                levels[6].mustCoins!),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 24.w, vertical: 30.h),
                                    child: Text(
                                      'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet',
                                      style:
                                          CustomTextStyle.black_14_w400_171716,
                                    ),
                                  ),
                                  ListView.separated(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: levels.length,
                                      separatorBuilder: (_, __) =>
                                          const Divider(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return itemScore(
                                          levels[index].image != null
                                              ? '${levels[index].image}'
                                              : '',
                                          levels[index].name ?? '',
                                        );

                                        // itemScore('assets/images/rassomaha.png', 'Росомаха'),
                                        // SizedBox(height: 18.h),
                                        // itemScore('assets/images/hulk.png', 'Халк'),
                                        // SizedBox(height: 18.h),
                                        // itemScore('assets/images/batman.png', 'Бэтмен'),
                                        // SizedBox(height: 18.h),
                                        // itemScore('assets/images/america.png', 'Супермен'),
                                        // SizedBox(height: 40.h)
                                      }),
                                  SizedBox(height: 18.h),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : _loadingindicator();
      }
      return _loadingindicator();
    });
  }

  Widget _loadingindicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(8),
      child: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget firstPageItemScore(
      String icon, String title, int score, int mustCoins) {
    double value = score / mustCoins;
    if (value >= 1 && value < 0) {
      value = 1;
    }
    return Column(
      children: [
        Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          margin: EdgeInsets.symmetric(horizontal: 19.w),
          child: Stack(alignment: Alignment.center, children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                width: 60,
                decoration: BoxDecoration(
                  color: ColorStyles.greyBDBDBD,
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: 60,
                width: 60,
                child: Image.network(
                  icon,
                ),
              ),
            ),
          ]),
        ),
        SizedBox(width: 80.w, height: 10.h),
        SizedBox(
          height: 5,
          width: 60,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: value,
              backgroundColor: ColorStyles.greyBDBDBD,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(ColorStyles.purpleA401C4),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          title,
          style: CustomTextStyle.purple_14_w600,
        ),
        SizedBox(height: 4.h),
        SizedBox(
          width: 25.w,
          child: Text(
            score.toString(),
            style: CustomTextStyle.black_12_w400_515150,
          ),
        ),
      ],
    );
  }

  Widget itemScore(String icon, String title) {
    return Container(
      height: 69.h,
      width: 372.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: ColorStyles.whiteFFFFFF,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(
            color: ColorStyles.shadowFC6554,
            blurRadius: 45,
            offset: Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Image.network(
            icon,
            height: 50.h,
            width: 50.h,
          ),
          SizedBox(width: 14.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: CustomTextStyle.purple_14_w600,
              ),
              SizedBox(height: 3.h),
              SizedBox(
                width: 230.w,
                child: Text(
                  'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint.',
                  style: CustomTextStyle.black_12_w400_515150,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
