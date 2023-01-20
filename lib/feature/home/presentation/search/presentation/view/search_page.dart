import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:scale_button/scale_button.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool firstStageSelect = true;

  int index = 0;
  int indexLanguage = 0;

  String choice1 = '';
  String choice2 = '';
  String choice3 = 'Маникюр';
  String choice4 = '';
  String choice5 = '';

  String choiceLanguage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Container(
            height: 120.h,
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.only(left: 25.w, right: 25.w, top: 30.w),
              child: Row(
                children: [
                  SizedBox(
                    width: 270.w,
                    height: 40.h,
                    child: CustomTextField(
                      prefixicon: const Icon(Icons.search),
                      hintText: 'Поиск',
                      textEditingController: TextEditingController(),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => BlocProvider.of<SearchBloc>(context)
                        .add(OpenSlidingPanelEvent()),
                    child: Icon(
                      Icons.widgets,
                      size: 30.h,
                      color: Colors.yellow[600]!,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey[100],
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 20.h),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const ClampingScrollPhysics(),
                      children: [
                        firstStageSelect ? firstStage() : secondStage()
                      ],
                    ),
                  ),
                  if (!firstStageSelect)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20.h, vertical: 20.h),
                        child: CustomButton(
                          onTap: () {},
                          btnColor: Colors.yellow[600]!,
                          textLabel: Text(
                            'Создать',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget firstStage() {
    return Column(
      children: [
        Container(
          height: 170.h,
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Добро пожаловать,',
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      'Елена\nКузнецова',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 35.sp,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                ScaleButton(
                  bound: 0.02,
                  child: Container(
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
                          'Рейтинг',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.yellow[800],
                              size: 16.h,
                            ),
                            SizedBox(width: 2.w),
                            Text(
                              '4.5',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 16.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          'Баллы:',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: Colors.grey[400],
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          '850',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
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
        SizedBox(height: 20.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            children: [
              Text(
                'Посмотреть как:',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20.sp,
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
                onTap: () {
                  setState(() {
                    firstStageSelect = false;
                  });
                },
                child: Container(
                  height:
                      ((MediaQuery.of(context).size.width * 47) / 100) - 25.w,
                  width:
                      ((MediaQuery.of(context).size.width * 47) / 100) - 25.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                          size: 80.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Заказчик',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Размести задание',
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 13.sp,
                                  color: Colors.grey[500]),
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
                onTap: () {
                  setState(() {
                    firstStageSelect = false;
                  });
                },
                child: Container(
                  height:
                      ((MediaQuery.of(context).size.width * 47) / 100) - 25.w,
                  width:
                      ((MediaQuery.of(context).size.width * 47) / 100) - 25.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Icon(
                          Icons.local_fire_department,
                          color: Colors.red,
                          size: 80.h,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.w, vertical: 15.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Исполнитель',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 15.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Выполняй работу',
                              style: TextStyle(
                                  fontWeight: FontWeight.w200,
                                  fontSize: 13.sp,
                                  color: Colors.grey[500]),
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
        SizedBox(height: 20.h),
        elementCategory(
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
              height: 80.h,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: 60.h,
                    decoration: BoxDecoration(
                      color: Colors.yellow[600],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: Row(
                        children: [
                          const Spacer(),
                          Text(
                            'Узнай больше о проекте',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_right_alt_sharp),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: Icon(
                      Icons.safety_check,
                      size: 70.h,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget secondStage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w),
          child: Text(
            'Что необходимо сделать?',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        elementCategory(
          'Ремонт и строительство',
          1,
          choice: choice1,
        ),
        index == 1
            ? info([
                'Раз',
                'Два',
                'Три',
                'Иннакентий',
                'Аврам',
                'Hello world',
              ])
            : SizedBox(height: 20.h),
        elementCategory(
          'Домашний персонал',
          2,
          choice: choice2,
        ),
        index == 2
            ? info([
                'Раз',
                'Два',
                'Три',
                'Иннакентий',
                'Аврам',
                'Hello world',
              ])
            : SizedBox(height: 20.h),
        elementCategory(
          'Красота и здоровье',
          3,
          choice: choice3,
        ),
        index == 3
            ? info([
                'Раз',
                'Два',
                'Три',
                'Иннакентий',
                'Аврам',
                'Hello world',
              ])
            : SizedBox(height: 20.h),
        elementCategory(
          'Репетиторы и обучение',
          4,
          choice: choice4,
        ),
        index == 4
            ? info([
                'Раз',
                'Два',
                'Три',
                'Иннакентий',
                'Аврам',
                'Hello world',
              ])
            : SizedBox(height: 20.h),
        elementCategory(
          'Транспорт',
          5,
          choice: choice5,
        ),
        index == 5
            ? info([
                'Раз',
                'Два',
                'Три',
                'Иннакентий',
                'Аврам',
                'Hello world',
              ])
            : SizedBox(height: 20.h),
      ],
    );
  }

  Widget elementCategory(String title, int currentIndex, {String choice = ''}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () => setState(() {
          if (firstStageSelect) {
            if (indexLanguage != currentIndex) {
              indexLanguage = currentIndex;
            } else {
              indexLanguage = 0;
            }
          } else {
            if (index != currentIndex) {
              index = currentIndex;
            } else {
              index = 0;
            }
          }
        }),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              const Icon(Icons.abc),
              SizedBox(width: 5.w),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
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
          index = 0;
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
