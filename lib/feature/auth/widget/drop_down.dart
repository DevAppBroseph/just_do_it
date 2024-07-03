import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/user_reg.dart';

showIconModal(
  BuildContext context,
  GlobalKey key,
  Function(String) onTap,
  List<String> list,
  String label,
) async {
  iconSelectModal(
    context,
    getWidgetPosition(key),
    (index) {
      Navigator.pop(context);
      onTap(list[index]);
    },
    list,
    label,
  );
}

void iconSelectModal(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
  List<String> list,
  String label,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        ScrollController scrollController = ScrollController();
        return MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.0)),
          child: AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy, left: 20.h, right: 20.h),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 20.w,
              height: 200.h,
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.greyAccent,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 8.w),
                          child: Container(
                            color: Colors.transparent,
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      label,
                                      style: CustomTextStyle.sf17w400(
                                          Colors.grey[400]!),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 140.h,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: scrollController,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: list.length,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ElevatedButton(
                                    onPressed: () => onTap(index),
                                    style: ButtonStyle(
                                        padding: const WidgetStatePropertyAll(
                                            EdgeInsets.all(0)),
                                        backgroundColor: WidgetStatePropertyAll(
                                          SettingsScope.themeOf(context)
                                                      .theme
                                                      .mode ==
                                                  ThemeMode.dark
                                              ? DarkAppColors.blackSurface
                                              : LightAppColors.whitePrimary,
                                        ),
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        overlayColor:
                                            const WidgetStatePropertyAll(
                                                Colors.grey),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0.r)))),
                                    child: Padding(
                                      padding: EdgeInsets.only(left: 20.w),
                                      child: SizedBox(
                                        height: 50.h,
                                        child: Row(
                                          children: [
                                            Text(
                                              list[index],
                                              style: SettingsScope.themeOf(
                                                      context)
                                                  .theme
                                                  .getStyle(
                                                      (lightStyles) =>
                                                          lightStyles
                                                              .sf17w400BlackSec
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                      (darkStyles) => darkStyles
                                                          .sf17w400BlackSec)
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
          ),
        );
      },
    );

showIconModalCategories(
  BuildContext context,
  GlobalKey key,
  Function(List<String>) onTap,
  List<TaskCategory> list,
  String label,
  List<String> selectCategories,
) async {
  iconSelectModalCategories(
    context,
    onTap,
    getWidgetPosition(key),
    list,
    label,
    selectCategories,
  );
}

void iconSelectModalCategories(
  BuildContext context,
  Function(List<String>) onTap,
  Offset offset,
  List<TaskCategory> list,
  String label,
  List<String> selectCategories,
) {
  UserRegModel? user = BlocProvider.of<ProfileBloc>(context).user;
  showDialog(
    useSafeArea: false,
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      ScrollController scrollController = ScrollController();
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy, left: 20.h, right: 20.h),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 20.w,
              height: 200.h,
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.greyAccent,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 8.w),
                          child: Container(
                            color: Colors.transparent,
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      label,
                                      style: SettingsScope.themeOf(context)
                                          .theme
                                          .getStyle(
                                              (lightStyles) => lightStyles
                                                  .sf17w400BlackSec
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300),
                                              (darkStyles) =>
                                                  darkStyles.sf17w400BlackSec)
                                          .copyWith(
                                              fontWeight: FontWeight.w300),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 140.h,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: scrollController,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: list.length,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      if (selectCategories.length > 1) {
                                        if (selectCategories.length < 3) {
                                          if (selectCategories.contains(user
                                                      ?.rus ??
                                                  true &&
                                                      context.locale
                                                              .languageCode ==
                                                          'ru'
                                              ? list[index].description ?? ''
                                              : list[index].engDescription ??
                                                  '')) {
                                            selectCategories.remove(user?.rus ??
                                                    true &&
                                                        context.locale
                                                                .languageCode ==
                                                            'ru'
                                                ? list[index].description ?? ''
                                                : list[index].engDescription ??
                                                    '');
                                          } else {
                                            selectCategories.add(user?.rus ??
                                                    true &&
                                                        context.locale
                                                                .languageCode ==
                                                            'ru'
                                                ? list[index].description ?? ''
                                                : list[index].engDescription ??
                                                    '');
                                          }
                                        } else {
                                          if (selectCategories.contains(user
                                                      ?.rus ??
                                                  true &&
                                                      context.locale
                                                              .languageCode ==
                                                          'ru'
                                              ? list[index].description ?? ''
                                              : list[index].engDescription ??
                                                  '')) {
                                            selectCategories.remove(user?.rus ??
                                                    true &&
                                                        context.locale
                                                                .languageCode ==
                                                            'ru'
                                                ? list[index].description ?? ''
                                                : list[index].engDescription ??
                                                    '');
                                          }
                                        }
                                        onTap(selectCategories);
                                      } else if (selectCategories.isEmpty ||
                                          selectCategories.length == 1 &&
                                              !selectCategories.contains(user
                                                          ?.rus ??
                                                      true &&
                                                          context.locale
                                                                  .languageCode ==
                                                              'ru'
                                                  ? list[index].description ??
                                                      ''
                                                  : list[index]
                                                          .engDescription ??
                                                      '')) {
                                        selectCategories.add(user?.rus ??
                                                true &&
                                                    context.locale
                                                            .languageCode ==
                                                        'ru'
                                            ? list[index].description ?? ''
                                            : list[index].engDescription ?? '');
                                        onTap(selectCategories);
                                      }

                                      setState((() {}));
                                    },
                                    style: ButtonStyle(
                                        padding: const WidgetStatePropertyAll(
                                            EdgeInsets.all(0)),
                                        backgroundColor: WidgetStatePropertyAll(
                                          SettingsScope.themeOf(context)
                                                      .theme
                                                      .mode ==
                                                  ThemeMode.dark
                                              ? DarkAppColors.blackSurface
                                              : LightAppColors.whitePrimary,
                                        ),
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        overlayColor:
                                            const WidgetStatePropertyAll(
                                                Colors.grey),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0.r)))),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w, right: 20.w),
                                      child: SizedBox(
                                        height: 50.h,
                                        child: Row(
                                          children: [
                                            Text(
                                                user?.rus ??
                                                        true &&
                                                            context.locale
                                                                    .languageCode ==
                                                                'ru'
                                                    ? list[index].description!
                                                    : list[index]
                                                        .engDescription!,
                                                style: SettingsScope.themeOf(
                                                        context)
                                                    .theme
                                                    .getStyle(
                                                        (lightStyles) =>
                                                            lightStyles
                                                                .sf17w400BlackSec,
                                                        (darkStyles) => darkStyles
                                                            .sf17w400BlackSec)),
                                            const Spacer(),
                                            if (selectCategories.contains(user
                                                        ?.rus ??
                                                    true &&
                                                        context.locale
                                                                .languageCode ==
                                                            'ru'
                                                ? list[index].description ?? ''
                                                : list[index].engDescription ??
                                                    ''))
                                              Icon(
                                                Icons.check,
                                                color: SettingsScope.themeOf(
                                                                context)
                                                            .theme
                                                            .mode ==
                                                        ThemeMode.dark
                                                    ? DarkAppColors.whitePrimary
                                                    : DarkAppColors
                                                        .whitePrimary,
                                              )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
          );
        }),
      );
    },
  );
}

