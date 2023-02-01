import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/contractor.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/customer.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  final streamController = StreamController<int>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final PageController pageController = PageController();
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        body: StreamBuilder<int>(
          stream: streamController.stream,
          initialData: 0,
          builder: (context, snapshot) {
            return SafeArea(
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.keyboard_backspace_rounded,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Мои задания',
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: Colors.black,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
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
                                ? Colors.grey
                                : Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.r),
                              bottomLeft: Radius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            'Я исполнитель',
                            style: TextStyle(
                              color: snapshot.data! == 1
                                  ? Colors.black
                                  : Colors.white,
                            ),
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
                                ? Colors.grey
                                : Colors.black,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20.r),
                              bottomRight: Radius.circular(20.r),
                            ),
                          ),
                          child: Text(
                            'Я заказчик',
                            style: TextStyle(
                              color: snapshot.data! == 0
                                  ? Colors.black
                                  : Colors.white,
                            ),
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
              ),
            );
          },
        ),
      ),
    );
  }
}
