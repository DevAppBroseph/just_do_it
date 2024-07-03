import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
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
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/favourites_info.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/review.dart';
import 'package:just_do_it/models/user_reg.dart';
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
  Reviews? reviews;
  late UserRegModel? user;

  @override
  void initState() {
    user = BlocProvider.of<ProfileBloc>(context).user;
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

  List<FavoriteCustomers>? favouritesUsers;

  @override
  Widget build(BuildContext context) {
    void getPeopleList() {
      final access = BlocProvider.of<ProfileBloc>(context).access;
      context.read<FavouritesBloc>().add(GetFavouritesEvent(access));
    }

    final user = BlocProvider.of<ProfileBloc>(context).user;
    return Scaffold(
      backgroundColor:
          SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
              ? DarkAppColors.whitePrimary
              : LightAppColors.greyPrimary,
      resizeToAvoidBottomInset: false,
      body: owner == null
          ? const Center(child: CupertinoActivityIndicator())
          : Container(
              color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                  ? DarkAppColors.whitePrimary
                  : LightAppColors.greyPrimary,
              child: MediaQuery(
                data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: owner!.isBanned!
                      ? Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 200.h),
                                child: SvgPicture.asset(
                                  'assets/icons/frown.svg',
                                ),
                              ),
                              SizedBox(
                                height: 18.h,
                              ),
                              Center(
                                child: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 70.w),
                                  child: Text(
                                    'user_account_is_currently_blocked'.tr(),
                                    textAlign: TextAlign.center,
                                    style: CustomTextStyle.sf17w400(
                                            LightAppColors.greyTernary)
                                        .copyWith(fontWeight: FontWeight.w800),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 140.h,
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: ListView(
                                physics: const ClampingScrollPhysics(),
                                shrinkWrap: true,
                                children: [
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 8.h, bottom: 8.h),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: SettingsScope.themeOf(context)
                                                    .theme
                                                    .mode ==
                                                ThemeMode.dark
                                            ? Color(0xff3f3e3b)
                                            //DarkAppColors.whitePrimary
                                            : LightAppColors.whitePrimary,
                                        // color: LightAppColors.whitePrimary,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                right: 10.w,
                                                left: 24.w,
                                                top: 23,
                                                bottom: 15),
                                            child: Row(
                                              children: [
                                                if (owner?.photo != null)
                                                  GestureDetector(
                                                    onTap: () {
                                                      launch(owner!.photo!);
                                                    },
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              1000.r),
                                                      child: Image.network(
                                                        (owner?.photo ?? ''),
                                                        height: 76.h,
                                                        width: 76.h,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                SizedBox(width: 17.w),
                                                Expanded(
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Text(
                                                            '${owner?.firstname ?? ''}\n${owner?.lastname ?? ''}',
                                                            style: CustomTextStyle
                                                                    .sf18w800(
                                                                        LightAppColors
                                                                            .blackSecondary)
                                                                .copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                            softWrap: true,
                                                          ),
                                                        ],
                                                      ),
                                                      const Spacer(),
                                                      Row(
                                                        children: [
                                                          if (user?.id !=
                                                              owner?.id)
                                                            BlocBuilder<
                                                                    TasksBloc,
                                                                    TasksState>(
                                                                buildWhen:
                                                                    (previous,
                                                                        current) {
                                                              return true;
                                                            }, builder:
                                                                    (context,
                                                                        state) {
                                                              return BlocBuilder<
                                                                      FavouritesBloc,
                                                                      FavouritesState>(
                                                                  buildWhen:
                                                                      (previous,
                                                                          current) {
                                                                return true;
                                                              }, builder:
                                                                      (context,
                                                                          state) {
                                                                if (state
                                                                    is FavouritesLoaded) {
                                                                  favouritesUsers = state
                                                                      .favourite
                                                                      ?.favoriteUsers;
                                                                  return GestureDetector(
                                                                    onTap:
                                                                        () async {
                                                                      if (owner
                                                                              ?.isLiked !=
                                                                          null) {
                                                                        final access =
                                                                            Storage().getAccessToken();
                                                                        if (owner?.isLiked !=
                                                                            null) {
                                                                          await Repository().deleteLikeUser(
                                                                              owner!.isLiked!,
                                                                              access!);
                                                                        }
                                                                        getPeopleList();
                                                                        setState(
                                                                            () {
                                                                          owner?.isLiked =
                                                                              null;
                                                                        });
                                                                      } else {
                                                                        final access =
                                                                            Storage().getAccessToken();
                                                                        if (owner?.id !=
                                                                            null) {
                                                                          await Repository().addLikeUser(
                                                                              owner!.id!,
                                                                              access!);
                                                                        }
                                                                        owner = await Repository().getRanking(
                                                                            widget.owner.id,
                                                                            access);
                                                                        getPeopleList();
                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    },
                                                                    child: owner?.isLiked !=
                                                                            null
                                                                        ? SvgPicture
                                                                            .asset(
                                                                            'assets/icons/heart_yellow.svg',
                                                                            height:
                                                                                20.h,
                                                                          )
                                                                        : SvgPicture
                                                                            .asset(
                                                                            'assets/icons/heart.svg',
                                                                            height:
                                                                                20.h,
                                                                          ),
                                                                  );
                                                                }
                                                                return Container();
                                                              });
                                                            }),
                                                          SizedBox(width: 10.w),
                                                          GestureDetector(
                                                            onTap: () =>
                                                                taskMoreDialogForProfile(
                                                                    context,
                                                                    getWidgetPosition(
                                                                        globalKey),
                                                                    (index) {},
                                                                    owner,
                                                                    user),
                                                            child: SvgPicture
                                                                .asset(
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
                                          BlocBuilder<RatingBloc, RatingState>(
                                              builder: (context, snapshot) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {},
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 0.8.h),
                                                        child: ScaleButton(
                                                          onTap: () {},
                                                          bound: 0.02,
                                                          child: Container(
                                                            height: 25.h,
                                                            width: 70.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: LightAppColors
                                                                  .greyPrimary,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.r),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'grade'.tr(),
                                                                style: CustomTextStyle
                                                                    .sf12w400(
                                                                        LightAppColors
                                                                            .purplePrimary),
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
                                                          BlocBuilder<ScoreBloc,
                                                                  ScoreState>(
                                                              builder: (context,
                                                                  state) {
                                                            if (state
                                                                is ScoreLoaded) {
                                                              final levels =
                                                                  state.levels;
                                                              if (owner!
                                                                      .balance! <
                                                                  levels![0]
                                                                      .mustCoins!) {
                                                                return CachedNetworkImage(
                                                                  progressIndicatorBuilder:
                                                                      (context,
                                                                          url,
                                                                          progress) {
                                                                    return const CupertinoActivityIndicator();
                                                                  },
                                                                  imageUrl:
                                                                      '${levels[0].bwImage}',
                                                                  height: 30.h,
                                                                  width: 30.w,
                                                                );
                                                              }
                                                              for (int i = 0;
                                                                  i <
                                                                      levels
                                                                          .length;
                                                                  i++) {
                                                                if (levels[i +
                                                                            1]
                                                                        .mustCoins ==
                                                                    null) {
                                                                  return CachedNetworkImage(
                                                                    progressIndicatorBuilder:
                                                                        (context,
                                                                            url,
                                                                            progress) {
                                                                      return const CupertinoActivityIndicator();
                                                                    },
                                                                    imageUrl:
                                                                        '${levels[i].image}',
                                                                    height:
                                                                        30.h,
                                                                    width: 30.w,
                                                                  );
                                                                } else {
                                                                  if (owner!.balance! >=
                                                                          levels[i]
                                                                              .mustCoins! &&
                                                                      owner!.balance! <
                                                                          levels[i + 1]
                                                                              .mustCoins!) {
                                                                    return CachedNetworkImage(
                                                                      progressIndicatorBuilder:
                                                                          (context,
                                                                              url,
                                                                              progress) {
                                                                        return const CupertinoActivityIndicator();
                                                                      },
                                                                      imageUrl:
                                                                          '${levels[i].image}',
                                                                      height:
                                                                          30.h,
                                                                      width:
                                                                          30.w,
                                                                    );
                                                                  } else if (owner!
                                                                          .balance! >=
                                                                      levels
                                                                          .last
                                                                          .mustCoins!) {
                                                                    return CachedNetworkImage(
                                                                      progressIndicatorBuilder:
                                                                          (context,
                                                                              url,
                                                                              progress) {
                                                                        return const CupertinoActivityIndicator();
                                                                      },
                                                                      imageUrl:
                                                                          '${levels.last.image}',
                                                                      height:
                                                                          30.h,
                                                                      width:
                                                                          30.w,
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 5.5.h),
                                                        child: ScaleButton(
                                                          onTap: () {},
                                                          bound: 0.02,
                                                          child: Container(
                                                            height: 25.h,
                                                            width: 90.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: LightAppColors
                                                                  .yellowBackground
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.r),
                                                            ),
                                                            child: Center(
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'rating'
                                                                        .tr(),
                                                                    style: CustomTextStyle.sf12w400(
                                                                        LightAppColors
                                                                            .yellowBackground),
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          3.h),
                                                                  Row(
                                                                    children: [
                                                                      SizedBox(
                                                                        width:
                                                                            12,
                                                                        height:
                                                                            12,
                                                                        child: SvgPicture
                                                                            .asset(
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
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4.h),
                                                        child: SizedBox(
                                                          child: Text(
                                                            owner?.ranking ==
                                                                    null
                                                                ? '0'
                                                                : owner!.ranking
                                                                    .toString(),
                                                            style: CustomTextStyle
                                                                .sf17w400(
                                                                    LightAppColors
                                                                        .yellowBackground),
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
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 15.h),
                                                        child: ScaleButton(
                                                          onTap: () {},
                                                          bound: 0.02,
                                                          child: Container(
                                                            height: 25.h,
                                                            width: 75.h,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: LightAppColors
                                                                  .blueSecondary
                                                                  .withOpacity(
                                                                      0.2),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30.r),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'reviews'.tr(),
                                                                style: CustomTextStyle
                                                                    .sf12w400(
                                                                        LightAppColors
                                                                            .blueSecondary),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                bottom: 4.0.h),
                                                        child: SizedBox(
                                                          child: Text(
                                                            owner!.reviews
                                                                    ?.length
                                                                    .toString() ??
                                                                '0',
                                                            style: CustomTextStyle
                                                                .sf17w400(
                                                                    LightAppColors
                                                                        .blueSecondary),
                                                            textAlign:
                                                                TextAlign.left,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                          SizedBox(height: 15.h),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'tasks_created'.tr(),
                                                  style:
                                                      CustomTextStyle.sf13w400(
                                                          LightAppColors
                                                              .greySecondary),
                                                ),
                                                Text(
                                                  owner!.countOrdersCreate
                                                      .toString(),
                                                  style: CustomTextStyle.sf17w400(
                                                          LightAppColors
                                                              .blackSecondary)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsets.only(left: 15.h),
                                            child: Row(
                                              children: [
                                                Text(
                                                  'completed_tasks'.tr(),
                                                  style:
                                                      CustomTextStyle.sf13w400(
                                                          LightAppColors
                                                              .greySecondary),
                                                ),
                                                Text(
                                                  owner!.countOrdersComplete
                                                      .toString(),
                                                  style: CustomTextStyle.sf17w400(
                                                          LightAppColors
                                                              .blackSecondary)
                                                      .copyWith(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 16.h),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(bottom: 7.h, top: 5.h),
                                    child: Container(
                                      width: 100.w,
                                      decoration: BoxDecoration(
                                        color: SettingsScope.themeOf(context)
                                                    .theme
                                                    .mode ==
                                                ThemeMode.dark
                                            ? Color(0xff3f3e3b)
                                            //DarkAppColors.whitePrimary
                                            : LightAppColors.whitePrimary,
                                        //color: LightAppColors.whitePrimary,
                                        borderRadius:
                                            BorderRadius.circular(30.r),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 23.h, left: 20.w),
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/icons/document.svg'),
                                                SizedBox(width: 3.w),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 240.w,
                                                        child: Text(
                                                          'passport_data_uploaded'
                                                              .tr(),
                                                          style: owner !=
                                                                      null &&
                                                                  owner!.isPassportExist !=
                                                                      null &&
                                                                  owner!
                                                                      .isPassportExist!
                                                              ? CustomTextStyle
                                                                  .sf12w400(
                                                                      LightAppColors
                                                                          .blackSecondary)
                                                              : CustomTextStyle
                                                                  .sf13w400(
                                                                      LightAppColors
                                                                          .greySecondary),
                                                        ),
                                                      ),
                                                      if (owner != null &&
                                                          owner!.isPassportExist !=
                                                              null &&
                                                          owner!
                                                              .isPassportExist!)
                                                        if (owner != null &&
                                                            owner!.isPassportExist !=
                                                                null &&
                                                            owner!
                                                                .isPassportExist!)
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
                                            padding: EdgeInsets.only(
                                                top: 10.h, left: 20.w),
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/icons/security-user.svg'),
                                                SizedBox(width: 3.w),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 240.w,
                                                        child: Text(
                                                          'the_user_is_verified_by_the_application'
                                                              .tr(),
                                                          style: owner !=
                                                                      null &&
                                                                  owner!
                                                                      .isVerified!
                                                              ? CustomTextStyle
                                                                  .sf12w400(
                                                                      LightAppColors
                                                                          .blackSecondary)
                                                              : CustomTextStyle
                                                                  .sf13w400(
                                                                      LightAppColors
                                                                          .greySecondary),
                                                        ),
                                                      ),
                                                      if (owner != null &&
                                                          owner!.isVerified!)
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
                                          SizedBox(height: 23.h),
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
                                            color: SettingsScope.themeOf(
                                                            context)
                                                        .theme
                                                        .mode ==
                                                    ThemeMode.dark
                                                ? Color(0xff3f3e3b)
                                                //DarkAppColors.whitePrimary
                                                : LightAppColors.whitePrimary,
                                            //color: LightAppColors.whitePrimary,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/document_text.svg',
                                                color: owner != null &&
                                                        owner!.cv != null &&
                                                        owner!.cv!.isNotEmpty
                                                    ? LightAppColors
                                                        .blueSecondary
                                                    : Colors.grey,
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (owner != null &&
                                                      owner!.cv != null &&
                                                      owner!.cv!.isNotEmpty) {
                                                    launch(owner!.cv!);
                                                  }
                                                },
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.w),
                                                  child: Text(
                                                    'view_resume'.tr(),
                                                    style: CustomTextStyle.sf12w400(
                                                            LightAppColors
                                                                .blackSecondary)
                                                        .copyWith(
                                                      color: owner != null &&
                                                              owner!.cv !=
                                                                  null &&
                                                              owner!.cv!
                                                                  .isNotEmpty
                                                          ? LightAppColors
                                                              .blueSecondary
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
                                  if (owner != null &&
                                      typeCategories.isNotEmpty)
                                    SizedBox(height: 20.h),
                                  if (owner != null &&
                                      typeCategories.isNotEmpty)
                                    SizedBox(
                                      height: 90.h,
                                      width: double.infinity,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        scrollDirection: Axis.horizontal,
                                        padding: EdgeInsets.only(right: 0.w),
                                        itemCount: typeCategories.length,
                                        itemBuilder: (context, index) {
                                          return _categoryItemOwner(
                                              owner!.activities![index], index);
                                        },
                                      ),
                                    ),
                                  SizedBox(height: 30.h),
                                  Text(
                                    'work_experience'.tr(),
                                    style: SettingsScope.themeOf(context)
                                        .theme
                                        .getStyle(
                                            (lightStyles) =>
                                                lightStyles.sf18w800BlackSec,
                                            (darkStyles) =>
                                                darkStyles.sf18w800BlackSec),
                                  ),
                                  SizedBox(height: 20.h),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: SettingsScope.themeOf(context)
                                                  .theme
                                                  .mode ==
                                              ThemeMode.dark
                                          ? Color(0xff3f3e3b)
                                          //DarkAppColors.whitePrimary
                                          : LightAppColors.whitePrimary,
                                      // color: LightAppColors.whitePrimary,
                                      borderRadius: BorderRadius.circular(10.r),
                                      boxShadow: [
                                        BoxShadow(
                                          color: LightAppColors.shadowPrimary,
                                          offset: const Offset(0, 4),
                                          blurRadius: 45.r,
                                        )
                                      ],
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 16.h),
                                    child: SizedBox(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            owner != null &&
                                                    owner!.activity != null &&
                                                    owner!.activity!.isNotEmpty
                                                ? owner!.activity!
                                                : 'work_experience_is_not_specified'
                                                    .tr(),
                                            style: CustomTextStyle.sf17w400(
                                                LightAppColors.blackError),
                                          ),
                                          if (owner != null &&
                                              owner!.listPhoto.isNotEmpty)
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(top: 18.h),
                                              child: SizedBox(
                                                height: 66.h,
                                                child: ListView.builder(
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      owner!.listPhoto.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return Padding(
                                                      padding: EdgeInsets.only(
                                                          right: 10.w),
                                                      child: GestureDetector(
                                                        onTap: () {
                                                          launch(
                                                              owner!.listPhoto[
                                                                  index]);
                                                        },
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      10.r),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl: owner!
                                                                    .listPhoto[
                                                                index],
                                                            height: 66.h,
                                                            progressIndicatorBuilder:
                                                                (context, url,
                                                                    progress) {
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    height: 39.h,
                                                    decoration: BoxDecoration(
                                                      color: SettingsScope
                                                                      .themeOf(
                                                                          context)
                                                                  .theme
                                                                  .mode ==
                                                              ThemeMode.dark
                                                          ? Color(0xff3f3e3b)
                                                          //DarkAppColors.whitePrimary
                                                          : LightAppColors
                                                              .whitePrimary,
                                                      // color: LightAppColors
                                                      //     .whiteSecondary,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.r),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          EdgeInsets.all(10.h),
                                                      child: Row(
                                                        children: [
                                                          SvgPicture.asset(
                                                              'assets/icons/translate.svg'),
                                                          SizedBox(width: 8.h),
                                                          Text(
                                                            'translation'.tr(),
                                                            style: CustomTextStyle
                                                                .sf17w400(
                                                                    LightAppColors
                                                                        .blueSecondary),
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
                                        SvgPicture.asset(
                                            'assets/icons/warning-2.svg',
                                            color: LightAppColors.redPrimary),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pushNamed(
                                                AppRoute.contactus,
                                                arguments: [
                                                  '${owner!.firstname} ${owner?.lastname}',
                                                  'user_complaint'.tr()
                                                ]);
                                          },
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: Text(
                                              'report_a_user'.tr(),
                                              style: CustomTextStyle.sf12w400(
                                                      LightAppColors
                                                          .blackSecondary)
                                                  .copyWith(
                                                      color: LightAppColors
                                                          .redPrimary),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 30.h),
                                  if (owner?.reviews == [] &&
                                      owner!.reviews!.isEmpty)
                                    Text(
                                      'reviews'.tr(),
                                      style: CustomTextStyle.sf18w800(
                                          LightAppColors.blackSecondary),
                                    ),
                                  SizedBox(height: 15.h),
                                  if (owner?.reviews != [])
                                    BlocBuilder<RatingBloc, RatingState>(
                                        builder: (context, snapshot) {
                                      if (snapshot is LoadingRatingState) {
                                        return const CupertinoActivityIndicator();
                                      }

                                      return ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: owner?.reviews?.length,
                                        itemBuilder: ((context, index) {
                                          return itemCommentNew(
                                              owner!.reviews![index]);
                                        }),
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
        //color: LightAppColors.whitePrimary,
        color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
            ? Color(0xff3f3e3b)
            //DarkAppColors.whitePrimary
            : LightAppColors.whitePrimary,
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
                      decoration: const BoxDecoration(
                          color: LightAppColors.shadowPrimary),
                    )
                  : CachedNetworkImage(
                      height: 34.h,
                      width: 34.h,
                      imageUrl: server + review.reviewerDetails.photo!,
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
                    SizedBox(
                      width: 150.w,
                      child: Text(
                        '${review.reviewerDetails.firstname} ${review.reviewerDetails.lastname}',
                        style: CustomTextStyle.sf17w400(
                          Colors.black,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    if (review.date != '')
                      Text(
                        _textData(review.date),
                        style: CustomTextStyle.sf13w400(
                            LightAppColors.greySecondary),
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
                    style:
                        CustomTextStyle.sf17w400(LightAppColors.blackSecondary),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              SizedBox(
                width: 200.w,
                child: Text(
                  review.message,
                  style: CustomTextStyle.sf13w400(LightAppColors.blackAccent),
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
                          color: SettingsScope.themeOf(context).theme.mode ==
                                  ThemeMode.dark
                              ? Color(0xff3f3e3b)
                              //DarkAppColors.whitePrimary
                              : LightAppColors.whitePrimary,
                          //  color: LightAppColors.whiteSecondary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10.h),
                          child: Row(
                            children: [
                              SvgPicture.asset('assets/icons/translate.svg'),
                              SizedBox(width: 8.h),
                              Text(
                                'translation'.tr(),
                                style: CustomTextStyle.sf17w400(
                                    LightAppColors.blueSecondary),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
            ],
          )
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

  Widget _categoryItemOwner(OwnerActivities activitiy, int index) {
    return Container(
      height: 90.h,
      width: 115.w,
      margin: const EdgeInsets.only(right: 0),
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
                user?.rus ?? true && context.locale.languageCode == 'ru'
                    ? activitiy.description ?? ''
                    : activitiy.engDescription ?? '',
                style: CustomTextStyle.sf12w400(LightAppColors.blackSecondary)),
          ],
        ),
      ),
    );
  }
}
