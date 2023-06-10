import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widget_position.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/favourites/bloc_favourites/favourites_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/bloc_score/score_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends StatefulWidget {
  Owner owner;
  ProfileView({super.key, required this.owner});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  Owner? owner;
  GlobalKey globalKey = GlobalKey();
  List<String> typeCategories = [];

  @override
  void initState() {
    BlocProvider.of<AuthBloc>(context).add(GetCategoriesEvent());
    super.initState();
    getProfile();
  }

  void getProfile() async {
    final access = BlocProvider.of<ProfileBloc>(context).access;
    owner = await Repository().getRanking(widget.owner.id, access);
    if (owner?.activities != null) {
      for (int i = 0; i < owner!.activities!.length; i++) {
        typeCategories.add(owner!.activities![i].description!);
      }
    }

    setState(() {});
  }

  final List<ReviewsDetail> _reviews = [
    ReviewsDetail(
        id: 0,
        reviewerDetails: ReviewerDetails(id: 0, firstname: 'Максим', lastname: 'Яковлев', photo: null),
        message: 'Задача выполнена на 5+! Спасибо!',
        mark: 5),
    ReviewsDetail(
        id: 0,
        reviewerDetails: ReviewerDetails(id: 0, firstname: 'Максим', lastname: 'Яковлев', photo: null),
        message: 'Задача выполнена на 5+! Спасибо!',
        mark: 5),
    ReviewsDetail(
        id: 0,
        reviewerDetails: ReviewerDetails(id: 0, firstname: 'Максим', lastname: 'Яковлев', photo: null),
        message: 'Задача выполнена на 5+! Спасибо!',
        mark: 5),
    ReviewsDetail(
        id: 0,
        reviewerDetails: ReviewerDetails(id: 0, firstname: 'Максим', lastname: 'Яковлев', photo: null),
        message: 'Задача выполнена на 5+! Спасибо!',
        mark: 5),
  ];
  List<FavoriteCustomers>? favouritesUsers;
  @override
  Widget build(BuildContext context) {
    void getPeopleList() {
      final access = BlocProvider.of<ProfileBloc>(context).access;

      context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
    }

    final user = BlocProvider.of<ProfileBloc>(context).user;
    return Scaffold(
      
      resizeToAvoidBottomInset: false,
      body: owner == null
          ? const Center(child: CupertinoActivityIndicator())
          : Container(
              color: ColorStyles.greyEAECEE,
              child: MediaQuery(
                data: const MediaQueryData(textScaleFactor: 1.0),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: ListView(
                          physics: const ClampingScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            SizedBox(
                              height: owner?.photo == null ? 235.h : 270.h,
                              child: Padding(
                                padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                                child: Container(
                                  height: 400.h,
                                  decoration: BoxDecoration(
                                    color: ColorStyles.whiteFFFFFF,
                                    borderRadius: BorderRadius.circular(30.r),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 10.w, left: 24.w, top: 23, bottom: 15),
                                        child: Row(
                                          children: [
                                            if (owner?.photo != null)
                                              GestureDetector(
                                                onTap: () {
                                                  launch(owner!.photo!);
                                                },
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(1000.r),
                                                  child: Image.network(
                                                    owner?.photo ?? '',
                                                    height: 76.h,
                                                    width: 76.h,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                            SizedBox(width: 17.w),
                                            Expanded(
                                              child: Row(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text(
                                                        '${owner?.firstname ?? ''}\n${owner?.lastname ?? ''}',
                                                        style: CustomTextStyle.black_17_w600_171716,
                                                        softWrap: true,
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      if (user?.id != owner?.id)
                                                        BlocBuilder<TasksBloc, TasksState>(
                                                            buildWhen: (previous, current) {
                                                          return true;
                                                        }, builder: (context, state) {
                                                          return BlocBuilder<FavouritesBloc, FavouritesState>(
                                                              buildWhen: (previous, current) {
                                                            return true;
                                                          }, builder: (context, state) {
                                                            if (state is FavouritesLoaded) {
                                                              favouritesUsers = state.favourite?.favoriteUsers;
                                                              return GestureDetector(
                                                                onTap: () async {
                                                                  if (owner?.isLiked != null) {
                                                                    final access = await Storage().getAccessToken();
                                                                    if (owner?.isLiked != null) {
                                                                      await Repository()
                                                                          .deleteLikeUser(owner!.isLiked!, access!);
                                                                    }
                                                                    getPeopleList();
                                                                    setState(() {
                                                                      owner?.isLiked = null;
                                                                    });
                                                                  } else {
                                                                    final access = await Storage().getAccessToken();
                                                                    log(access.toString());
                                                                    if (owner?.id != null) {
                                                                      await Repository()
                                                                          .addLikeUser(owner!.id!, access!);
                                                                    }
                                                                    owner = await Repository()
                                                                        .getRanking(widget.owner.id, access);
                                                                    getPeopleList();
                                                                    setState(() {});
                                                                  }
                                                                },
                                                                child: owner?.isLiked != null
                                                                    ? SvgPicture.asset(
                                                                        'assets/icons/heart_yellow.svg',
                                                                        height: 20.h,
                                                                      )
                                                                    : SvgPicture.asset(
                                                                        'assets/icons/heart.svg',
                                                                        height: 20.h,
                                                                      ),
                                                              );
                                                            }
                                                            return Container();
                                                          });
                                                        }),
                                                      SizedBox(width: 10.w),
                                                      GestureDetector(
                                                        onTap: () => taskMoreDialogForProfile(
                                                          context,
                                                          getWidgetPosition(globalKey),
                                                          (index) {},
                                                          owner,
                                                        ),
                                                        child: SvgPicture.asset(
                                                          'assets/icons/share.svg',
                                                          height: 20.h,
                                                          key: globalKey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      BlocBuilder<RatingBloc, RatingState>(builder: (context, snapshot) {
                                        var reviews = BlocProvider.of<RatingBloc>(context).reviews;
                                        return Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            GestureDetector(
                                              onTap: () {},
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 0.8.h),
                                                    child: ScaleButton(
                                                      onTap: () {},
                                                      bound: 0.02,
                                                      child: Container(
                                                        height: 25.h,
                                                        width: 70.h,
                                                        decoration: BoxDecoration(
                                                          color: ColorStyles.greyEAECEE,
                                                          borderRadius: BorderRadius.circular(30.r),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Грейд',
                                                            style: CustomTextStyle.purple_12_w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Row(
                                                    children: [
                                                      BlocBuilder<ScoreBloc, ScoreState>(builder: (context, state) {
                                                        if (state is ScoreLoaded) {
                                                          final levels = state.levels;
                                                          if (owner!.balance! < levels![0].mustCoins!) {
                                                            return CachedNetworkImage(
                                                              progressIndicatorBuilder: (context, url, progress) {
                                                                return const CupertinoActivityIndicator();
                                                              },
                                                              imageUrl: '${levels[0].bwImage}',
                                                              height: 30.h,
                                                              width: 30.w,
                                                            );
                                                          }
                                                          for (int i = 0; i < levels.length; i++) {
                                                            if (levels[i + 1].mustCoins == null) {
                                                              return CachedNetworkImage(
                                                                progressIndicatorBuilder: (context, url, progress) {
                                                                  return const CupertinoActivityIndicator();
                                                                },
                                                                imageUrl: '${levels[i].image}',
                                                                height: 30.h,
                                                                width: 30.w,
                                                              );
                                                            } else {
                                                              if (owner!.balance! >= levels[i].mustCoins! &&
                                                                  owner!.balance! < levels[i + 1].mustCoins!) {
                                                                return CachedNetworkImage(
                                                                  progressIndicatorBuilder: (context, url, progress) {
                                                                    return const CupertinoActivityIndicator();
                                                                  },
                                                                  imageUrl: '${levels[i].image}',
                                                                  height: 30.h,
                                                                  width: 30.w,
                                                                );
                                                              } else if (owner!.balance! >= levels.last.mustCoins!) {
                                                                return CachedNetworkImage(
                                                                  progressIndicatorBuilder: (context, url, progress) {
                                                                    return const CupertinoActivityIndicator();
                                                                  },
                                                                  imageUrl: '${levels.last.image}',
                                                                  height: 30.h,
                                                                  width: 30.w,
                                                                );
                                                              }
                                                            }
                                                          }
                                                        }
                                                        return Container();
                                                      }),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 5.5.h),
                                                    child: ScaleButton(
                                                      onTap: () {},
                                                      bound: 0.02,
                                                      child: Container(
                                                        height: 25.h,
                                                        width: 90.h,
                                                        decoration: BoxDecoration(
                                                          color: ColorStyles.yellowFFCA0D.withOpacity(0.2),
                                                          borderRadius: BorderRadius.circular(30.r),
                                                        ),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Text(
                                                                'Рейтинг',
                                                                style: CustomTextStyle.gold_12_w400,
                                                              ),
                                                              SizedBox(width: 3.h),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    width: 12,
                                                                    height: 12,
                                                                    child: SvgPicture.asset(
                                                                      'assets/icons/star.svg',
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10.h,
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 4.h),
                                                    child: SizedBox(
                                                      child: Text(
                                                        reviews?.ranking == null ? '3.4' : reviews!.ranking!.toString(),
                                                        style: CustomTextStyle.gold_16_w600_171716,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            GestureDetector(
                                              onTap: () {},
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 15.h),
                                                    child: ScaleButton(
                                                      onTap: () {},
                                                      bound: 0.02,
                                                      child: Container(
                                                        height: 25.h,
                                                        width: 75.h,
                                                        decoration: BoxDecoration(
                                                          color: ColorStyles.blue336FEE.withOpacity(0.2),
                                                          borderRadius: BorderRadius.circular(30.r),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            'Отзывы',
                                                            style: CustomTextStyle.blue_12_w400,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.only(bottom: 4.0.h),
                                                    child: SizedBox(
                                                      child: Text(
                                                        '34',
                                                        style: CustomTextStyle.blue_16_w600_171716,
                                                        textAlign: TextAlign.left,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                      SizedBox(height: 12.h),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.h),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Создано заданий:',
                                              style: CustomTextStyle.grey_12_w400,
                                            ),
                                            Text(
                                              ' 40',
                                              style: CustomTextStyle.black_13_w500_171716,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 15.h),
                                        child: Row(
                                          children: [
                                            Text(
                                              'Выполнено заданий:',
                                              style: CustomTextStyle.grey_12_w400,
                                            ),
                                            Text(
                                              ' 40',
                                              style: CustomTextStyle.black_13_w500_171716,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 7.h, top: 5.h),
                              child: Container(
                                height: 105.h,
                                width: 100.w,
                                decoration: BoxDecoration(
                                  color: ColorStyles.whiteFFFFFF,
                                  borderRadius: BorderRadius.circular(30.r),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.only(top: 20.h, left: 20.w),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset('assets/icons/document.svg'),
                                          SizedBox(width: 3.w),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Паспортные данные загружены',
                                                  style: owner != null &&
                                                          owner!.isPassportExist != null &&
                                                          owner!.isPassportExist!
                                                      ? CustomTextStyle.black_11_w400_171716
                                                      : CustomTextStyle.grey_12_w400,
                                                ),
                                                if (owner != null &&
                                                    owner!.isPassportExist != null &&
                                                    owner!.isPassportExist!)
                                                  SizedBox(
                                                    width: 63.w,
                                                  ),
                                                if (owner != null &&
                                                    owner!.isPassportExist != null &&
                                                    owner!.isPassportExist!)
                                                  const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10.h, left: 20.w),
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SvgPicture.asset('assets/icons/security-user.svg'),
                                          SizedBox(width: 3.w),
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'Пользователь верифицирован\nприложением',
                                                  style: owner != null &&
                                                          owner!.isPassportExist != null &&
                                                          owner!.isPassportExist!
                                                      ? CustomTextStyle.black_11_w400_171716
                                                      : CustomTextStyle.grey_12_w400,
                                                ),
                                                if (owner != null &&
                                                    owner!.isPassportExist != null &&
                                                    owner!.isPassportExist!)
                                                  SizedBox(
                                                    width: 70.w,
                                                  ),
                                                if (owner != null &&
                                                    owner!.isPassportExist != null &&
                                                    owner!.isPassportExist!)
                                                  const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5.h),
                                  child: Container(
                                    height: 45.h,
                                    width: 327.w,
                                    decoration: BoxDecoration(
                                      color: ColorStyles.whiteFFFFFF,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          'assets/icons/document_text.svg',
                                          color: owner != null && owner!.cv != null && owner!.cv!.isNotEmpty
                                              ? ColorStyles.blue336FEE
                                              : Colors.grey,
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            if (owner != null && owner!.cv != null && owner!.cv!.isNotEmpty) {
                                              launch(owner!.cv!);
                                            }
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10.w),
                                            child: Text(
                                              'Посмотреть резюме',
                                              style: CustomTextStyle.black_11_w400_171716.copyWith(
                                                color: owner != null && owner!.cv != null && owner!.cv!.isNotEmpty
                                                    ? ColorStyles.blue336FEE
                                                    : Colors.grey,
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
                            if (owner != null && typeCategories.isNotEmpty) SizedBox(height: 20.h),
                            if (owner != null && typeCategories.isNotEmpty)
                              SizedBox(
                                height: 90.h,
                                width: double.infinity,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  padding: EdgeInsets.only(right: 0.w),
                                  itemCount: typeCategories.length,
                                  itemBuilder: (context, index) {
                                    return _categoryItemOwner(owner!.activities![index], index);
                                  },
                                ),
                              ),
                            SizedBox(height: 30.h),
                            Text(
                              'Опыт работы',
                              style: CustomTextStyle.black_17_w800,
                            ),
                            SizedBox(height: 20.h),
                            Container(
                              decoration: BoxDecoration(
                                color: ColorStyles.whiteFFFFFF,
                                borderRadius: BorderRadius.circular(10.r),
                                boxShadow: [
                                  BoxShadow(
                                    color: ColorStyles.shadowFC6554,
                                    offset: const Offset(0, 4),
                                    blurRadius: 45.r,
                                  )
                                ],
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                              child: SizedBox(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      owner != null && owner!.activity != null && owner!.activity!.isNotEmpty
                                          ? owner!.activity!
                                          : 'Опыт работы не указан.',
                                      style: CustomTextStyle.black_12_w400_292D32,
                                    ),
                                    if (owner != null && owner!.listPhoto.isNotEmpty)
                                      Padding(
                                        padding: EdgeInsets.only(top: 18.h),
                                        child: SizedBox(
                                          height: 66.h,
                                          child: ListView.builder(
                                            scrollDirection: Axis.horizontal,
                                            itemCount: owner!.listPhoto.length,
                                            itemBuilder: (context, index) {
                                              return Padding(
                                                padding: EdgeInsets.only(right: 10.w),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    launch(owner!.listPhoto[index]);
                                                  },
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(10.r),
                                                    child: CachedNetworkImage(
                                                      imageUrl: owner!.listPhoto[index],
                                                      height: 66.h,
                                                      progressIndicatorBuilder: (context, url, progress) {
                                                        return const CupertinoActivityIndicator();
                                                      },
                                                      width: 66.w,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
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
                                              height: 39.h,
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
                                                      style: CustomTextStyle.blue_14_w400_336FEE,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 15.h),
                              child: Row(
                                // mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset('assets/icons/warning-2.svg', color: ColorStyles.redFC6554),
                                  GestureDetector(
                                    onTap: () {
                                      if (owner != null && owner!.cv != null && owner!.cv!.isNotEmpty) {
                                        launch(owner!.cv!);
                                      }
                                    },
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 5.w),
                                      child: Text(
                                        'Пожаловаться на пользователя',
                                        style:
                                            CustomTextStyle.black_11_w400_171716.copyWith(color: ColorStyles.redFC6554),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 30.h),
                            Text(
                              'Отзывы',
                              style: CustomTextStyle.black_17_w800,
                            ),
                            SizedBox(height: 15.h),
                            BlocBuilder<RatingBloc, RatingState>(builder: (context, snapshot) {
                              if (snapshot is LoadingRatingState) {
                                return const CupertinoActivityIndicator();
                              }
                              Reviews? reviews = BlocProvider.of<RatingBloc>(context).reviews;
                              return Container(
                                child: ListView.builder(
                                  //TODO Эта логика для сервера

                                  // ListView.builder(
                                  //   physics: const NeverScrollableScrollPhysics(),
                                  //   shrinkWrap: true,
                                  //   itemCount: reviews.reviewsDetail.length,
                                  //   itemBuilder: ((context, index) {
                                  //     return itemComment(reviews.reviewsDetail[index]);
                                  //   }),

                                  //TODO Эта логика для сервера

                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _reviews.length,
                                  itemBuilder: ((context, index) {
                                    return itemCommentNew(_reviews[index]);
                                  }),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget itemCommentNew(ReviewsDetail review) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: ColorStyles.whiteFFFFFF,
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
                      decoration: const BoxDecoration(color: ColorStyles.shadowFC6554),
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
                      style: CustomTextStyle.black_14_w500_171716,
                    ),
                    Text(
                      '01.04.2023',
                      style: CustomTextStyle.grey_12_w400,
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
                    style: CustomTextStyle.black_14_w400_171716,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                child: Text(
                  review.message,
                  style: CustomTextStyle.black_12_w400_515150,
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
                        height: 39.h,
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
                                style: CustomTextStyle.blue_14_w400_336FEE,
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

  Widget _categoryItemOwner(ownerActivities activitiy, int index) {
    return Container(
      height: 90.h,
      width: 115.w,
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: index == 0
            ? const Color.fromRGBO(255, 234, 203, 1)
            : index == 1
                ? const Color.fromRGBO(255, 224, 237, 1)
                : const Color.fromRGBO(213, 247, 254, 1),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (activitiy.photo != null)
              Image.network(
                activitiy.photo!,
                width: 24.w,
                height: 24.h,
              ),
            const Spacer(),
            Text(
              activitiy.description ?? '',
              style: CustomTextStyle.black_11_w400_171716,
            ),
          ],
        ),
      ),
    );
  }
}
