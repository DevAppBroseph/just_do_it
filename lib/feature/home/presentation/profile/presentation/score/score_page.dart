import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/bloc_score/score_bloc.dart';
import 'package:just_do_it/models/levels.dart';
import 'package:just_do_it/models/user_reg.dart';
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

  String? proverka;
  String? proverkaNext;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;
    return BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
      if (state is ScoreLoaded) {
        final levels = state.levels;
        for (var element in levels!) {
          if (user!.balance! >= element.mustCoins!) {
            proverka = element.name;
            log(proverka.toString());
          }
        }
        for (int i = 0; i < levels.length; i++) {
          if (user!.balance! >= levels[i].mustCoins! && levels[i + 1].name != null) {
            proverkaNext = levels[i + 1].name;
            log(proverkaNext.toString());
          }
        }
        return user?.balance != null
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
                        height: 300.h,
                        color: ColorStyles.purpleA401C4,
                        child: Stack(
                          children: [
                            Stack(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 34.w, right: 28.w),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Image.asset(
                                      'assets/images/skill_passive_rotate_white.png',
                                    ),
                                  ),
                                ),
                                Column(
                                  children: [
                                    SizedBox(height: 60.h),
                                    Padding(
                                      padding: EdgeInsets.only(left: 35.w, right: 28.w),
                                      child: SizedBox(
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Грейды',
                                                  style: CustomTextStyle.white_22_w700,
                                                ),
                                              ],
                                            ),
                                            CustomIconButton(
                                              onBackPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              icon: SvgImg.arrowRight,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${user!.balance!.toString()}\nГрейдов',
                                                      style: CustomTextStyle.white_26_w800,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              if (user!.balance! < levels[0].mustCoins!)
                                                CachedNetworkImage(
                                                  progressIndicatorBuilder: (context, url, progress) {
                                                    return const CupertinoActivityIndicator();
                                                  },
                                                  imageUrl: levels[0].bwImage != null ? '${levels[0].bwImage}' : '',
                                                  height: 113,
                                                  width: 113,
                                                  fit: BoxFit.fill,
                                                ),
                                              _scorePicture(levels, user!.balance!),
                                              const SizedBox(
                                                width: 25,
                                              ),
                                              if (user!.balance! >= levels[0].mustCoins! &&
                                                  user!.balance! < levels[1].mustCoins!)
                                                SizedBox(
                                                  width: 60,
                                                  child: Text(
                                                    levels[0].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[1].mustCoins! &&
                                                  user!.balance! < levels[2].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[1].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[2].mustCoins! &&
                                                  user!.balance! < levels[3].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[2].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[3].mustCoins! &&
                                                  user!.balance! < levels[4].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[3].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[4].mustCoins! &&
                                                  user!.balance! < levels[5].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[4].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[5].mustCoins! &&
                                                  user!.balance! < levels[6].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[5].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[6].mustCoins! &&
                                                  user!.balance! < levels[7].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[6].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[7].mustCoins! &&
                                                  user!.balance! < levels[8].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[7].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[8].mustCoins! &&
                                                  user!.balance! < levels[9].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[8].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[9].mustCoins! &&
                                                  user!.balance! < levels[10].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[9].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[10].mustCoins! &&
                                                  user!.balance! < levels[11].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[10].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >= levels[11].mustCoins!)
                                                SizedBox(
                                                  width: 110,
                                                  child: Text(
                                                    levels[11].name ?? '',
                                                    style: CustomTextStyle.white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 30.h),
                                    GestureDetector(
                                      onTap: () {
                                        if (page == 0) {
                                          page = 1;
                                          _pageController.nextPage(
                                              duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                        } else {
                                          page = 0;
                                          _pageController.previousPage(
                                              duration: const Duration(milliseconds: 300), curve: Curves.linear);
                                        }
                                        setState(() {});
                                      },
                                      child: Text(
                                        page == 1
                                            ? 'Сколько уровней я могу достичь?'
                                            : 'Узнайте, куда можно потратить\nбаллы и как их заработать?',
                                        style: CustomTextStyle.white_12_w400.copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationStyle: TextDecorationStyle.dashed,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          controller: _pageController,
                          scrollDirection: Axis.horizontal,
                          physics: const NeverScrollableScrollPhysics(),
                          children: <Widget>[
                            SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 60.h),
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Image.asset(
                                        'assets/images/group.png',
                                      ),
                                    ),
                                  ),
                                  Align(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 25.h),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              firstPageItemScore(
                                                  user!.balance! >= levels[0].mustCoins! ||
                                                          levels[0].name == proverkaNext
                                                      ? '${levels[0].image}'
                                                      : '${levels[0].bwImage}',
                                                  levels[0].name ?? '',
                                                  user!.balance!,
                                                  levels[0].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[1].mustCoins! ||
                                                          levels[1].name == proverkaNext
                                                      ? '${levels[1].image}'
                                                      : '${levels[1].bwImage}',
                                                  levels[1].name ?? '',
                                                  user!.balance!,
                                                  levels[1].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[2].mustCoins! ||
                                                          levels[2].name == proverkaNext
                                                      ? '${levels[2].image}'
                                                      : '${levels[2].bwImage}',
                                                  levels[2].name ?? '',
                                                  user!.balance!,
                                                  levels[2].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[3].mustCoins! ||
                                                          levels[3].name == proverkaNext
                                                      ? '${levels[3].image}'
                                                      : '${levels[3].bwImage}',
                                                  levels[3].name ?? '',
                                                  user!.balance!,
                                                  levels[3].mustCoins!),
                                            ],
                                          ),
                                          SizedBox(height: 25.h),
                                          Row(
                                            children: [
                                              firstPageItemScore(
                                                  user!.balance! >= levels[7].mustCoins! ||
                                                          levels[7].name == proverkaNext
                                                      ? '${levels[7].image}'
                                                      : '${levels[7].bwImage}',
                                                  levels[7].name ?? '',
                                                  user!.balance!,
                                                  levels[7].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[6].mustCoins! ||
                                                          levels[6].name == proverkaNext
                                                      ? '${levels[6].image}'
                                                      : '${levels[6].bwImage}',
                                                  levels[6].name ?? '',
                                                  user!.balance!,
                                                  levels[6].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[5].mustCoins! ||
                                                          levels[5].name == proverkaNext
                                                      ? '${levels[5].image}'
                                                      : '${levels[5].bwImage}',
                                                  levels[5].name ?? '',
                                                  user!.balance!,
                                                  levels[5].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[4].mustCoins! ||
                                                          levels[4].name == proverkaNext
                                                      ? '${levels[4].image}'
                                                      : '${levels[4].bwImage}',
                                                  levels[4].name ?? '',
                                                  user!.balance!,
                                                  levels[4].mustCoins!),
                                            ],
                                          ),
                                          SizedBox(height: 30.h),
                                          Row(
                                            children: [
                                              firstPageItemScore(
                                                  user!.balance! >= levels[8].mustCoins! ||
                                                          levels[8].name == proverkaNext
                                                      ? '${levels[8].image}'
                                                      : '${levels[8].bwImage}',
                                                  levels[8].name ?? '',
                                                  user!.balance!,
                                                  levels[8].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[9].mustCoins! ||
                                                          levels[9].name == proverkaNext
                                                      ? '${levels[9].image}'
                                                      : '${levels[9].bwImage}',
                                                  levels[9].name ?? '',
                                                  user!.balance!,
                                                  levels[9].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[10].mustCoins! ||
                                                          levels[10].name == proverkaNext
                                                      ? '${levels[10].image}'
                                                      : '${levels[10].bwImage}',
                                                  levels[10].name ?? '',
                                                  user!.balance!,
                                                  levels[10].mustCoins!),
                                              firstPageItemScore(
                                                  user!.balance! >= levels[11].mustCoins! ||
                                                          levels[11].name == proverkaNext
                                                      ? '${levels[11].image}'
                                                      : '${levels[11].bwImage}',
                                                  levels[11].name ?? '',
                                                  user!.balance!,
                                                  levels[11].mustCoins!),
                                            ],
                                          ),
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
                                    padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 30.h),
                                    child: Text(
                                      'Amet minim mollit non deserunt ullamco est sit aliqua dolor do amet sint. Velit officia consequat duis enim velit mollit. Exercitation veniam consequat sunt nostrud amet',
                                      style: CustomTextStyle.black_14_w400_171716,
                                    ),
                                  ),
                                  ListView.separated(
                                      physics: const ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: levels.length,
                                      separatorBuilder: (_, __) => const Divider(),
                                      padding: EdgeInsets.zero,
                                      itemBuilder: (context, index) {
                                        return itemScore(
                                          levels[index].image != null ? '${levels[index].image}' : '',
                                          levels[index].name ?? '',
                                        );
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

  Widget _scorePicture(List<Levels>? levels, int balance) {
    for (int i = 0; i < levels!.length; i++) {
      if (levels[i + 1].mustCoins == null) {
        return CachedNetworkImage(
          progressIndicatorBuilder: (context, url, progress) {
            return const CupertinoActivityIndicator();
          },
          imageUrl: levels[i].image != null ? '${levels[i].image}' : '',
          height: 113,
          width: 113,
          fit: BoxFit.fill,
        );
      } else {
        if (balance >= levels[i].mustCoins! && balance < levels[i + 1].mustCoins!) {
          return CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) {
              return const CupertinoActivityIndicator();
            },
            imageUrl: levels[i].image != null ? '${levels[i].image}' : '',
            height: 113,
            width: 113,
            fit: BoxFit.fill,
          );
        } else if (balance >= levels.last.mustCoins!) {
          return CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) {
              return const CupertinoActivityIndicator();
            },
            imageUrl: '${levels.last.image}',
            height: 42,
            width: 42,
          );
        }
      }
    }
    return const CupertinoActivityIndicator();
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

  Widget firstPageItemScore(String icon, String title, int score, int mustCoins) {
    double value = 0;
    if (score >= mustCoins || title == proverkaNext) {
      value = score / mustCoins;
      if (value >= 1 && value < 0) {
        value = 1;
      }
    }
    return SizedBox(
      width: 91.5,
      child: Column(
        children: [
          if (title.length > 12)
            const SizedBox(
              height: 15,
            ),
          SizedBox(
            height: 70,
            child: Stack(alignment: Alignment.center, children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 57,
                  width: 57,
                  decoration: BoxDecoration(
                    color: colorBoxDecoration(score, mustCoins, title),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 55,
                  width: 55,
                  child: Image.network(
                    icon,
                  ),
                ),
              ),
            ]),
          ),
          SizedBox(width: 60.w, height: 5.h),
          SizedBox(
            height: 5,
            width: 53,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: ColorStyles.greyBDBDBD,
                valueColor: const AlwaysStoppedAnimation<Color>(ColorStyles.purpleA401C4),
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Center(
            child: SizedBox(
              width: 84.w,
              child: Text(
                textAlign: TextAlign.center,
                title,
                style: score >= mustCoins || title == proverkaNext
                    ? CustomTextStyle.purple_12_w600
                    : CustomTextStyle.grey_12_w400,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          SizedBox(
            width: 40.w,
            child: Text(
              mustCoins.toString(),
              textAlign: TextAlign.center,
              style: CustomTextStyle.black_12_w400_515150,
            ),
          ),
        ],
      ),
    );
  }

  Color? colorBoxDecoration(int score, int mustCoin, String title) {
    if (score >= mustCoin && proverka == title) {
      return ColorStyles.purpleA401C4;
    } else {
      return ColorStyles.greyBDBDBD;
    }
  }

  Widget itemScore(String icon, String title) {
    return Container(
      height: 80.h,
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
          CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) {
              return const CupertinoActivityIndicator();
            },
            imageUrl: icon,
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
