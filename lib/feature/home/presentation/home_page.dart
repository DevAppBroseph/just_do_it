import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/chat_page.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/bloc/create_bloc.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/view/create_page.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/widget/sliding_panel.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/search_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/personal_account.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/tasks_page.dart';
import 'package:just_do_it/feature/home/presentation/welcom/welcom_page.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 5);
  PanelController panelController = PanelController();
  final streamController = StreamController<int>();
  int page = 5;

  void selectUser(int value) {
    pageController.jumpToPage(value);
    page = value;
    streamController.add(value);
  }

  @override
  void dispose() {
    pageController.dispose();
    panelController.close();
    streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: PageView(
            controller: pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              CreatePage(),
              SearchPage(),
              const TasksPage(),
              ChatPage(),
              PersonalAccountPage(),
              WelcomPage(selectUser)
            ],
          ),
          bottomNavigationBar: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              return MediaQuery(
                data: const MediaQueryData(textScaleFactor: 1.0),
                child: Container(
                  height: 90.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      itemBottomNavigatorBar(
                        'assets/icons/add.svg',
                        'Создать',
                        0,
                      ),
                      itemBottomNavigatorBar(
                        'assets/icons/search.svg',
                        'Найти',
                        1,
                      ),
                      itemBottomNavigatorBar(
                        'assets/icons/tasks.svg',
                        'Задания',
                        2,
                      ),
                      itemBottomNavigatorBar(
                        'assets/icons/messages.svg',
                        'Чат',
                        3,
                      ),
                      itemBottomNavigatorBar(
                        'assets/icons/profile.svg',
                        'Кабинет',
                        4,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        BlocBuilder<CreateBloc, CreateState>(
          builder: (context, snapshot) {
            if (snapshot is OpenSlidingPanelState) {
              panelController.animatePanelToPosition(1.0);
            } else if (snapshot is CloseSlidingPanelState) {
              panelController.animatePanelToPosition(0.0);
            }
            return SlidingPanelSearch(panelController);
          },
        ),
      ],
    );
  }

  Widget itemBottomNavigatorBar(String icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 2 || index == 3 || index == 4) {
          Navigator.of(context).pushNamed(AppRoute.auth);
        } else {
          pageController.jumpToPage(index);
          page = index;
          streamController.add(index);
        }
      },
      child: Container(
        width: 70.w,
        height: 80.h,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              color: index == page ? Colors.yellow[600]! : Colors.black,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
