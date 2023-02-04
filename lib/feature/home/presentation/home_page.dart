import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/chat_page.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/create_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/personal_account.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/view/search_page.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/tasks_page.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import '../../../constants/svg_and_images.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 1);

  final streamController = StreamController<int>();

  PanelController panelController = PanelController();

  int page = 1;

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
              TasksPage(),
              ChatPage(),
              PersonalAccountPage(),
            ],
          ),
          bottomNavigationBar: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  itemBottomNavigatorBar(
                    SvgImg.add,
                    'Создать',
                    0,
                  ),
                  itemBottomNavigatorBar(
                    SvgImg.search,
                    'Найти',
                    1,
                  ),
                  itemBottomNavigatorBar(
                    SvgImg.tasks,
                    'Задания',
                    2,
                  ),
                  itemBottomNavigatorBar(
                    SvgImg.chat,
                    'Чат',
                    3,
                  ),
                  itemBottomNavigatorBar(
                    SvgImg.profile,
                    'Кабинет',
                    4,
                  ),
                ],
              );
            },
          ),
        ),
        BlocBuilder<SearchBloc, SearchState>(
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
            SvgPicture.asset(
              icon,
              color: index == page ? Colors.yellow[600]! : Colors.black,
            ),
            SizedBox(height: 5.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: index == page ? Colors.yellow[600]! : Colors.black,
                fontFamily: 'SFPro'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
