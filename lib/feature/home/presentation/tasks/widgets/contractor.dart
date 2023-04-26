import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/create_task_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_additional.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_button.dart';
import 'package:just_do_it/helpers/router.dart';

class Contractor extends StatelessWidget {
  final Size size;
  Contractor({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        physics: const ClampingScrollPhysics(),
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoute.allTasks, arguments: [true]);
            },
            child: Container(
              height: 55.h,
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    SvgImg.task,
                    color: ColorStyles.yellowFFCA0D,
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '322 задания',
                        style: CustomTextStyle.grey_14_w400,
                      ),
                      Text(
                        'Все задания',
                        style: CustomTextStyle.black_14_w400_171716,
                      )
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorStyles.greyBDBDBD,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(AppRoute.archiveTasks, arguments: [true]);
            },
            child: Container(
              height: 55.h,
              width: size.width,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              decoration: BoxDecoration(
                color: ColorStyles.greyF9F9F9,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(
                    SvgImg.archive,
                    color: ColorStyles.yellowFFCA0D,
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '322 задания',
                        style: CustomTextStyle.grey_14_w400,
                      ),
                      Text(
                        'В архиве',
                        style: CustomTextStyle.black_14_w400_171716,
                      )
                    ],
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.keyboard_arrow_right_rounded,
                    color: ColorStyles.greyBDBDBD,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 50.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              'Вас выбрали в 3 заданиях',
              style: CustomTextStyle.black_18_w500_171716,
            ),
          ),
          SizedBox(height: 30.h),
          Column(
            children: [
              itemButton(
                'Выполняются',
                '1 задания',
                SvgImg.inProgress,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TaskAdditional(
                        title: 'Выполняются',
                        asCustomer: true,
                      );
                    }),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 18.h),
              itemButton(
                'Выполненные',
                '1 задания',
                SvgImg.complete,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TaskAdditional(
                        title: 'Выполнены',
                        asCustomer: true,
                      );
                    }),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
            ],
          ),
          Column(
            children: [
              SizedBox(height: 18.h),
              itemButton(
                'Ждут подтверждения',
                '1 задания',
                SvgImg.needSuccess,
                () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return TaskAdditional(
                        title: 'Ждут подтверждения',
                        asCustomer: true,
                      );
                    }),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 18.h),
                child: const Divider(
                  height: 1,
                  indent: 20,
                  endIndent: 20,
                ),
              ),
            ],
          ),
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomButton(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CeateTasks(
                        customer: true,
                        doublePop: true,
                      );
                    },
                  ),
                );
              },
              btnColor: ColorStyles.yellowFFD70A,
              textLabel: Text(
                'Создать новое',
                style: CustomTextStyle.black_16_w600_171716,
              ),
            ),
          ),
          SizedBox(height: 34.h),
        ],
      ),
    );
  }
}
