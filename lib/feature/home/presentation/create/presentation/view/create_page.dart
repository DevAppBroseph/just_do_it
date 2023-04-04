import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:scale_button/scale_button.dart';

class CreatePage extends StatefulWidget {
  final Function() onBackPressed;
  const CreatePage({super.key, required this.onBackPressed});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  int index = 0;

  List<String> choice1 = [];
  List<String> choice2 = [];
  List<String> choice3 = [];
  List<String> choice4 = [];
  List<String> choice5 = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, snapshot) {
      var bloc = BlocProvider.of<AuthBloc>(context);
      return MediaQuery(
        data: const MediaQueryData(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: ColorStyles.whiteFFFFFF,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Container(
                height: 130.h,
                decoration: BoxDecoration(
                  color: ColorStyles.whiteFFFFFF,
                  boxShadow: [
                    BoxShadow(
                      color: ColorStyles.shadowFC6554,
                      offset: const Offset(0, -4),
                      blurRadius: 55.r,
                    )
                  ],
                ),
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.only(top: 60.h, left: 25.w, right: 28.w),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: widget.onBackPressed,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Transform.rotate(
                                angle: pi,
                                child: SvgPicture.asset(
                                  'assets/icons/arrow_right.svg',
                                  height: 20.h,
                                  width: 20.w,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          SizedBox(
                            width: 240.w,
                            height: 36.h,
                            child: CustomTextField(
                              fillColor: ColorStyles.greyF7F7F8,
                              prefixIcon: Stack(
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
                                  horizontal: 11.w, vertical: 11.h),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(width: 23.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoute.menu);
                            },
                            child:
                                SvgPicture.asset('assets/icons/category.svg'),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 30.h),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      children: [firstStage()],
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 20.h),
                        child: CustomButton(
                          onTap: () {
                            final bloc = BlocProvider.of<ProfileBloc>(context);
                            if (bloc.user == null) {
                              Navigator.of(context).pushNamed(AppRoute.auth);
                            } else {
                              Navigator.of(context)
                                  .pushNamed(AppRoute.createTasks);
                            }
                          },
                          btnColor: ColorStyles.yellowFFD70A,
                          textLabel: Text(
                            'Создать',
                            style: CustomTextStyle.black_15_w600_171716,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget _stage(Activities activities, int currentIndex) {
    // activities.subcategory.
    return Column(
      children: [
        elementCategory(
          activities.photo ?? '',
          'Ремонт и строительство',
          1,
          choice: choice1,
        ),
        info(
          [
            'Раз',
            'Два',
            'Три',
            'Иннакентий',
            'Аврам',
            'Hello world',
          ],
          index == currentIndex + 1,
          choice1,
          currentIndex + 1,
        ),
      ],
    );
  }

  Widget firstStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w),
          child: Text(
            'Что необходимо сделать?',
            style: CustomTextStyle.black_17_w800,
          ),
        ),
        elementCategory(
          'assets/images/build.png',
          'Ремонт и строительство',
          1,
          choice: choice1,
        ),
        info(
          [
            'Раз',
            'Два',
            'Три',
            'Иннакентий',
            'Аврам',
            'Hello world',
          ],
          index == 1,
          choice1,
          1,
        ),
        elementCategory(
          'assets/images/house.png',
          'Домашний персонал',
          2,
          choice: choice2,
        ),
        info(
          [
            'Раз',
            'Два',
            'Три',
            'Иннакентий',
            'Аврам',
            'Hello world',
          ],
          index == 2,
          choice2,
          2,
        ),
        elementCategory(
          'assets/images/soap.png',
          'Красота и здоровье',
          3,
          choice: choice3,
        ),
        info(
          [
            'Раз',
            'Два',
            'Три',
            'Иннакентий',
            'Аврам',
            'Hello world',
          ],
          index == 3,
          choice3,
          3,
        ),
        elementCategory(
          'assets/images/book.png',
          'Репетиторы и обучение',
          4,
          choice: choice4,
        ),
        info(
          [
            'Раз',
            'Два',
            'Три',
            'Иннакентий',
            'Аврам',
            'Hello world',
          ],
          index == 4,
          choice4,
          4,
        ),
        elementCategory(
          'assets/images/auto.png',
          'Транспорт',
          5,
          choice: choice5,
        ),
        info(
          [
            'Раз',
            'Два',
            'Три',
            'Иннакентий',
            'Аврам',
            'Hello world',
          ],
          index == 5,
          choice5,
          5,
        ),
        if (index != 0) SizedBox(height: 80.h),
      ],
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex,
      {List<String> choice = const []}) {
    String selectWork = '';
    if (choice.isNotEmpty) {
      selectWork = '- ${choice.first}';
      if (choice.length > 1) {
        for (int i = 1; i < choice.length; i++) {
          selectWork += ', ${choice[i]}';
        }
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () => setState(() {
          if (index != currentIndex) {
            index = currentIndex;
          } else {
            index = 0;
          }
        }),
        child: Container(
          decoration: BoxDecoration(
            color: ColorStyles.whiteFFFFFF,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.shadowFC6554,
                offset: const Offset(0, -4),
                blurRadius: 55.r,
              )
            ],
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
                style: CustomTextStyle.black_13_w400_171716,
              ),
              if (choice.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: SizedBox(
                    width: 70.w,
                    child: Text(
                      selectWork,
                      style: CustomTextStyle.grey_13_w400,
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
                  : const Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorStyles.greyBDBDBD,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget info(List<String> list, bool open, List<String> choice, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: open ? 200.h : 0.h,
        decoration: BoxDecoration(
          color: ColorStyles.whiteFFFFFF,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: [
            BoxShadow(
              color: ColorStyles.shadowFC6554,
              offset: const Offset(0, -4),
              blurRadius: 55.r,
            )
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          children: list.map((e) => item(e, choice, index)).toList(),
        ),
      ),
    );
  }

  Widget item(String label, List<String> choice, int index) {
    return GestureDetector(
      onTap: () {
        if (choice.contains(label)) {
          choice.remove(label);
        } else {
          if (choice.length < 1) choice.add(label);
        }
        switch (index) {
          case 1:
            choice2.clear();
            choice3.clear();
            choice4.clear();
            choice5.clear();
            break;
          case 2:
            choice1.clear();
            choice3.clear();
            choice4.clear();
            choice5.clear();
            break;
          case 3:
            choice1.clear();
            choice2.clear();
            choice4.clear();
            choice5.clear();
            break;
          case 4:
            choice1.clear();
            choice2.clear();
            choice3.clear();
            choice5.clear();
            break;
          case 5:
            choice1.clear();
            choice2.clear();
            choice3.clear();
            choice4.clear();
            break;

          default:
        }
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
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
                    style: CustomTextStyle.black_13_w400_515150,
                  ),
                  const Spacer(),
                  if (choice.contains(label)) const Icon(Icons.check)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
