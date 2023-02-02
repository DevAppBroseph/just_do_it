import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:scale_button/scale_button.dart';

class CreatePage extends StatefulWidget {
  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
            Expanded(
              child: Container(
                color: Colors.grey[100],
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
                          onTap: () {},
                          btnColor: yellow,
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
      ),
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
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        elementCategory(
          'assets/images/build.png',
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
          'assets/images/house.png',
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
          'assets/images/soap.png',
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
          'assets/images/book.png',
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
          'assets/images/auto.png',
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
        if (index != 0) SizedBox(height: 80.h),
      ],
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex,
      {String choice = ''}) {
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
