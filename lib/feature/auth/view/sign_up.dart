import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/view/contractor.dart';
import 'package:just_do_it/feature/auth/view/customer.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int type = 1;
  bool state = false;
  GlobalKey keyBar = GlobalKey();
  PageController pageController = PageController();
  int stageRegistragion = 1;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void stage(int index) {
    setState(() {
      stageRegistragion = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthTabBarItem = (MediaQuery.of(context).size.width - 40.w) / 2;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Регистрация ',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            TextSpan(
                              text: '$stageRegistragion/2',
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 21.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Container(
                    key: keyBar,
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
                                topLeft: !state
                                    ? Radius.circular(20.r)
                                    : Radius.zero,
                                bottomLeft: !state
                                    ? Radius.circular(20.r)
                                    : Radius.zero,
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
                                              duration: const Duration(
                                                  milliseconds: 100),
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
                                      'Исполнитель',
                                      style: TextStyle(
                                        color:
                                            state ? Colors.black : Colors.white,
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
                                              duration: const Duration(
                                                  milliseconds: 100),
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
                                      'Заказчик',
                                      style: TextStyle(
                                        color: !state
                                            ? Colors.black
                                            : Colors.white,
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
                  SizedBox(height: 40.h),
                  Expanded(
                    child: PageView(
                      controller: pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Contractor(stage),
                        Customer(stage),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
