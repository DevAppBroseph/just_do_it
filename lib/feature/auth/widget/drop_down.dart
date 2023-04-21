import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
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
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                color: Colors.white,
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
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
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
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: list.length,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () => onTap(index),
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(0)),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      overlayColor:
                                          const MaterialStatePropertyAll(
                                              Colors.grey),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.r)))),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        children: [
                                          Text(
                                            list[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w300,
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
  List<Activities> list,
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
  List<Activities> list,
  String label,
  List<String> selectCategories,
) {
  showDialog(
    useSafeArea: false,
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
                color: Colors.white,
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
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
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
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: list.length,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () {
                                    log('message ${selectCategories.length}');
                                    if (selectCategories.length > 1) {
                                      if (selectCategories.length < 3) {
                                        if (selectCategories.contains(
                                            list[index].description)) {
                                          selectCategories.remove(
                                              list[index].description ?? '');
                                        } else {
                                          selectCategories.add(
                                              list[index].description ?? '');
                                        }
                                      } else {
                                        if (selectCategories.contains(
                                            list[index].description)) {
                                          selectCategories
                                              .remove(list[index].description);
                                        }
                                      }
                                      onTap(selectCategories);
                                    } else if (selectCategories.isEmpty ||
                                        selectCategories.length == 1 &&
                                            !selectCategories.contains(
                                                list[index].description)) {
                                      selectCategories
                                          .add(list[index].description ?? '');
                                      onTap(selectCategories);
                                    }

                                    setState((() {}));
                                  },
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(0)),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      overlayColor:
                                          const MaterialStatePropertyAll(
                                              Colors.grey),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.r)))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w, right: 20.w),
                                    child: SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        children: [
                                          Text(
                                            list[index].description!,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                          if (selectCategories.contains(
                                              list[index].description!))
                                            const Icon(
                                              Icons.check,
                                              color: Colors.black,
                                            )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
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
  Function(String) onTap,
  List<String> list,
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
  Function(String) onTap,
  Offset offset,
  List<String> list,
  String label,
) {
  showDialog(
    useSafeArea: false,
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.white,
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
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
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
                            height: 130.h,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: list.length,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () {
                                    onTap(list[index]);
                                    Navigator.of(context).pop();

                                    // setState((() {}));
                                  },
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(0)),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      overlayColor:
                                          const MaterialStatePropertyAll(
                                              Colors.grey),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.r)))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w, right: 20.w),
                                    child: SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        children: [
                                          Text(
                                            list[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w300,
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
  Function(String) onTap,
  List<String> list,
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
  Function(String) onTap,
  Offset offset,
  List<String> list,
  String label,
) {
  showDialog(
    useSafeArea: false,
    barrierColor: Colors.transparent,
    context: context,
    builder: (context) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
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
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.white,
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
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
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
                            height: 130.h,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: list.length,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () {
                                    onTap(list[index]);
                                    Navigator.of(context).pop();

                                    // setState((() {}));
                                  },
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(0)),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      overlayColor:
                                          const MaterialStatePropertyAll(
                                              Colors.grey),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.r)))),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 20.w, right: 20.w),
                                    child: SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        children: [
                                          Text(
                                            list[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w300,
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
