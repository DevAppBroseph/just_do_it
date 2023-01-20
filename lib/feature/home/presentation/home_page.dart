import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/chat_page.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/create_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile_page.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/view/search_page.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel.dart';
import 'package:just_do_it/feature/home/presentation/tasks/presentation/tasks_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  PageController pageController = PageController(initialPage: 1);
  final streamController = StreamController<int>();
  PanelController panelController = PanelController();
  int page = 1;

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
              TasksPage(),
              ChatPage(),
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              return SizedBox(
                height: 90.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    itemBottomNavigatorBar(
                      Icons.add_circle_rounded,
                      'Создать',
                      0,
                    ),
                    itemBottomNavigatorBar(
                      Icons.search,
                      'Найти',
                      1,
                    ),
                    itemBottomNavigatorBar(
                      Icons.task,
                      'Задания',
                      2,
                    ),
                    itemBottomNavigatorBar(
                      Icons.local_post_office_outlined,
                      'Чат',
                      3,
                    ),
                    itemBottomNavigatorBar(
                      Icons.supervised_user_circle,
                      'Кабинет',
                      4,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // BlocBuilder<SearchBloc, SearchState>(
        //   builder: (context, snapshot) {
        //     if (snapshot is OpenSlidingPanelState) {
        //       panelController.animatePanelToPosition(1.0);
        //     } else if (snapshot is CloseSlidingPanelState) {
        //       panelController.animatePanelToPosition(0.0);
        //     }
        //     return SlidingPanelSearch(panelController);
        //   },
        // ),
      ],
    );
  }

  Widget itemBottomNavigatorBar(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () {
        pageController.jumpToPage(index);
        page = index;
        streamController.add(index);
      },
      child: Container(
        width: 70.w,
        height: 80.h,
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22.h,
              color: index == page ? Colors.yellow[600]! : Colors.black,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
                color: index == page ? Colors.yellow[600]! : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
