import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/helpers/router.dart';

class PersonalAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                children: [
                  Icon(
                    Icons.arrow_back,
                    color: Colors.grey[500],
                    size: 16.h,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Личный кабинет',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Icon(
                        Icons.notification_important_outlined,
                        color: Colors.grey[500],
                        size: 25.h,
                      ),
                      Container(
                        height: 10.w,
                        width: 10.w,
                        decoration: BoxDecoration(
                          color: yellow,
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
              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                          Icon(Icons.abc, size: 30.h),
                          SizedBox(width: 10.w),
                          Text(
                            'Профиль',
                            style: TextStyle(
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[500],
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
                        Icon(Icons.abc, size: 30.h),
                        SizedBox(width: 10.w),
                        Text(
                          'Баллы',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[500],
                          size: 16.h,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Row(
                      children: [
                        Icon(Icons.abc, size: 30.h),
                        SizedBox(width: 10.w),
                        Text(
                          'Рейтинг и отзывы',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[500],
                          size: 16.h,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    height: 50.h,
                    child: Row(
                      children: [
                        Icon(Icons.abc, size: 30.h),
                        SizedBox(width: 10.w),
                        Text(
                          'Выйти из аккаунта',
                          style: TextStyle(
                            fontSize: 17.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'Удалить аккаунт',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }
}