showCountry(
  BuildContext context,
  GlobalKey key,
  Function(Countries) onTap,
  List<Countries> list,
  String label,
) async {
  showCountryWidget(
    context,
    onTap,
    getWidgetPosition(key),
    list,
    label,
  );
}

void showCountryWidget(
  BuildContext context,
  Function(Countries) onTap,
  Offset offset,
  List<Countries> list,
  String label,
) {
  UserRegModel? user = BlocProvider.of<ProfileBloc>(context).user;
  showDialog(
    useSafeArea: false,
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      ScrollController scrollController = ScrollController();
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy, left: 20.h, right: 20.h),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 20.w,
              height: list.length < 3
                  ? (list.isEmpty ? 1 : list.length) * 50.h + 50.h
                  : 200.h,
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.greyAccent,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 8.w),
                          child: Container(
                            color: Colors.transparent,
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      label,
                                      style: CustomTextStyle.sf17w400(
                                          Colors.grey[400]!),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: list.length < 3
                                ? (list.isEmpty ? 1 : list.length) * 50.h
                                : 150.h,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: scrollController,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: list.length,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      onTap(list[index]);
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                        padding: const WidgetStatePropertyAll(
                                            EdgeInsets.all(0)),
                                        backgroundColor: WidgetStatePropertyAll(
                                          SettingsScope.themeOf(context)
                                                      .theme
                                                      .mode ==
                                                  ThemeMode.dark
                                              ? DarkAppColors.blackSurface
                                              : LightAppColors.whitePrimary,
                                        ),
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        overlayColor:
                                            const WidgetStatePropertyAll(
                                                Colors.grey),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0.r)))),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w, right: 20.w),
                                      child: SizedBox(
                                        height: 50.h,
                                        child: Row(
                                          children: [
                                            Text(
                                              user?.rus ??
                                                      true &&
                                                          context.locale
                                                                  .languageCode ==
                                                              'ru'
                                                  ? list[index].name ?? "-"
                                                  : list[index].engName ?? "-",
                                              style: SettingsScope.themeOf(
                                                      context)
                                                  .theme
                                                  .getStyle(
                                                      (lightStyles) =>
                                                          lightStyles
                                                              .sf17w400BlackSec
                                                              .copyWith(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w300),
                                                      (darkStyles) => darkStyles
                                                          .sf17w400BlackSec)
                                                  .copyWith(
                                                      fontWeight:
                                                          FontWeight.w300),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
          );
        }),
      );
    },
  );
}

