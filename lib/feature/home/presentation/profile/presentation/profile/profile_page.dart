import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile/contractor_profile.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile/customer_profile.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int type = 1;

  bool state = false;

  PageController pageController = PageController();
  int stageRegistration = 1;

  @override
  Widget build(BuildContext context) {
    double widthTabBarItem = (MediaQuery.of(context).size.width - 40.w) / 2;
    double insetsBottom = MediaQuery.of(context).viewInsets.bottom;
    return Stack(
      children: [
        MediaQuery(
          data: const MediaQueryData(textScaleFactor: 1.0),
          child: Scaffold(
            backgroundColor: ColorStyles.whiteFFFFFF,
            body: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, snapshot) {
              return SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 60.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Профиль',
                              style: CustomTextStyle.black_22_w700,
                            ),
                          ),
                          CustomIconButton(
                            onBackPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: SvgImg.arrowRight,
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
                                  color: ColorStyles.yellowFFD70A,
                                  borderRadius: BorderRadius.only(
                                    topLeft: !state
                                        ? Radius.circular(20.r)
                                        : Radius.zero,
                                    bottomLeft: !state
                                        ? Radius.circular(20.r)
                                        : Radius.zero,
                                    topRight: state
                                        ? Radius.circular(20.r)
                                        : Radius.zero,
                                    bottomRight: state
                                        ? Radius.circular(20.r)
                                        : Radius.zero,
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
                                                stageRegistration = 1;
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
                                        child: Text('Как исполнитель',
                                            style: CustomTextStyle
                                                .black_14_w400_171716),
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
                                                stageRegistration = 1;
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
                                          'Как заказчик',
                                          style: CustomTextStyle
                                              .black_14_w400_171716,
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
                      child: PageView(
                        controller: pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          ContractorProfile(padding: insetsBottom),
                          CustomerProfile(),
                        ],
                      ),
                    )
                  ],
                ),
              );
            }),
          ),
        ),
        if (MediaQuery.of(context).viewInsets.bottom > 0)
          Positioned(
            bottom: insetsBottom,
            child: Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[200],
              child: Row(
                children: [
                  Spacer(),
                  CupertinoButton(
                      child: Text(
                        'Готово',
                        style: TextStyle(color: Colors.black, fontSize: 13.sp),
                      ),
                      onPressed: () {
                        var bloc = BlocProvider.of<ProfileBloc>(context);
                        FocusScope.of(context).unfocus();
                        bloc.add(
                          UpdateProfileWithoutUserEvent(),
                        );
                      })
                ],
              ),
            ),
          ),
      ],
    );
  }
}
