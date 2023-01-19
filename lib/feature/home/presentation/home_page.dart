import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/chat_page.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/create_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile_page.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/search_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/presentation/tasks_page.dart';

class HomePage extends StatelessWidget {
  PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [
          CreatePage(),
          SearchPage(),
          TasksPage(),
          ChatPage(),
          ProfilePage(),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 90.h,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                pageController.jumpToPage(0);
              },
              child: Container(
                width: 70.w,
                height: 80.h,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle_rounded,
                      size: 22.h,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Создать',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                pageController.jumpToPage(1);
              },
              child: Container(
                width: 70.w,
                height: 80.h,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search,
                      size: 22.h,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Найти',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                pageController.jumpToPage(2);
              },
              child: Container(
                width: 70.w,
                height: 80.h,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.list_alt_rounded,
                      size: 22.h,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Задания',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                pageController.jumpToPage(3);
              },
              child: Container(
                width: 70.w,
                height: 80.h,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.chat,
                      size: 22.h,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Чат',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                pageController.jumpToPage(4);
              },
              child: Container(
                width: 70.w,
                height: 80.h,
                color: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.supervised_user_circle_rounded,
                      size: 22.h,
                    ),
                    SizedBox(height: 5.h),
                    Text(
                      'Кабинет',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