showRegion(
  BuildContext context,
  GlobalKey key,
  Function(Regions) onTap,
  List<Regions> list,
  String label,
) async {
  showRegionWidget(
    context,
    onTap,
    getWidgetPosition(key),
    list,
    label,
  );
}

void showRegionWidget(
  BuildContext context,
  Function(Regions) onTap,
  Offset offset,
  List<Regions> list,
  String label,
) {
  UserRegModel? user = BlocProvider.of<ProfileBloc>(context).user;

  showDialog(
    useSafeArea: false,
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      ScrollController scrollController = ScrollController();
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy, left: 20.h, right: 20.h),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 20.w,
              height: list.length < 3
                  ? (list.isEmpty ? 1 : list.length) * 50.h + 50.h
                  : 200.h,
              decoration: BoxDecoration(
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.greyAccent,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 8.w),
                          child: Container(
                            color: Colors.transparent,
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      label,
                                      style: CustomTextStyle.sf17w400(
                                          Colors.grey[400]!),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: list.length < 3
                                ? (list.isEmpty ? 1 : list.length) * 50.h
                                : 150.h,
                            child: Scrollbar(
                              thumbVisibility: true,
                              controller: scrollController,
                              child: ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                itemCount: list.length,
                                padding: EdgeInsets.zero,
                                physics: const BouncingScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return ElevatedButton(
                                    onPressed: () {
                                      onTap(list[index]);
                                      Navigator.of(context).pop();
                                    },
                                    style: ButtonStyle(
                                        padding: const WidgetStatePropertyAll(
                                            EdgeInsets.all(0)),
                                        backgroundColor: WidgetStatePropertyAll(
                                          SettingsScope.themeOf(context)
                                                      .theme
                                                      .mode ==
                                                  ThemeMode.dark
                                              ? DarkAppColors.blackSurface
                                              : LightAppColors.whitePrimary,
                                        ),
                                        elevation:
                                            const WidgetStatePropertyAll(0),
                                        overlayColor:
                                            const WidgetStatePropertyAll(
                                                Colors.grey),
                                        shape: WidgetStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        0.r)))),
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                          left: 20.w, right: 20.w),
                                      child: SizedBox(
                                        height: 50.h,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 250.w,
                                              child: Text(
                                                user?.rus ??
                                                        true &&
                                                            context.locale
                                                                    .languageCode ==
                                                                'ru'
                                                    ? list[index].name ?? '-'
                                                    : list[index].engName ??
                                                        '-',
                                                style: SettingsScope.themeOf(
                                                        context)
                                                    .theme
                                                    .getStyle(
                                                        (lightStyles) => lightStyles
                                                            .sf17w400BlackSec
                                                            .copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w300),
                                                        (darkStyles) => darkStyles
                                                            .sf17w400BlackSec)
                                                    .copyWith(
                                                        fontWeight:
                                                            FontWeight.w300),
                                                maxLines: null,
                                              ),
                                            ),
                                            const Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
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
          );
        }),
      );
    },
  );
}
