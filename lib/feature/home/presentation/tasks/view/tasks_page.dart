import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/contractor.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/customer.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class TasksPage extends StatefulWidget {
  Function(int) onSelect;
  TasksPage({super.key, required this.onSelect});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final streamController = StreamController<int>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final PageController pageController = PageController();
    return Scaffold(
      backgroundColor: ColorStyles.whiteFFFFFF,
      body: StreamBuilder<int>(
        stream: streamController.stream,
        initialData: 0,
        builder: (context, snapshot) {
          return Column(
            children: [
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomIconButton(
                        onBackPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: SvgImg.arrowRight,
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Мои задания',
                        style: CustomTextStyle.black_22_w700_171716,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoute.menu,
                                arguments: [
                                  widget.onSelect,
                                  true
                                ]).then((value) {
                              if (value != null) {
                                Navigator.of(context).pop();
                                if (value == 'create') {
                                  widget.onSelect(0);
                                }
                                if (value == 'search') {
                                  widget.onSelect(1);
                                }
                                if (value == 'chat') {
                                  widget.onSelect(3);
                                }
                                if (value == 'task') {}
                              }
                            });
                          },
                          child: SvgPicture.asset('assets/icons/category.svg')),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      streamController.sink.add(0);
                      pageController.animateToPage(0,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut);
                      setState(() {});
                    },
                    child: Container(
                      height: 40.h,
                      width: 150.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: snapshot.data! == 1
                            ? ColorStyles.greyE0E6EE
                            :  ColorStyles.yellowFFD70A,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.r),
                          bottomLeft: Radius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'Я исполнитель',
                        style: CustomTextStyle.black_14_w400_171716
                           
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      streamController.sink.add(1);
                      pageController.animateToPage(1,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeInOut);
                      setState(() {});
                    },
                    child: Container(
                      height: 40.h,
                      width: 150.w,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: snapshot.data! == 0
                            ? ColorStyles.greyE0E6EE
                            : ColorStyles.yellowFFD70A,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.r),
                          bottomRight: Radius.circular(20.r),
                        ),
                      ),
                      child: Text(
                        'Я заказчик',
                        style:  CustomTextStyle.black_14_w400_171716
                          
                      ),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Customer(size: size),
                      Contractor(size: size),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
