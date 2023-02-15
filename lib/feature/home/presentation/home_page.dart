import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/chat_page.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/view/create_page.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/view/search_page.dart';
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
  PageController pageController = PageController(initialPage: 4);
  PanelController panelController = PanelController();
  final streamController = StreamController<int>();
  int page = 5;

  void selectUser(int value) {
    pageController.jumpToPage(value);
    page = value;
    streamController.add(value);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
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
          body: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, snapshot) {
              if (snapshot is LoadProfileState) {
                return const CupertinoActivityIndicator();
              }
              return PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CreatePage(),
                  SearchPage(),
                  const TasksPage(),
                  ChatPage(),
                  // PersonalAccountPage(),
                  WelcomPage(selectUser)
                ],
              );
            },
          ),
          bottomNavigationBar: StreamBuilder<int>(
            stream: streamController.stream,
            builder: (context, snapshot) {
              return MediaQuery(
                data: const MediaQueryData(textScaleFactor: 1.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: ColorStyles.shadowFC6554,
                        offset: const Offset(0, -4),
                        blurRadius: 55.r,
                      )
                    ],
                  ),
                  height: 96.h,
                  child: Padding(
                    padding: EdgeInsets.only(top: 20.h),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                ),
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
        final bloc = BlocProvider.of<ProfileBloc>(context);
        if ((index == 2 || index == 3 || index == 4) && bloc.access == null) {
          Navigator.of(context).pushNamed(AppRoute.auth);
        } else {
          if(index == 4) {
            Navigator.of(context).pushNamed(AppRoute.personalAccount);
          } else {
          pageController.jumpToPage(index);
          page = index;
          streamController.add(index);}
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Container(
          width: 50.h,
          height: 46.h,
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                color: index == page ? ColorStyles.yellowFFD70A : Colors.black,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: CustomTextStyle.black_13_w400_292D32,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
