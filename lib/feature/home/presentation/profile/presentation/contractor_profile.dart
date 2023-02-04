import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:scale_button/scale_button.dart';

class ContractorProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Icon(
            Icons.ac_unit_outlined,
            size: 50.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Marvin McKinney',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 30.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(width: 5.w),
              Icon(
                Icons.ac_unit_outlined,
                color: Colors.grey[400],
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: ScaleButton(
                  bound: 0.02,
                  child: Container(
                    height: 68.h,
                    padding: EdgeInsets.only(left: 10.w, right: 70.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Ваш рейтинг',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: ColorStyles.yellowFFD70A,
                              size: 16.h,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '5',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 20.sp,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 21.w),
              Expanded(
                child: ScaleButton(
                  bound: 0.02,
                  child: Container(
                    height: 68.h,
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ваши баллы',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  '900',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20.sp,
                                    color:
                                        const Color.fromARGB(255, 99, 25, 160),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Spacer(),
                        Icon(
                          Icons.man,
                          size: 25.h,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
          Text(
            'Общие настройки профиля',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 13.sp,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 20.h),
          ScaleButton(
            bound: 0.02,
            child: Container(
              height: 68.h,
              padding: EdgeInsets.only(left: 10.w, right: 70.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.portable_wifi_off_outlined,
                    color: Colors.black,
                    size: 25.h,
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Основная информация',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 11.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Имя, Телефон и E-mail',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          ScaleButton(
            bound: 0.02,
            child: Container(
              height: 68.h,
              padding: EdgeInsets.only(left: 10.w, right: 70.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.security,
                    color: Colors.black,
                    size: 25.h,
                  ),
                  SizedBox(width: 10.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Безопасность',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 11.sp,
                          color: Colors.grey[400],
                        ),
                      ),
                      SizedBox(height: 5.h),
                      Text(
                        'Пароль, паспортные данные, регион',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Stack(
            children: [
              ScaleButton(
                bound: 0.02,
                child: Container(
                  height: 40.h,
                  width: 190.w,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.document_scanner,
                        color: Colors.black,
                        size: 25.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Загрузить резюме (10мб)',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40.h),
          Text(
            'Ваши категории',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'Вы не выбрали ни одной категории',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 40.h),
          Text(
            'Описание вашего опыта',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w400,
              color: Colors.grey[400],
            ),
          ),
          SizedBox(height: 10.h),
          Container(
            height: 170.h,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r), color: Colors.white),
            child: Padding(
              padding: EdgeInsets.all(16..h),
              child: Column(
                children: [
                  SizedBox(
                    height: 99.h,
                    child: TextFormField(
                      decoration: const InputDecoration.collapsed(
                        hintText:
                            "Опишите свой опыт работы и прикрерите изображения",
                        border: InputBorder.none,
                      ),
                      controller: TextEditingController(),
                      maxLines: null,
                    ),
                  ),
                  SizedBox(height: 28.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '0/250',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w300,
                          color: Colors.grey[500],
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Stack(
            children: [
              ScaleButton(
                bound: 0.02,
                child: Container(
                  height: 40.h,
                  width: 190.w,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline,
                        color: Colors.black,
                        size: 25.h,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Изображения',
                        style: TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 13.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
