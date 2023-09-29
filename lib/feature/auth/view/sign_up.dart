import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/view/contractor_register_page.dart';
import 'package:just_do_it/feature/auth/view/customer_register_page.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  int type = 1;
  bool state = false;
  PageController pageController = PageController();
  int stageRegistragion = 1;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CountriesBloc>(context).add(GetCountryEvent());
  }

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
    double widthTabBarItem = (MediaQuery.of(context).size.width - 48.w) / 2;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          SizedBox(height: 60.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: '${'registration'.tr()} ',
                        style: CustomTextStyle.black_22_w700,
                      ),
                      TextSpan(
                        text: '$stageRegistragion/2',
                        style: CustomTextStyle.grey_22_w700,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Container(
              height: 40.h,
              decoration: BoxDecoration(
                color: ColorStyles.greyE0E6EE,
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
                                'customer'.tr(),
                                style: state
                                    ? CustomTextStyle.black_14_w400_171716
                                    : CustomTextStyle.white_14_w400,
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
                                'executor'.tr(),
                                style: state
                                    ? CustomTextStyle.white_14_w400
                                    : CustomTextStyle.black_14_w400_171716,
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
          ),
          SizedBox(height: 50.h),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: PageView(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  CustomerRegisterPage(stage),
                  ContractorRegisterPage(stage),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
