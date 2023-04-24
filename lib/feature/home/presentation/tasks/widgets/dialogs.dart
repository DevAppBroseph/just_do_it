import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/text_style.dart';

void iconSelectTranslate(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding: EdgeInsets.only(
                top: offset.dy - 10.h, left: offset.dx - 150.w, right: 20.w),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              onTap: onTap(0),
              child: Container(
                width: MediaQuery.of(context).size.width - 30.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    )
                  ],
                  borderRadius: BorderRadius.circular(15.r),
                ),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        padding: EdgeInsets.all(10.h),
                        height: 40.h,
                        alignment: Alignment.center,
                        child: Text(
                          'Показать оригинал',
                          style: CustomTextStyle.black_16_w500_000000,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );

void taskMoreDialog(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
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
                EdgeInsets.only(top: offset.dy + 20.h, left: offset.dx - 95.w),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: GestureDetector(
              onTap: onTap(0),
              child: Stack(
                children: [
                  Container(
                    width: 115.w,
                    height: 72.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        )
                      ],
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 18.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Поделиться',
                            style: CustomTextStyle.black_12_w400_292D32,
                          ),
                          Text(
                            'Пожаловаться',
                            style: CustomTextStyle.black_12_w400_292D32,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
