import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/item_task.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
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
                          dateEnd: '',
                          dateStart: '',
                          description: '',
                          file: null,
                          name: '',
                          priceFrom: 0,
                          priceTo: 0,
                          region: '',
                          subcategory:
                              Subcategory(id: 1, description: 'description'),
                        ),
                        (task) {},
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
}
