import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
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
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 110.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 80.w),
                  child: SvgPicture.asset(
                    SvgImg.justDoIt,
                    height: 38.h,
                  ),
                ),
                SizedBox(height: 82.h),
                forgotPassword ? secondStage() : firstStage(),
                const Spacer(),
                Column(
                  children: [
                    CustomButton(
                      onTap: () {},
                      textLabel: Text(
                        forgotPassword ? 'Отправить' : 'Войти',
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFPro'),
                      ),
                      btnColor: yellow,
                    ),
                    SizedBox(height: 18.h),
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
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'SFPro'),
                      ),
                      btnColor: const Color(0xFFE0E6EE),
                    ),
                  ],
                ),
                SizedBox(height: 34.h),
              ],
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
            fontWeight: FontWeight.w700,
            color: const Color(0xFF171716),
          ),
        ),
        SizedBox(height: 18.h),
        CustomTextField(
          hintText: '   Телефон или E-mail',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 18.h),
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
        SizedBox(height: 30.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  forgotPassword = true;
                });
              },
              child: Text(
                'Забыли пароль?',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 12.sp,
                  fontFamily: 'SFPro',
                  color: const Color(0xFF515150),
                ),
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
            fontWeight: FontWeight.w700,
            fontFamily: 'SFPro',
          ),
        ),
        SizedBox(height: 18.h),
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
              fontWeight: FontWeight.w400,
              fontSize: 12.sp,
              color: const Color(0xFF515150),
              fontFamily: 'SFPro',
            ),
          ),
        )
      ],
    );
  }
}
