import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/category.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/date.dart';

class CeateTasks extends StatefulWidget {
  const CeateTasks({super.key});

  @override
  State<CeateTasks> createState() => _CeateTasksState();
}

class _CeateTasksState extends State<CeateTasks> {
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 50.h,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      'Создание задания',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      '1/2',
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [Category(), DatePicker()],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: CustomButton(
                  onTap: () {
                    pageController.animateToPage(1,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeInOut);
                  },
                  btnColor: ColorStyles.yellowFFD70A,
                  textLabel: Text('Далее'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
