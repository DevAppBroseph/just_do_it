import 'dart:developer';
import 'dart:io';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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

  String? proverka = '';
  String? proverkaNext = '';

  @override
  Widget build(BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    user = BlocProvider.of<ProfileBloc>(context).user;
    return BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
      if (state is ScoreLoaded) {
        final levels = state.levels;
        for (int i = 0; i < levels!.length; i++) {
          if (user!.balance! >= levels[i].mustCoins!) {
            proverka = levels[i].name;
            log(proverka.toString());
          } else if (user!.balance! <= levels[0].mustCoins!) {
            proverka = levels[0].name;
            log(proverka.toString());
            break;
          }
        }
        for (int i = 0; i < levels.length; i++) {
          if (user!.balance! >= levels.last.mustCoins!) {
            proverkaNext = levels.last.name;
            log(proverka.toString());
            break;
          } else if (1300 <= levels[0].mustCoins!) {
            proverkaNext = levels[0].name;
            log(proverka.toString());
            break;
          } else if (user!.balance! >= levels.last.mustCoins!) {
            proverkaNext = levels.last.name;
            log(proverka.toString());
            break;
          } else if (user!.balance! >= levels[i].mustCoins! &&
              levels[i + 1].name != null) {
            proverkaNext = levels[i + 1].name;
            log(proverkaNext.toString());
          }
        }
        return user?.balance != null
            ? MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                                  padding:
                                      EdgeInsets.only(left: 0.w, right: 12.w),
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
                                      padding: EdgeInsets.only(
                                          left: 0.w, right: 12.w),
                                      child: SizedBox(
                                        child: Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'grades'.tr(),
                                                  style: CustomTextStyle
                                                      .white_22_w700,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(left: 20.w),
                                              child: CustomIconButton(
                                                onBackPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                icon: SvgImg.arrowRight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 10.h),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 33.w),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                child: Column(
                                                  children: [
                                                    AutoSizeText(
                                                      user!.balance!.toString(),
                                                      style: CustomTextStyle
                                                          .white_26_w800,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                    AutoSizeText(
                                                      'points'.tr(),
                                                      style: CustomTextStyle
                                                          .white_26_w800,
                                                      textAlign: TextAlign.end,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              if (user!.balance! <
                                                  levels[0].mustCoins!)
                                                CachedNetworkImage(
                                                  progressIndicatorBuilder:
                                                      (context, url, progress) {
                                                    return const CupertinoActivityIndicator();
                                                  },
                                                  imageUrl: levels[0].bwImage !=
                                                          null
                                                      ? '${levels[0].bwImage}'
                                                      : '',
                                                  height: 113.h,
                                                  width: 113.w,
                                                  fit: BoxFit.fill,
                                                ),
                                              if (user!.balance! >=
                                                  levels[0].mustCoins!)
                                                _scorePicture(
                                                    levels, user!.balance!),
                                              SizedBox(
                                                width: 15.w,
                                              ),
                                              if (user!.balance! <
                                                  levels[0].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    levels[0].name ?? '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[0].mustCoins! &&
                                                  user!.balance! <
                                                      levels[1].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[0].name ?? ''
                                                        : levels[0].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[1].mustCoins! &&
                                                  user!.balance! <
                                                      levels[2].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[1].name ?? ''
                                                        : levels[1].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[2].mustCoins! &&
                                                  user!.balance! <
                                                      levels[3].mustCoins!)
                                                SizedBox(
                                                  width: 75.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[2].name ?? ''
                                                        : levels[2].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[3].mustCoins! &&
                                                  user!.balance! <
                                                      levels[4].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[3].name ?? ''
                                                        : levels[3].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[4].mustCoins! &&
                                                  user!.balance! <
                                                      levels[5].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[4].name ?? ''
                                                        : levels[4].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[5].mustCoins! &&
                                                  user!.balance! <
                                                      levels[6].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[5].name ?? ''
                                                        : levels[5].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[6].mustCoins! &&
                                                  user!.balance! <
                                                      levels[7].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[6].name ?? ''
                                                        : levels[6].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[7].mustCoins! &&
                                                  user!.balance! <
                                                      levels[8].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[7].name ?? ''
                                                        : levels[7].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[8].mustCoins! &&
                                                  user!.balance! <
                                                      levels[9].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[8].name ?? ''
                                                        : levels[8].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[9].mustCoins! &&
                                                  user!.balance! <
                                                      levels[10].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[9].name ?? ''
                                                        : levels[9].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[10].mustCoins! &&
                                                  user!.balance! <
                                                      levels[11].mustCoins!)
                                                SizedBox(
                                                   width: 88.5.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[10].name ?? ''
                                                        : levels[10].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[11].mustCoins! &&
                                                  user!.balance! <
                                                      levels[12].mustCoins!)
                                                SizedBox(
                                                  width: 88.5.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[11].name ?? ''
                                                        : levels[11].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[12].mustCoins! &&
                                                  user!.balance! <
                                                      levels[13].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[12].name ?? ''
                                                        : levels[12].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[13].mustCoins! &&
                                                  user!.balance! <
                                                      levels[14].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[13].name ?? ''
                                                        : levels[13].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[14].mustCoins! &&
                                                  user!.balance! <
                                                      levels[15].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[14].name ?? ''
                                                        : levels[14].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[15].mustCoins! &&
                                                  user!.balance! <
                                                      levels[16].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[15].name ?? ''
                                                        : levels[15].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[16].mustCoins! &&
                                                  user!.balance! <
                                                      levels[17].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[16].name ?? ''
                                                        : levels[16].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[17].mustCoins! &&
                                                  user!.balance! <
                                                      levels[18].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[17].name ?? ''
                                                        : levels[17].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                      levels[18].mustCoins! &&
                                                  user!.balance! <
                                                      levels[19].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[18].name ?? ''
                                                        : levels[18].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                              if (user!.balance! >=
                                                  levels[19].mustCoins!)
                                                SizedBox(
                                                  width: 88.w,
                                                  child: AutoSizeText(
                                                    user!.rus!
                                                        ? levels[19].name ?? ''
                                                        : levels[19].engName ??
                                                            '',
                                                    style: CustomTextStyle
                                                        .white_26_w800,
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
                                            ? 'how_many_levels_can_i_reach'.tr()
                                            : 'find_out_where_you_can_spend_points_and_how_to_earn_them'
                                                .tr(),
                                        style: CustomTextStyle.white_14_w400
                                            .copyWith(
                                          decoration: TextDecoration.underline,
                                          decorationStyle:
                                              TextDecorationStyle.dashed,
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
                              padding: EdgeInsets.zero,
                              physics: const BouncingScrollPhysics(),
                              child: Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(top: 50.h),
                                    child: Image.asset(
                                      'assets/images/group.png',
                                      height: 590.h,
                                      alignment: Alignment.topCenter,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w,
                                        vertical: Platform.isIOS ? 22.h : 25.h),
                                    child: SizedBox(
                                      height: Platform.isIOS ? 700.h : 700.h,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[0]
                                                                    .mustCoins! ||
                                                            levels[0].name ==
                                                                proverkaNext
                                                        ? '${levels[0].image}'
                                                        : '${levels[0].bwImage}',
                                                    user!.rus!
                                                        ? levels[0].name ?? ''
                                                        : levels[0].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[0].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[1]
                                                                    .mustCoins! ||
                                                            levels[1].name ==
                                                                proverkaNext
                                                        ? '${levels[1].image}'
                                                        : '${levels[1].bwImage}',
                                                    user!.rus!
                                                        ? levels[1].name ?? ''
                                                        : levels[1].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[1].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[2]
                                                                    .mustCoins! ||
                                                            levels[2].name ==
                                                                proverkaNext
                                                        ? '${levels[2].image}'
                                                        : '${levels[2].bwImage}',
                                                    user!.rus!
                                                        ? levels[2].name ?? ''
                                                        : levels[2].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[2].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[3]
                                                                    .mustCoins! ||
                                                            levels[3].name ==
                                                                proverkaNext
                                                        ? '${levels[3].image}'
                                                        : '${levels[3].bwImage}',
                                                    user!.rus!
                                                        ? levels[3].name ?? ''
                                                        : levels[3].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[3].mustCoins!),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //     height: Platform.isIOS
                                          //         ? 10.h
                                          //         : devicePixelRatio * 8.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[7]
                                                                    .mustCoins! ||
                                                            levels[7].name ==
                                                                proverkaNext
                                                        ? '${levels[7].image}'
                                                        : '${levels[7].bwImage}',
                                                    user!.rus!
                                                        ? levels[7].name ?? ''
                                                        : levels[7].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[7].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[6]
                                                                    .mustCoins! ||
                                                            levels[6].name ==
                                                                proverkaNext
                                                        ? '${levels[6].image}'
                                                        : '${levels[6].bwImage}',
                                                    user!.rus!
                                                        ? levels[6].name ?? ''
                                                        : levels[6].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[6].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[5]
                                                                    .mustCoins! ||
                                                            levels[5].name ==
                                                                proverkaNext
                                                        ? '${levels[5].image}'
                                                        : '${levels[5].bwImage}',
                                                    user!.rus!
                                                        ? levels[5].name ?? ''
                                                        : levels[5].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[5].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[4]
                                                                    .mustCoins! ||
                                                            levels[4].name ==
                                                                proverkaNext
                                                        ? '${levels[4].image}'
                                                        : '${levels[4].bwImage}',
                                                    user!.rus!
                                                        ? levels[4].name ?? ''
                                                        : levels[4].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[4].mustCoins!),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(
                                          //     height: Platform.isIOS
                                          //         ? 10.h
                                          //         : devicePixelRatio * 8.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[8]
                                                                    .mustCoins! ||
                                                            levels[8].name ==
                                                                proverkaNext
                                                        ? '${levels[8].image}'
                                                        : '${levels[8].bwImage}',
                                                    user!.rus!
                                                        ? levels[8].name ?? ''
                                                        : levels[8].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[8].mustCoins!),
                                                // const Spacer(),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[9]
                                                                    .mustCoins! ||
                                                            levels[9].name ==
                                                                proverkaNext
                                                        ? '${levels[9].image}'
                                                        : '${levels[9].bwImage}',
                                                    user!.rus!
                                                        ? levels[9].name ?? ''
                                                        : levels[9].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[9].mustCoins!),
                                                // const Spacer(),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[10]
                                                                    .mustCoins! ||
                                                            levels[10].name ==
                                                                proverkaNext
                                                        ? '${levels[10].image}'
                                                        : '${levels[10].bwImage}',
                                                    user!.rus!
                                                        ? levels[10].name ?? ''
                                                        : levels[10].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[10].mustCoins!),
                                                // const Spacer(),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[11]
                                                                    .mustCoins! ||
                                                            levels[11].name ==
                                                                proverkaNext
                                                        ? '${levels[11].image}'
                                                        : '${levels[11].bwImage}',
                                                    user!.rus!
                                                        ? levels[11].name ?? ''
                                                        : levels[11].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[11].mustCoins!),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(height: 10.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[15]
                                                                    .mustCoins! ||
                                                            levels[15].name ==
                                                                proverkaNext
                                                        ? '${levels[15].image}'
                                                        : '${levels[15].bwImage}',
                                                    user!.rus!
                                                        ? levels[15].name ?? ''
                                                        : levels[15].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[15].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[14]
                                                                    .mustCoins! ||
                                                            levels[14].name ==
                                                                proverkaNext
                                                        ? '${levels[14].image}'
                                                        : '${levels[14].bwImage}',
                                                    user!.rus!
                                                        ? levels[14].name ?? ''
                                                        : levels[14].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[14].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[13]
                                                                    .mustCoins! ||
                                                            levels[13].name ==
                                                                proverkaNext
                                                        ? '${levels[13].image}'
                                                        : '${levels[13].bwImage}',
                                                    user!.rus!
                                                        ? levels[13].name ?? ''
                                                        : levels[13].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[13].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[12]
                                                                    .mustCoins! ||
                                                            levels[12].name ==
                                                                proverkaNext
                                                        ? '${levels[12].image}'
                                                        : '${levels[12].bwImage}',
                                                    user!.rus!
                                                        ? levels[12].name ?? ''
                                                        : levels[12].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[12].mustCoins!),
                                              ],
                                            ),
                                          ),
                                          // SizedBox(height: 10.h),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15.w),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[16]
                                                                    .mustCoins! ||
                                                            levels[16].name ==
                                                                proverkaNext
                                                        ? '${levels[16].image}'
                                                        : '${levels[16].bwImage}',
                                                    user!.rus!
                                                        ? levels[16].name ?? ''
                                                        : levels[16].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[16].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[17]
                                                                    .mustCoins! ||
                                                            levels[17].name ==
                                                                proverkaNext
                                                        ? '${levels[17].image}'
                                                        : '${levels[17].bwImage}',
                                                    user!.rus!
                                                        ? levels[17].name ?? ''
                                                        : levels[17].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[17].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[18]
                                                                    .mustCoins! ||
                                                            levels[18].name ==
                                                                proverkaNext
                                                        ? '${levels[18].image}'
                                                        : '${levels[18].bwImage}',
                                                    user!.rus!
                                                        ? levels[18].name ?? ''
                                                        : levels[18].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[18].mustCoins!),
                                                firstPageItemScore(
                                                    user!.balance! >=
                                                                levels[19]
                                                                    .mustCoins! ||
                                                            levels[19].name ==
                                                                proverkaNext
                                                        ? '${levels[19].image}'
                                                        : '${levels[19].bwImage}',
                                                    user!.rus!
                                                        ? levels[19].name ?? ''
                                                        : levels[19].engName ??
                                                            '',
                                                    user!.balance!,
                                                    levels[19].mustCoins!),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 5.h),
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
      if (levels[i].mustCoins != null) {
        if (balance >= levels[i].mustCoins! &&
            balance < levels[i + 1].mustCoins!) {
          return CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) {
              return const CupertinoActivityIndicator();
            },
            imageUrl: levels[i].image != null ? '${levels[i].image}' : '',
            height: 113.h,
            width: 113.w,
            fit: BoxFit.fill,
          );
        } else if (balance >= levels.last.mustCoins!) {
          return CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) {
              return const CupertinoActivityIndicator();
            },
            imageUrl: '${levels.last.image}',
            height: 113.h,
            width: 113.w,
            fit: BoxFit.fill,
          );
        }
      } else {
        return CachedNetworkImage(
          progressIndicatorBuilder: (context, url, progress) {
            return const CupertinoActivityIndicator();
          },
          imageUrl: levels[i].image != null ? '${levels[i].image}' : '',
          height: 113.h,
          width: 113.w,
          fit: BoxFit.fill,
        );
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

  Widget firstPageItemScore(
      String icon, String title, int score, int mustCoins) {
    double value = 0;
    if (score >= mustCoins || title == proverkaNext) {
      value = score / mustCoins;
      if (value >= 1 && value < 0) {
        value = 1;
      }
    }
    return SizedBox(
      // width: 80.w,
      child: Column(
        children: [
          if (title.length > 11) SizedBox(height: 15.h),
          SizedBox(
            child: Stack(alignment: Alignment.center, children: [
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 60.h,
                  width: 60.h,
                  decoration: BoxDecoration(
                    color: colorBoxDecoration(score, mustCoins, title),
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(
                height: 50.h,
                width: 50.h,
                child: Image.network(
                  icon,
                ),
              ),
            ]),
          ),
          SizedBox(width: 60.w, height: 5.h),
          SizedBox(
            height: 5.h,
            width: 55.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: ColorStyles.greyBDBDBD,
                valueColor: const AlwaysStoppedAnimation<Color>(
                    ColorStyles.purpleA401C4),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Center(
            child: SizedBox(
              width: 75.w,
              child: Text(
                textAlign: TextAlign.center,
                title,
                style: score >= mustCoins || title == proverkaNext
                    ? CustomTextStyle.purple_12_w600.copyWith(fontSize: 12.sp)
                    : CustomTextStyle.grey_12_w400.copyWith(fontSize: 12.sp),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          SizedBox(
            width: 40.w,
            child: Text(
              mustCoins.toString(),
              textAlign: TextAlign.center,
              style: CustomTextStyle.black_12_w400_515150
                  .copyWith(fontSize: 12.sp),
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
            width: 50.w,
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
