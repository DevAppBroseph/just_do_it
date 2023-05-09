import 'dart:async';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/currency_bloc/currency_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/chat_page.dart';
import 'package:just_do_it/feature/home/presentation/create/presentation/view/create_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply/reply_bloc.dart'
    as rep;
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search/search_bloc.dart'
    as search;
import 'package:just_do_it/feature/home/presentation/search/presentation/view/search_page.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/widget/sliding_panel_reply.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/tasks_page.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile_link.dart';
import 'package:just_do_it/feature/home/presentation/welcom/welcom_page.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController = PageController(initialPage: 4);
  PanelController panelController = PanelController();
  PanelController panelControllerReply = PanelController();
  final streamController = StreamController<int>();
  int page = 5;
  int? idTask;

  String? access;
  String searchQuery = '';

  void parseTripRefCode(PendingDynamicLinkData event) async {
    access = await Storage().getAccessToken();
    String? refCode = event.link.queryParameters['ref_code'];
    String? userProfile = event.link.queryParameters['user_profile'];
    String? taskId = event.link.queryParameters['task_id'];
    if (refCode != null) {
      BlocProvider.of<AuthBloc>(context).setRef(int.parse(refCode));
    } else if (userProfile != null) {
      final owner = await Repository().getRanking(
        Owner(
          id: int.parse(userProfile),
          firstname: '',
          lastname: '',
          photo: '',
        ),
      );
      if (owner != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewProfileLink(owner),
          ),
        );
      }
    } else if (taskId != null) {
      Future.delayed(const Duration(seconds: 1), () {
        idTask = int.parse(taskId);
        pageController.jumpToPage(1);
        page = 1;
        setState(() {});
      });
    }
  }

  void selectUser(int value) {
    pageController.jumpToPage(value);
    page = value;
    streamController.add(value);
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProfileBloc>(context).add(GetProfileEvent());
    BlocProvider.of<RatingBloc>(context).add(GetRatingEvent(access));
    BlocProvider.of<ProfileBloc>(context).add(GetCategorieProfileEvent());
    BlocProvider.of<ChatBloc>(context).add(GetListMessage());
    BlocProvider.of<CountriesBloc>(context).add(GetCountryEvent());
    BlocProvider.of<CurrencyBloc>(context).add(GetCurrencyEvent());

    Future.delayed(const Duration(seconds: 3), () {
      String? access = BlocProvider.of<ProfileBloc>(context).access;
      if (access != null) {
        BlocProvider.of<ChatBloc>(context).add(StartSocket(context));
      }
    });

    if (Platform.isAndroid) {
      FirebaseDynamicLinks.instance.getInitialLink().then((value) {
        if (value != null) parseTripRefCode(value);
      });
    }
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      parseTripRefCode(event);
    });
  }

  @override
  void dispose() {
    if (panelController.isPanelOpen) panelController.close();
    if (panelControllerReply.isPanelOpen) panelControllerReply.close();
    streamController.close();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: BlocBuilder<ProfileBloc, ProfileState>(
            buildWhen: (previous, current) {
              if (current is EditPageState) {
                searchQuery = current.text;
                page = current.page;
                pageController.jumpToPage(page);
                streamController.add(page);
              }
              return true;
            },
            builder: (context, snapshot) {
              if (snapshot is LoadProfileState) {
                return const CupertinoActivityIndicator();
              }
              return PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CreatePage(
                    onBackPressed: () {
                      pageController.jumpToPage(4);
                      page = 5;
                      streamController.add(4);
                    },
                    onSelect: selectUser,
                  ),
                  SearchPage(
                    taskId: idTask,
                    text: searchQuery,
                    onBackPressed: () {
                      pageController.jumpToPage(4);
                      page = 5;
                      streamController.add(4);
                    },
                    clearId: () {
                      idTask = null;
                    },
                    onSelect: selectUser,
                  ),
                  TasksPage(
                    onSelect: (page) {
                      setState(() {
                        this.page = page;
                        pageController.jumpToPage(this.page);
                      });
                    }, customer: 0,
                  ),
                  ChatPage(() {
                    pageController.jumpToPage(4);
                    page = 5;
                    streamController.add(4);
                  }, selectUser),
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
                  child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, snapshot) {
                    int undreadMessage = 0;
                    for (var element
                        in BlocProvider.of<ChatBloc>(context).chatList) {
                      undreadMessage += element.countUnreadMessage ?? 0;
                    }
                    return Padding(
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
                            counderMessage:
                                undreadMessage != 0 ? undreadMessage : null,
                          ),
                          itemBottomNavigatorBar(
                            'assets/icons/profile.svg',
                            'Кабинет',
                            4,
                          ),
                        ],
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
        BlocBuilder<search.SearchBloc, search.SearchState>(
          builder: (context, snapshot) {
            if (snapshot is search.OpenSlidingPanelState) {
              panelController.animatePanelToPosition(1.0);
            } else if (snapshot is search.CloseSlidingPanelState) {
              panelController.animatePanelToPosition(0.0);
            }
            return SlidingPanelSearch(panelController);
          },
        ),
        BlocBuilder<rep.ReplyBloc, rep.ReplyState>(
          builder: (context, snapshot) {
            if (snapshot is rep.OpenSlidingPanelState) {
              panelControllerReply.animatePanelToPosition(1.0);
            } else if (snapshot is rep.CloseSlidingPanelState) {
              panelControllerReply.animatePanelToPosition(0.0);
            }
            return SlidingPanelReply(panelControllerReply);
          },
        ),
      ],
    );
  }

  Widget itemBottomNavigatorBar(String icon, String label, int index,
      {int? counderMessage}) {
    return GestureDetector(
      onTap: () {
        searchQuery = '';
        setState(() {});
        final bloc = BlocProvider.of<ProfileBloc>(context);
        if ((index == 2 || index == 3 || index == 4) && bloc.user == null) {
          Navigator.of(context).pushNamed(AppRoute.auth);
        } else {
          if (index == 4) {
            Navigator.of(context).pushNamed(AppRoute.personalAccount);
          } else if (index == 2) {
            Navigator.of(context).pushNamed(AppRoute.tasks, arguments: [
              (page) {
                setState(() {
                  this.page = page;
                  pageController.jumpToPage(this.page);
                });
              },
            ]);
          } else {
            pageController.jumpToPage(index);
            page = index;
            streamController.add(index);
          }
        }
      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Container(
          width: 50.w,
          height: 46.w,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    icon,
                    color:
                        index == page ? ColorStyles.yellowFFD70A : Colors.black,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    label,
                    style: CustomTextStyle.black_12_w400_292D32,
                  ),
                ],
              ),
              if (counderMessage != null)
                Padding(
                  padding: EdgeInsets.only(right: 0.h),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      height: 19.h,
                      width: 19.h,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Center(
                        child: Text(
                          '$counderMessage',
                          style: CustomTextStyle.white_10_w700,
                        ),
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
