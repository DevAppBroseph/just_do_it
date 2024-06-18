import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/score/bloc_score/score_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/widgets/grade_mascot_image.dart';
import 'package:just_do_it/feature/home/presentation/search_list.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/language.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';

class WelcomPage extends StatefulWidget {
  final Function(int) onSelect;

  const WelcomPage(this.onSelect, {super.key});

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  bool state = true;
  int indexLanguage = 0;
  int index = 0;
  String choiceLanguage = '';
  bool searchList = false;
  List<String> searchChoose = [];
  bool openLanguage = false;
  List<Language> listLanguage = [
    Language(icon: 'assets/images/england.png', title: 'EN', id: 2),
    Language(icon: 'assets/icons/russia.svg', title: 'RU', id: 1),
  ];
  String selectLanguage = 'EN';
  Language? selectLenguage;
  TextEditingController searchController = TextEditingController();
  ScrollController controller = ScrollController();

  // Future<void> notificationInit() async {
  //   await NotificationService().inject();
  // }

  int? proverkaBalance;
  String? access;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(GetCategoriesEvent());
    // notificationInit();
    getScore();
  }

  void getScore() async {
    String? access = BlocProvider.of<ProfileBloc>(context).access;
    context.read<ScoreBloc>().add(GetScoreEvent(access));
    BlocProvider.of<RatingBloc>(context).add(GetRatingEvent(access));
  }

  void getHistoryList() async {
    final List<String> list = await Storage().getListHistory();
    final List<String> listReversed = list.reversed.toList();
    searchChoose.clear();
    searchChoose.addAll(listReversed);
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        UserRegModel? user = BlocProvider.of<ProfileBloc>(context).user;
        if (user?.rus != null) {
          if (user!.rus!) {
            selectLanguage = 'RU';
            context.setLocale(const Locale('ru', 'RU'));
            BlocProvider.of<ChatBloc>(context).add(UpdateMenuEvent());
          } else {
            selectLanguage = 'EN';
            context.setLocale(const Locale('en', 'US'));
            BlocProvider.of<ChatBloc>(context).add(UpdateMenuEvent());
          }
        } else {
          // Initialize with English if no user preference
          selectLanguage = 'EN';
          context.setLocale(const Locale('en', 'US'));
          BlocProvider.of<ChatBloc>(context).add(UpdateMenuEvent());
        }
        return MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: LightAppColors.greyPrimary,
                    boxShadow: [
                      BoxShadow(
                        color: LightAppColors.shadowPrimary,
                        offset: const Offset(0, -4),
                        blurRadius: 55.r,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 60.h,
                        color: LightAppColors.greyPrimary,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 25.w, right: 28.w),
                        child: Row(
                          children: [
                            searchList
                                ? const SizedBox()
                                : SizedBox(
                                    width: 87.w,
                                    height: 40.h,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: LightAppColors.whitePrimary,
                                        borderRadius:
                                            BorderRadius.circular(10.r),
                                      ),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left: 5.w),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                value: selectLanguage,
                                                icon: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 5.w),
                                                  child: const Icon(
                                                    Icons
                                                        .keyboard_arrow_down_rounded,
                                                    color: LightAppColors
                                                        .greySecondary,
                                                  ),
                                                ),
                                                onChanged: (value) async {
                                                  if (value == 'RU') {
                                                    context.setLocale(
                                                        const Locale(
                                                            'ru', 'RU'));
                                                    if (user != null) {
                                                      user!.rus = true;
                                                      user = await Repository()
                                                          .editRusProfile(
                                                              BlocProvider.of<
                                                                          ProfileBloc>(
                                                                      context)
                                                                  .access,
                                                              true);
                                                    }
                                                  } else if (value == 'EN') {
                                                    context.setLocale(
                                                        const Locale(
                                                            'en', 'US'));
                                                    if (user != null) {
                                                      user!.rus = false;
                                                      user = await Repository()
                                                          .editRusProfile(
                                                              BlocProvider.of<
                                                                          ProfileBloc>(
                                                                      context)
                                                                  .access,
                                                              false);
                                                    }
                                                  }
                                                },
                                                items: listLanguage.map<
                                                    DropdownMenuItem<
                                                        String>>((e) {
                                                  return DropdownMenuItem<
                                                          String>(
                                                      value: e.title,
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: 20.h,
                                                            width: 25.w,
                                                            child: e.title ==
                                                                    'EN'
                                                                ? Image.asset(
                                                                    e.icon)
                                                                : SvgPicture
                                                                    .asset(
                                                                        e.icon),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5.w),
                                                            child:
                                                                Text(e.title),
                                                          ),
                                                        ],
                                                      ));
                                                }).toList(),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                            // SizedBox(
                            //     height: 40,
                            //     width: 102.w,
                            //     child: Column(
                            //       children: [
                            //         ScaleButton(
                            //           onTap: () {
                            //             setState(() {
                            //               openLanguage = true;
                            //             });
                            //           },
                            //           child: Container(
                            //             height: 36.h,
                            //             width: 102.w,
                            //             padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                            //             decoration: BoxDecoration(
                            //               color: ColorStyles.whiteFFFFFF,
                            //               borderRadius: BorderRadius.circular(10.r),
                            //             ),
                            //             child: Row(
                            //               children: [
                            //                 SvgPicture.asset(listLanguage.first.icon),
                            //                 const Spacer(),
                            //                 Text(
                            //                   listLanguage.first.title,
                            //                   style: CustomTextStyle.CustomTextStyle.sf17w600(AppColors.blackSecondary),
                            //                 ),
                            //                 const Spacer(),
                            //                 const Icon(
                            //                   Icons.keyboard_arrow_down_rounded,
                            //                   color: ColorStyles.greyBDBDBD,
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //         ),

                            // if (openLanguage)
                            //   AnimatedContainer(
                            //     duration: const Duration(milliseconds: 300),
                            //     height: openLanguage ? 50 : 0.h,
                            //     decoration: BoxDecoration(
                            //       color: ColorStyles.whiteFFFFFF,
                            //       borderRadius: BorderRadius.circular(10.r),
                            //       boxShadow: [
                            //         BoxShadow(
                            //           color: ColorStyles.shadowFC6554,
                            //           offset: const Offset(0, -4),
                            //           blurRadius: 55.r,
                            //         )
                            //       ],
                            //     ),
                            //     padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                            //     child: Scrollbar(
                            //       thumbVisibility: true,
                            //       controller: _languageController,
                            //       child: Column(
                            //         children: listLanguage
                            //             .map(
                            //               (e) => Padding(
                            //                 padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            //                 child: GestureDetector(
                            //                   onTap: () {
                            //                     if (e.id == selectLenguage?.id) {
                            //                       selectLenguage = null;
                            //                     } else {
                            //                       selectLenguage = e;
                            //                     }
                            //                     openLanguage = false;

                            //                     setState(() {});
                            //                   },
                            //                   child: Container(
                            //                     color: Colors.transparent,
                            //                     height: 20.h,
                            //                     child: Column(
                            //                       mainAxisAlignment: MainAxisAlignment.center,
                            //                       children: [
                            //                         Row(
                            //                           children: [
                            //                             SizedBox(
                            //                               width: 250.w,
                            //                               child: Text(
                            //                                 e.title,
                            //                                 style: CustomTextStyle.black_14_w400_515150,
                            //                               ),
                            //                             ),
                            //                           ],
                            //                         ),
                            //                       ],
                            //                     ),
                            //                   ),
                            //                 ),
                            //               ),
                            //             )
                            //             .toList(),
                            //       ),
                            //     ),
                            //   ),
                            //     ],
                            //   ),
                            // ),
                            searchList ? const SizedBox() : const Spacer(),
                            user == null
                                ? const SizedBox()
                                : searchList
                                    ? const SizedBox()
                                    : Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  AppRoute.notification);
                                            },
                                            child: Stack(
                                              alignment: Alignment.topRight,
                                              children: [
                                                SvgPicture.asset(
                                                  'assets/icons/notification_main.svg',
                                                ),
                                                user!.hasNotifications!
                                                    ? Container(
                                                        height: 10.w,
                                                        width: 10.w,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: LightAppColors
                                                              .yellowSecondary,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      20.r),
                                                        ),
                                                      )
                                                    : Container(),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: 12.w),
                                        ],
                                      ),
                            searchList
                                ? Row(
                                    children: [
                                      CustomIconButton(
                                        onBackPressed: () {
                                          setState(() {
                                            searchList = false;
                                          });
                                        },
                                        icon: SvgImg.arrowRight,
                                      ),
                                      SizedBox(
                                        width: 230.w,
                                        height: 36.h,
                                        child: CustomTextField(
                                          onTap: () async {
                                            setState(() {
                                              searchList = true;
                                            });
                                            getHistoryList();
                                          },
                                          fillColor: LightAppColors.greyAccent,
                                          prefixIcon: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              SvgPicture.asset(
                                                'assets/icons/search1.svg',
                                                height: 12.h,
                                              ),
                                            ],
                                          ),
                                          onFieldSubmitted: (value) {
                                            setState(() {
                                              searchList = false;
                                            });
                                            Storage().setListHistory(value);
                                            FocusScope.of(context).unfocus();
                                            BlocProvider.of<ProfileBloc>(
                                                    context)
                                                .add(EditPageSearchEvent(
                                                    1, value));
                                          },
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              getHistoryList();
                                            }
                                            List<TaskCategory> activities =
                                                BlocProvider.of<ProfileBloc>(
                                                        context)
                                                    .activities;
                                            searchChoose.clear();
                                            if (value.isNotEmpty) {
                                              for (var element1 in activities) {
                                                for (var element2
                                                    in element1.subcategory) {
                                                  if (element2.description!
                                                          .toLowerCase()
                                                          .contains(value
                                                              .toLowerCase()) &&
                                                      !searchChoose.contains(
                                                          element2.description!
                                                              .toLowerCase())) {
                                                    searchChoose.add(
                                                        element2.description!);
                                                  }
                                                }
                                              }
                                            }
                                            setState(() {});
                                          },
                                          hintText: 'search'.tr(),
                                          textEditingController:
                                              searchController,
                                          contentPadding: EdgeInsets.symmetric(
                                              horizontal: 11.w, vertical: 11.h),
                                        ),
                                      ),
                                    ],
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        searchList = true;
                                      });
                                      getHistoryList();
                                    },
                                    child: SvgPicture.asset(
                                        'assets/icons/search3.svg'),
                                  ),
                            SizedBox(width: 12.w),
                            GestureDetector(
                              onTap: () {
                                if (Storage.isAuthorized) {
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.menu, arguments: [
                                    (page) {},
                                    false,
                                  ]).then((value) {
                                    if (value != null) {
                                      if (value == 'create') {
                                        widget.onSelect(0);
                                      }
                                      if (value == 'search') {
                                        widget.onSelect(1);
                                      } else if (value == 'tasks') {
                                        widget.onSelect(2);
                                      }
                                      if (value == 'chat') {
                                        widget.onSelect(3);
                                      }
                                    }
                                  });
                                } else {
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.auth);
                                }
                              },
                              child: SvgPicture.asset(
                                  'assets/icons/category2.svg'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                searchList
                    ? SearchList(
                        heightScreen,
                        bottomInsets,
                        (value) {
                          Storage().setListHistory(value);
                          BlocProvider.of<ProfileBloc>(context)
                              .add(EditPageSearchEvent(1, value));
                        },
                        searchChoose,
                      )
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 0.h),
                          child: Container(
                            color: LightAppColors.greyPrimary,
                            child: ListView(
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Container(
                                    height: 30.h,
                                    color: LightAppColors.greyPrimary),
                                BlocBuilder<ProfileBloc, ProfileState>(
                                  builder: (context, snapshot) {
                                    final bloc =
                                        BlocProvider.of<ProfileBloc>(context);
                                    if (bloc.user == null) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 80.w),
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                              top: 40.h, bottom: 22.h),
                                          child: Center(
                                            child: Text(
                                              'jobyfine'.toUpperCase(),
                                              style: CustomTextStyle.sf22w700(
                                                      LightAppColors
                                                          .blackSecondary)
                                                  .copyWith(
                                                fontSize: 39,
                                                fontWeight: FontWeight.w900,
                                                fontFamily: 'SFBold',
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20.w, vertical: 20.h),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context)
                                              .pushNamed(AppRoute.profile);
                                        },
                                        child: Container(
                                          height: 200.h,
                                          decoration: BoxDecoration(
                                            color: LightAppColors.whitePrimary,
                                            borderRadius:
                                                BorderRadius.circular(30.r),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    right: 10.w,
                                                    left: 30.w,
                                                    top: 15.h),
                                                child: SizedBox(
                                                  height: 100.h,
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        height: 70.h,
                                                        width: 70.w,
                                                        child: Stack(
                                                          alignment:
                                                              Alignment.center,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                var image = await ImagePicker()
                                                                    .pickImage(
                                                                        source:
                                                                            ImageSource.gallery);
                                                                if (image !=
                                                                    null) {
                                                                  if (!context
                                                                      .mounted) {
                                                                    return;
                                                                  }
                                                                  BlocProvider.of<
                                                                              ProfileBloc>(
                                                                          context)
                                                                      .add(
                                                                    UpdateProfilePhotoEvent(
                                                                        photo:
                                                                            image),
                                                                  );
                                                                }
                                                              },
                                                              child: ClipOval(
                                                                child: SizedBox.fromSize(
                                                                    size: Size.fromRadius(40.r),
                                                                    child: user?.photoLink == null
                                                                        ? Container(
                                                                            height:
                                                                                60.h,
                                                                            width:
                                                                                60.w,
                                                                            padding:
                                                                                EdgeInsets.all(10.h),
                                                                            decoration:
                                                                                const BoxDecoration(
                                                                              color: LightAppColors.shadowPrimary,
                                                                            ),
                                                                            child:
                                                                                Image.asset('assets/images/camera.png'),
                                                                          )
                                                                        : CachedNetworkImage(
                                                                            imageUrl: user!.photoLink!.contains(server)
                                                                                ? user!.photoLink!
                                                                                : server + user!.photoLink!,
                                                                            fit:
                                                                                BoxFit.cover,
                                                                          )),
                                                              ),
                                                            ),
                                                            if (user?.photoLink !=
                                                                null)
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    GestureDetector(
                                                                  onTap: () {
                                                                    user!.photo =
                                                                        null;
                                                                    user!.photoLink =
                                                                        null;
                                                                    BlocProvider.of<ProfileBloc>(
                                                                            context)
                                                                        .setUser(
                                                                            user);
                                                                    BlocProvider.of<ProfileBloc>(
                                                                            context)
                                                                        .add(
                                                                      UpdateProfilePhotoEvent(
                                                                          photo:
                                                                              null),
                                                                    );
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        20.h,
                                                                    width: 20.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      boxShadow: const [
                                                                        BoxShadow(
                                                                            color:
                                                                                Colors.black)
                                                                      ],
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              100.r),
                                                                      color: Colors
                                                                          .white,
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        size: 10
                                                                            .h,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 20.w),
                                                        child: SizedBox(
                                                          width: 190.w,
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                'welcome_back'
                                                                    .tr(),
                                                                style: CustomTextStyle
                                                                    .sf13w400(
                                                                        LightAppColors
                                                                            .greySecondary),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: null,
                                                              ),
                                                              SizedBox(
                                                                  height: 8.h),
                                                              AutoSizeText(
                                                                '${bloc.user?.firstname} ${bloc.user?.lastname}',
                                                                wrapWords:
                                                                    false,
                                                                style: CustomTextStyle.sf19w800(
                                                                        LightAppColors
                                                                            .greySecondary)
                                                                    .copyWith(
                                                                        fontSize:
                                                                            24),
                                                                maxLines: 2,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              BlocBuilder<RatingBloc,
                                                      RatingState>(
                                                  builder: (context, snapshot) {
                                                var reviews =
                                                    BlocProvider.of<RatingBloc>(
                                                            context)
                                                        .reviews;
                                                return Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                AppRoute.score);
                                                      },
                                                      child: SizedBox(
                                                        // height: 68.h,
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          2.5.h),
                                                              child:
                                                                  ScaleButton(
                                                                onTap: () {
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushNamed(
                                                                          AppRoute
                                                                              .score);
                                                                },
                                                                bound: 0.02.r,
                                                                child:
                                                                    Container(
                                                                  height: 25.h,
                                                                  width: 70.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: LightAppColors
                                                                        .greyPrimary,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30.r),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      'grades'
                                                                          .tr(),
                                                                      style: CustomTextStyle.sf12w400(
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
                                                                BlocBuilder<
                                                                        ScoreBloc,
                                                                        ScoreState>(
                                                                    buildWhen:
                                                                        (previous,
                                                                            current) {
                                                                  if (user!
                                                                          .allbalance! ==
                                                                      proverkaBalance) {
                                                                    return false;
                                                                  }
                                                                  return true;
                                                                }, builder: (context,
                                                                        state) {
                                                                  if (state
                                                                      is ScoreLoaded) {
                                                                    proverkaBalance = bloc
                                                                        .user!
                                                                        .allbalance!;
                                                                    final levels =
                                                                        state
                                                                            .levels;
                                                                    return GradeMascotImage(
                                                                      levels:
                                                                          levels,
                                                                      user:
                                                                          user,
                                                                    );
                                                                  }
                                                                  return Container();
                                                                }),
                                                                SizedBox(
                                                                  width: 4.w,
                                                                ),
                                                                Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  constraints:
                                                                      BoxConstraints(
                                                                    minHeight:
                                                                        30.h,
                                                                  ),
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          bottom:
                                                                              0.5.h),
                                                                  child: Text(
                                                                    bloc.user
                                                                            ?.balance
                                                                            .toString() ??
                                                                        '0',
                                                                    style: CustomTextStyle.sf17w400(
                                                                        LightAppColors
                                                                            .purplePrimary),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: 20.w,
                                                    ),
                                                    GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(AppRoute
                                                                .rating);
                                                      },
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        7.5.h),
                                                            child: ScaleButton(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        AppRoute
                                                                            .rating);
                                                              },
                                                              bound: 0.02,
                                                              child: Container(
                                                                height: 25.h,
                                                                width: 90.w,
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
                                                                            LightAppColors.yellowBackground),
                                                                      ),
                                                                      SizedBox(
                                                                          width:
                                                                              3.w),
                                                                      Row(
                                                                        children: [
                                                                          SizedBox(
                                                                            width:
                                                                                12.w,
                                                                            height:
                                                                                12.h,
                                                                            child:
                                                                                SvgPicture.asset(
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
                                                                    bottom:
                                                                        4.h),
                                                            child: SizedBox(
                                                              child: Text(
                                                                reviews?.ranking ==
                                                                        null
                                                                    ? '0'
                                                                    : reviews!
                                                                        .ranking!
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
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(AppRoute
                                                                .rating);
                                                      },
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        17.h),
                                                            child: ScaleButton(
                                                              onTap: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pushNamed(
                                                                        AppRoute
                                                                            .rating);
                                                              },
                                                              bound: 0.02,
                                                              child: Container(
                                                                height: 25.h,
                                                                width: 75.w,
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
                                                                    'reviews'
                                                                        .tr(),
                                                                    style: CustomTextStyle.sf12w400(
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
                                                                    bottom:
                                                                        4.0.h),
                                                            child: SizedBox(
                                                              child: Text(
                                                                reviews?.reviewsDetail ==
                                                                        null
                                                                    ? ''
                                                                    : reviews!
                                                                        .reviewsDetail
                                                                        .length
                                                                        .toString(),
                                                                style: CustomTextStyle
                                                                    .sf17w400(
                                                                        LightAppColors
                                                                            .blueSecondary),
                                                                textAlign:
                                                                    TextAlign
                                                                        .left,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 24.w),
                                  child: Row(
                                    children: [
                                      Text('see_how'.tr(),
                                          style: CustomTextStyle.sf19w800(
                                              LightAppColors.blackSecondary)),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  child: Row(
                                    children: [
                                      ScaleButton(
                                        bound: 0.02,
                                        onTap: () => widget.onSelect(0),
                                        child: Container(
                                          height: ((MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  47) /
                                              100),
                                          width: ((MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      47) /
                                                  100) -
                                              25.w,
                                          decoration: BoxDecoration(
                                            color: LightAppColors.whitePrimary,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: LightAppColors
                                                    .shadowPrimary,
                                                offset: const Offset(0, 4),
                                                blurRadius: 45.r,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 20.h,
                                                    left: 40.w,
                                                    top: 20.h),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Image.asset(
                                                    'assets/images/contractor1.png',
                                                    height: 90.h,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'customer'.tr(),
                                                          style: CustomTextStyle
                                                                  .sf17w400(
                                                                      LightAppColors
                                                                          .blackSecondary)
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.w,
                                                                  top: 3.h),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: LightAppColors
                                                                .greySecondary,
                                                            size: 12.h,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      'post_the_task'.tr(),
                                                      style: CustomTextStyle
                                                          .sf13w400(LightAppColors
                                                              .greySecondary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      ScaleButton(
                                        bound: 0.02,
                                        onTap: () => widget.onSelect(1),
                                        child: Container(
                                          height: ((MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  47) /
                                              100),
                                          width: ((MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      47) /
                                                  100) -
                                              25.w,
                                          decoration: BoxDecoration(
                                            color: LightAppColors.whitePrimary,
                                            borderRadius:
                                                BorderRadius.circular(10.r),
                                            boxShadow: [
                                              BoxShadow(
                                                color: LightAppColors
                                                    .shadowPrimary,
                                                offset: const Offset(0, 4),
                                                blurRadius: 45.r,
                                              )
                                            ],
                                          ),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 17.h,
                                                    left: 32.w,
                                                    top: 23.h),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Image.asset(
                                                    'assets/images/customer1.png',
                                                    height: 90.h,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(left: 20.w),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'executor'.tr(),
                                                          style: CustomTextStyle
                                                                  .sf17w400(
                                                                      LightAppColors
                                                                          .blackSecondary)
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 10.w,
                                                                  top: 3.h),
                                                          child: Icon(
                                                            Icons
                                                                .arrow_forward_ios,
                                                            color: LightAppColors
                                                                .greySecondary,
                                                            size: 12.h,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      'get_the_job_done'.tr(),
                                                      style: CustomTextStyle
                                                          .sf13w400(LightAppColors
                                                              .greySecondary),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20.h),
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 25.w),
                                  child: ScaleButton(
                                    duration: const Duration(milliseconds: 50),
                                    bound: 0.01,
                                    child: SizedBox(
                                      height: 65.h,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          SizedBox(
                                            height: 45.h,
                                            child: CupertinoCard(
                                              onPressed: () {
                                                showLoaderWrapperWhite(context);
                                                Navigator.of(context)
                                                    .pushNamed(AppRoute.about);
                                                Future.delayed(
                                                    const Duration(seconds: 1),
                                                    () {
                                                  Loader.hide();
                                                });
                                              },
                                              radius:
                                                  BorderRadius.circular(25.r),
                                              color:
                                                  LightAppColors.yellowPrimary,
                                              margin: EdgeInsets.zero,
                                              elevation: 0,
                                              decoration: BoxDecoration(
                                                color: LightAppColors
                                                    .yellowPrimary,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: LightAppColors
                                                        .shadowPrimary,
                                                    offset: const Offset(0, -4),
                                                    blurRadius: 55.r,
                                                  )
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 10.w),
                                                child: Row(
                                                  children: [
                                                    const Spacer(),
                                                    Text(
                                                      'find_out_more_about_the_project'
                                                          .tr(),
                                                      style: CustomTextStyle
                                                          .sf17w600(LightAppColors
                                                              .blackSecondary),
                                                    ),
                                                    const Spacer(),
                                                    SvgPicture.asset(
                                                        'assets/icons/arrow-right1.svg')
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex,
      {String choice = ''}) {
    return SizedBox(
      height: 20.h,
      width: 100.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: ScaleButton(
          bound: 0.02,
          onTap: () => setState(() {
            if (indexLanguage != currentIndex) {
              indexLanguage = currentIndex;
            } else {
              indexLanguage = 0;
            }
          }),
          child: Container(
            decoration: BoxDecoration(
              color: LightAppColors.whitePrimary,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: LightAppColors.shadowPrimary,
                  offset: const Offset(0, -4),
                  blurRadius: 55.r,
                )
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
            child: Row(
              children: [
                Image.asset(
                  icon,
                  height: 20.h,
                ),
                SizedBox(width: 9.w),
                Text(
                  title,
                  style: CustomTextStyle.sf17w400(LightAppColors.blackAccent),
                ),
                if (choice.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2.w),
                    child: SizedBox(
                      width: 100.w,
                      child: Text(
                        '- $choice',
                        style: CustomTextStyle.sf15w400(
                            LightAppColors.greySecondary),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ),
                const Spacer(),
                index == currentIndex
                    ? const Icon(
                        Icons.keyboard_arrow_up,
                        color: Colors.blue,
                      )
                    : Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[400],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget info(List<String> list, bool open) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: open ? 80.h : 0.h,
        decoration: BoxDecoration(
          color: LightAppColors.whitePrimary,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.zero,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          children: list.map((e) => item(e)).toList(),
        ),
      ),
    );
  }

  Widget item(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          indexLanguage = 0;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 8.w),
        child: Container(
          color: Colors.transparent,
          height: 40.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: CustomTextStyle.sf17w400(LightAppColors.blackAccent),
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
