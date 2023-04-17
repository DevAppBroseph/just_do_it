import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/models/task.dart';
import 'package:scale_button/scale_button.dart';

class ArchiveTasksView extends StatelessWidget {
  const ArchiveTasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                SizedBox(height: 10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.keyboard_backspace_rounded,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'В архиве',
                          style: CustomTextStyle.black_21_w700_171716,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  height:
                      MediaQuery.of(context).size.height - 20.h - 10.h - 77.h,
                  child: ListView.builder(
                    itemCount: 7,
                    padding: EdgeInsets.only(top: 15.h, bottom: 100.h),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return itemTask(
                        Task(
                          icon: 'assets/images/pen.png',
                          task: 'Сделать инфографику',
                          typeLocation: 'Можно выполнить удаленно',
                          whenStart: 'Начать сегодня',
                          coast: '1 000',
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 34.h),
              child: CustomButton(
                onTap: () {},
                btnColor: ColorStyles.yellowFFD70A,
                textLabel: Text(
                  'Создать новое',
                  style: CustomTextStyle.black_15_w600_171716,
                ),
              ),
            ),
          )
        ],
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
                              style: CustomTextStyle.black_13_w500_171716,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.typeLocation,
                      style: CustomTextStyle.black_11_w500_515150,
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      task.whenStart,
                      style: CustomTextStyle.grey_11_w400,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'до ${task.coast} ₽',
                      style: CustomTextStyle.black_13_w500_171716,
                    ),
                  ],
                ),
                SizedBox(width: 5.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
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
