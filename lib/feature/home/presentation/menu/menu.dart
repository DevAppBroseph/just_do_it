import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class MenuPage extends StatelessWidget {
  final Function(String page) onBackPressed;
  bool inTask;

  MenuPage({
    required this.onBackPressed,
    required this.inTask,
  });

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 66.h),
            Padding(
              padding: EdgeInsets.only(left: 25.w, right: 28.w),
              child: Row(
                children: [
                  Text(
                    'Меню',
                    style: CustomTextStyle.black_22_w700,
                  ),
                  const Spacer(),
                  SizedBox(width: 23.w),
                  CustomIconButton(
                    onBackPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: 'assets/icons/close.svg',
                  ),
                ],
              ),
            ),
            SizedBox(height: 29.h),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                children: [
                  itemMenu('assets/icons/add_circle.svg', 'Создать задание',
                      () {
                    Navigator.pop(context, 'create');
                  }),
                  itemMenu('assets/icons/search2.svg', 'Найти задания', () {
                    Navigator.pop(context, 'search');
                  }),
                  itemMenu('assets/icons/note.svg', 'Мои задания', () {
                    if (inTask) {
                      Navigator.pop(context);
                    } else {
                      Navigator.of(context)
                          .pushNamed(AppRoute.tasks, arguments: [(page) {}]);
                    }
                  }),
                  itemMenu('assets/icons/messages1.svg', 'Мои сообщения', () {
                    Navigator.pop(context, 'chat');
                  }),
                  itemMenu('assets/icons/profile-circle.svg', 'Личный кабинет',
                      () {
                    Navigator.of(context).pushNamed(AppRoute.personalAccount);
                  }),
                  itemMenu(
                      'assets/icons/user_circle_add.svg', 'Реферальная система',
                      () {
                    Navigator.of(context).pushNamed(AppRoute.referal);
                  }),
                  itemMenu('assets/icons/mouse.svg', 'О проекте', () {
                    Navigator.of(context).pushNamed(AppRoute.about);
                  }),
                  itemMenu(
                      'assets/icons/message-favorite.svg', 'Связаться с нами',
                      () {
                    Navigator.of(context).pushNamed(AppRoute.contactus);
                  }),
                  itemMenu('assets/icons/moon.svg', 'Темный режим', () {}),
                  SizedBox(height: 15.h),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 36.h,
                        width: 102.h,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: ColorStyles.greyF7F7F8,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset('assets/icons/russia.svg'),
                            Spacer(),
                            Text(
                              'Ru',
                              style: CustomTextStyle.black_16_w600_171716,
                            ),
                            Spacer(),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: ColorStyles.greyBDBDBD,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 164.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemMenu(String icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Row(
            children: [
              SvgPicture.asset(
                icon,
                height: 24.h,
                width: 24.h,
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: CustomTextStyle.black_18_w500_171716,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemMenuImage(String icon, String title, Function() onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: Row(
            children: [
              Image.asset(
                icon,
                height: 24.h,
                width: 24.h,
              ),
              SizedBox(width: 12.w),
              Text(
                title,
                style: CustomTextStyle.black_18_w500_171716,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
