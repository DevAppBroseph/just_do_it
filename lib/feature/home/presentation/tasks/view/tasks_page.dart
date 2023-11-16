import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/contractor.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/customer.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class TasksPage extends StatefulWidget {
  Function(int) onSelect;
  final int customer;
  TasksPage({super.key, required this.onSelect, required this.customer});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  
  bool customerFlag = false;
  bool contractorFlag = false;
  final streamController = StreamController<int>();
  final PageController pageController = PageController();
  @override
  Widget build(BuildContext context) {
    
    Size size = MediaQuery.of(context).size;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.greyEAECEE,
        body: StreamBuilder<int>(
          stream: streamController.stream,
          initialData: widget.customer,
          builder: (context, snapshot) {
            return Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 60.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CustomIconButton(
                              onBackPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: SvgImg.arrowRight,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'my_task'.tr(),
                              style: CustomTextStyle.black_22_w700_171716,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .pushNamed(AppRoute.menu, arguments: [widget.onSelect, true]).then((value) {

                                        if (value != null) {
                                      Navigator.of(context).pop();
                                      if (value == 'create') {
                                        widget.onSelect(0);
                                      }
                                      if (value == 'search') {
                                        widget.onSelect(1);
                                      }
                                      else if (value == 'tasks') {
                                        widget.onSelect(2);
                                      }
                                      if (value == 'chat') {
                                        widget.onSelect(3);
                                      }
                                      if (value == 'task') {}
                                    }
                                  });
                                },
                                child: SvgPicture.asset('assets/icons/category2.svg')),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            callBacK(0);
                          },
                          child: Container(
                            height: 40.h,
                            width: 150.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: snapshot.data! == 1 ? ColorStyles.whiteFFFFFF : ColorStyles.yellowFFD70A,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.r),
                                bottomLeft: Radius.circular(20.r),
                              ),
                            ),
                            child: Text('i_am_the_customer'.tr(), style: CustomTextStyle.black_14_w400_171716),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            callBacK(1);
                          },
                          child: Container(
                            height: 40.h,
                            width: 150.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: snapshot.data! == 0 ? ColorStyles.whiteFFFFFF : ColorStyles.yellowFFD70A,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20.r),
                                bottomRight: Radius.circular(20.r),
                              ),
                            ),
                            child: Text('i_am_executor'.tr(), style: CustomTextStyle.black_14_w400_171716),
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                    BlocBuilder<ProfileBloc, ProfileState>(
  builder: (context, state) {
    final user=context.read<ProfileBloc>().user;
    if(user==null){
      return const Expanded(child: Center(child: CupertinoActivityIndicator(),),);
    }
    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: PageView(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            Contractor(
                                size: size,
                                callBacK: callBacK,
                                callBackFlag: () {
                                  setState(() {
                                    contractorFlag = true;
                                  });
                                }),
                            Customer(
                              size: size,
                              callBacK: callBacK,
                              callBackFlag: () {
                                setState(() {
                                   customerFlag = true;
                                });

                              },
                            ),
                          ],
                        ),
                      ),
                    );
  },
),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void callBacK(int page) {
    streamController.sink.add(page);
    pageController.animateToPage(page, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut);
    setState(() {});
  }
}
