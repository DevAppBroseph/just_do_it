import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Category extends StatefulWidget {
  const Category({super.key});

  @override
  State<Category> createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
          ),
          Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
          ),
          Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 20.w),
            child: const Text(
              'Название вашей задачи',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
           Container(
            height: 170.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
            alignment: Alignment.topLeft,
            padding: EdgeInsets.only(left: 20.w, top: 20),
            child: const Text(
              'Описание задачи',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
           Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.only(left: 10.w),
            child: const Text(
              'Прикрепить фото или документ',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
