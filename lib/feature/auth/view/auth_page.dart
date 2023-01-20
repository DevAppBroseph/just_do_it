import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/logo.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/helpers/router.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _MainAuthPageState();
}

class _MainAuthPageState extends State<AuthPage> {
  final visiblePasswordController = StreamController<bool>();
  bool visiblePassword = false;
  bool forgotPassword = false;

  @override
  void dispose() {
    visiblePasswordController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  const Logo(),
                  const Spacer(),
                  forgotPassword ? secondStage() : firstStage(),
                  // SizedBox(height: 40.h),
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(
                  //       'Или с помощью социальных сетей',
                  //       style: TextStyle(color: Colors.grey[400]!),
                  //     ),
                  //     SizedBox(height: 15.h),
                  //     Row(
                  //       children: [
                  //         SizedBox(
                  //           height: 60.h,
                  //           child: ListView.builder(
                  //             scrollDirection: Axis.horizontal,
                  //             itemCount: 5,
                  //             shrinkWrap: true,
                  //             itemBuilder: (context, index) {
                  //               return Padding(
                  //                 padding: EdgeInsets.only(
                  //                     left: index == 0 ? 0 : 8.0),
                  //                 child: Stack(
                  //                   alignment: Alignment.center,
                  //                   children: [
                  //                     ScaleButton(
                  //                       duration:
                  //                           const Duration(milliseconds: 50),
                  //                       bound: 0.1,
                  //                       child: Container(
                  //                         decoration: BoxDecoration(
                  //                             color: Colors.white,
                  //                             borderRadius:
                  //                                 BorderRadius.circular(15.r)),
                  //                         width: 60.h,
                  //                         height: 60.h,
                  //                         child: const Icon(
                  //                             Icons.scuba_diving_outlined),
                  //                       ),
                  //                     ),
                  //                   ],
                  //                 ),
                  //               );
                  //             },
                  //           ),
                  //         ),
                  //       ],
                  //     )
                  //   ],
                  // ),
                  const Spacer(),
                  Column(
                    children: [
                      CustomButton(
                        onTap: () {},
                        textLabel: Text(
                          forgotPassword ? 'Отправить' : 'Войти',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        btnColor: Colors.yellow[600]!,
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        onTap: () {
                          if (forgotPassword) {
                            setState(() {
                              forgotPassword = false;
                            });
                          } else {
                            Navigator.of(context).pushNamed(AppRoute.signUp);
                          }
                        },
                        textLabel: Text(
                          forgotPassword ? 'Назад' : 'Регистрация',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        btnColor: Colors.grey[200]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget firstStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Вход',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Телефон или E-mail',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Пароль',
          height: 50.h,
          suffixIcon: GestureDetector(
            onTap: () {
              visiblePassword = !visiblePassword;
              setState(() {});
            },
            child: visiblePassword
                ? const Icon(Icons.remove_red_eye_outlined)
                : const Icon(Icons.remove_red_eye),
          ),
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  forgotPassword = true;
                });
              },
              child: const Text(
                'Забыли пароль?',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget secondStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Восстановление доступа',
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Телефон или E-mail',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 85.h,
          child: Text(
            'Для сбросы пароля, введите номер Телефона или\nE-mail который был указан при регистрации.',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              fontSize: 11.sp,
            ),
          ),
        )
      ],
    );
  }
}
