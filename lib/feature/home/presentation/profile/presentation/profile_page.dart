import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/contractor_profile.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/customer_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int type = 1;

  bool state = false;

  PageController pageController = PageController();
  int stageRegistragion = 1;

  @override
  Widget build(BuildContext context) {
    double widthTabBarItem = (MediaQuery.of(context).size.width - 40.w) / 2;
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Профиль',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey[400],
                          size: 18.h,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20.h),
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 100),
                        alignment: type == 1
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: Container(
                          height: 40.h,
                          width: widthTabBarItem,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.only(
                              topLeft:
                                  !state ? Radius.circular(20.r) : Radius.zero,
                              bottomLeft:
                                  !state ? Radius.circular(20.r) : Radius.zero,
                              topRight:
                                  state ? Radius.circular(20.r) : Radius.zero,
                              bottomRight:
                                  state ? Radius.circular(20.r) : Radius.zero,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (type != 1) {
                                    Future.delayed(
                                      const Duration(milliseconds: 50),
                                      (() {
                                        setState(() {
                                          stageRegistragion = 1;
                                          state = !state;
                                        });
                                        pageController.animateToPage(0,
                                            duration:
                                                const Duration(milliseconds: 100),
                                            curve: Curves.linear);
                                      }),
                                    );
                                  }
                                  type = 1;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    'Как исполнитель',
                                    style: TextStyle(
                                      color: state ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (type != 2) {
                                    Future.delayed(
                                      const Duration(milliseconds: 50),
                                      (() {
                                        setState(() {
                                          stageRegistragion = 1;
                                          state = !state;
                                        });
                                        pageController.animateToPage(1,
                                            duration:
                                                const Duration(milliseconds: 100),
                                            curve: Curves.linear);
                                      }),
                                    );
                                  }
                                  type = 2;
                                });
                              },
                              child: Container(
                                color: Colors.transparent,
                                child: Center(
                                  child: Text(
                                    'Как заказчик',
                                    style: TextStyle(
                                      color: !state ? Colors.black : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      ContractorProfile(),
                      CustomerProfile(),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
