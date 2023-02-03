import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/models/task.dart';
import 'package:scale_button/scale_button.dart';

class SearchPage extends StatelessWidget {
  List<Task> taskList = [
    Task(
      icon: 'assets/images/pen.png',
      task: 'Сделать инфографику',
      typeLoaction: 'Можно выполнить удаленно',
      whenStart: 'Начать сегодня',
      coast: '1 000',
    ),
    Task(
      icon: 'assets/images/laptop.png',
      task: 'На сайте у товаров поменять цены по прайсу',
      typeLoaction: 'Можно выполнить удаленно',
      whenStart: 'Начать завтра, с 15:00',
      coast: '1 500',
    ),
    Task(
      icon: 'assets/images/bag.png',
      task: 'Оформить доверенность',
      typeLoaction: 'Москва',
      whenStart: 'Начать 22.12.2023, с 15:00',
      coast: '2 000',
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Container(height: 60.h, color: Colors.white),
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
            Container(
              height: 30.h,
              color: Colors.white,
            ),
            SizedBox(height: 16.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  Text(
                    'Все задачи',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  ScaleButton(
                    bound: 0.01,
                    onTap: () => BlocProvider.of<SearchBloc>(context)
                        .add(OpenSlidingPanelEvent()),
                    child: SizedBox(
                      height: 40.h,
                      width: 90.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            height: 36.h,
                            width: 90.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF7F7F8),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10.h),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    'assets/icons/candle.svg',
                                    height: 16.h,
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    'Фильтр',
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              height: 15.h,
                              width: 15.h,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(369),
                                  color: const Color(0xFF171716)),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: taskList.map((e) => itemTask(e)).toList(),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemTask(Task task) {
    return Padding(
      padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.w),
      child: ScaleButton(
        bound: 0.01,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A2A61).withOpacity(0.06),
                offset: const Offset(0, 1),
              )
            ],
          ),
          width: 327.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  height: 50.h,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            task.icon,
                            height: 34.h,
                            width: 34.h,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 160.w,
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              task.task,
                              style: TextStyle(
                                color: const Color(0xFF171716),
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.typeLoaction,
                      style: TextStyle(
                        color: const Color(0xFF515150),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.whenStart,
                      style: TextStyle(
                        color: const Color(0xFFBDBDBD),
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Spacer()
                    Text(
                      'до ${task.coast} ₽',
                      style: TextStyle(
                        color: const Color(0xFF171716),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // const Spacer(),
                    SvgPicture.asset(
                      'assets/icons/card.svg',
                      height: 16.h,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
