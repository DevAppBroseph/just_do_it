import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:scale_button/scale_button.dart';

class WelcomPage extends StatefulWidget {
  Function(int) onSelect;

  WelcomPage(this.onSelect);

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  bool state = true;
  int indexLanguage = 0;
  int index = 0;
  String choiceLanguage = '';

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 60.h,
              color: Colors.white,
            ),
            Container(
              height: 40.h,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.only(left: 25.w, right: 28.w),
                child: Row(
                  children: [
                    SizedBox(
                      width: 270.w,
                      height: 40.h,
                      child: CustomTextField(
                        prefixicon: Stack(
                          alignment: Alignment.center,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/search1.svg',
                              height: 12.h,
                            ),
                          ],
                        ),
                        hintText: 'Поиск',
                        textEditingController: TextEditingController(),
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 8.h),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(width: 23.w),
                    SvgPicture.asset('assets/icons/category.svg'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(height: 30.h, color: Colors.white),
                  BlocBuilder<ProfileBloc, ProfileState>(
                    builder: (context, snapshot) {
                      final bloc = BlocProvider.of<ProfileBloc>(context);
                      if (bloc.access == null) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 80.w),
                          child: Padding(
                            padding: EdgeInsets.only(top: 40.h, bottom: 22.h),
                            child: SvgPicture.asset(
                              SvgImg.justDoIt,
                              height: 38.h,
                            ),
                          ),
                        );
                      }
                      return Container(
                        color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 20.h),
                            Padding(
                              padding: EdgeInsets.only(right: 24.w, left: 24.w),
                              child: SizedBox(
                                height: 112.h,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 190.w,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Добро пожаловать,',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: null,
                                          ),
                                          SizedBox(height: 8.h),
                                          Text(
                                            '${bloc.user!.firstname}\n${bloc.user!.lastname}',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 32.sp,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: null,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Spacer(),
                                    ScaleButton(
                                      bound: 0.02,
                                      child: Container(
                                        height: 112.h,
                                        width: 121.h,
                                        padding: EdgeInsets.only(
                                            left: 16.w,
                                            right: 16.w,
                                            top: 4.h,
                                            bottom: 4.h),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(10.r),
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Рейтинг',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: const Color(0xFFBDBDBD),
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Row(
                                              children: [
                                                SvgPicture.asset(
                                                    'assets/icons/star.svg'),
                                                SizedBox(width: 4.w),
                                                Text(
                                                  '4.5',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14.sp,
                                                    color:
                                                        const Color(0xFF161617),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10.h),
                                            Text(
                                              'Баллы:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 12.sp,
                                                color: const Color(0xFFBDBDBD),
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              '850',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14.sp,
                                                color: const Color(0xFF161617),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 50.h),
                          ],
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 18.h),
                  Padding(
                    padding: EdgeInsets.only(left: 24.w),
                    child: Row(
                      children: [
                        Text(
                          'Посмотреть как:',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: Row(
                      children: [
                        ScaleButton(
                          bound: 0.02,
                          onTap: () => widget.onSelect(0),
                          child: Container(
                            height: ((MediaQuery.of(context).size.width * 47) /
                                    100) -
                                25.w,
                            width: ((MediaQuery.of(context).size.width * 47) /
                                    100) -
                                25.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset(
                                    'assets/images/customer.png',
                                    height: 115.h,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Заказчик',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Размести задание',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp,
                                          color: const Color(0xFFBDBDBD),
                                        ),
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
                            height: ((MediaQuery.of(context).size.width * 47) /
                                    100) -
                                25.w,
                            width: ((MediaQuery.of(context).size.width * 47) /
                                    100) -
                                25.w,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Image.asset(
                                    'assets/images/contractor.png',
                                    height: 103.h,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16.w, vertical: 12.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Исполнитель',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12.sp,
                                        ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        'Выполняй работу',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 10.sp,
                                          color: const Color(0xFFBDBDBD),
                                        ),
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
                  SizedBox(height: 30.h),
                  elementCategory(
                    'assets/images/language.png',
                    'Русский',
                    1,
                    choice: choiceLanguage,
                  ),
                  indexLanguage == 1
                      ? info([
                          'Русский',
                          'Английский',
                        ])
                      : SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.w),
                    child: ScaleButton(
                      duration: const Duration(milliseconds: 50),
                      bound: 0.01,
                      child: SizedBox(
                        height: 85.h,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 69.h,
                              decoration: BoxDecoration(
                                color: yellow,
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    Text(
                                      'Узнай больше о проекте!',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(
                                        'assets/icons/arrow-right1.svg')
                                  ],
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding:
                                    EdgeInsets.only(left: 16.w, bottom: 31.h),
                                child: Image.asset(
                                  'assets/images/thor4.png',
                                  height: 56.h,
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
            )
          ],
        ),
      ),
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex,
      {String choice = ''}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () => setState(() {
          // if (firstStageSelect) {
          if (indexLanguage != currentIndex) {
            indexLanguage = currentIndex;
          } else {
            indexLanguage = 0;
          }
          // } else {
          //   if (index != currentIndex) {
          //     index = currentIndex;
          //   } else {
          //     index = 0;
          //   }
          // }
        }),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
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
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (choice.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: SizedBox(
                    width: 100.w,
                    child: Text(
                      '- $choice',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                      ),
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
    );
  }

  Widget info(List<String> list) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: Container(
        height: 200.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
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
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w400,
                    ),
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
