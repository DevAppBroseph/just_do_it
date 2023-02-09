import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
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

  TextEditingController loginController = TextEditingController();
  TextEditingController signinLoginController = TextEditingController();
  TextEditingController signinPasswordController = TextEditingController();

  FocusNode focusNodeLogin = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  FocusNode focusNodeResetLogin = FocusNode();

  @override
  void dispose() {
    visiblePasswordController.close();
    super.dispose();
  }

  void requestStage1() {
    if (signinLoginController.text.isEmpty) {
      focusNodeLogin.requestFocus();
    } else if (signinPasswordController.text.isEmpty) {
      focusNodePassword.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
        if (current is ResetPasswordSuccessState) {
          Navigator.of(context).pushNamed(AppRoute.confirmCode,
              arguments: [loginController.text, false]);
        } else if (current is ResetPasswordErrorState) {
          showAlertToast('Пользователь не найден');
        } else if (current is SignInSuccessState) {
          BlocProvider.of<ProfileBloc>(context).setAccess(current.access);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRoute.home, ((route) => false));
        } else if (current is SignInErrorState) {
          showAlertToast('Введены неверные данные или пользователь не найден');
        }
        return false;
      }, builder: (context, snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 50.h),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          if (forgotPassword) {
                            forgotPassword = !forgotPassword;
                            setState(() {});
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
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
                        onTap: () {
                          if (forgotPassword &&
                              loginController.text.isNotEmpty) {
                            BlocProvider.of<AuthBloc>(context)
                                .add(RestoreCodeEvent(loginController.text));
                          } else {
                            BlocProvider.of<AuthBloc>(context).add(SignInEvent(
                                signinLoginController.text,
                                signinPasswordController.text));
                          }
                        },
                        textLabel: Text(
                          forgotPassword ? 'Отправить' : 'Войти',
                          style: CustomTextStyle.black_14_w600_171716,
                        ),
                        btnColor: ColorStyles.yellowFFD70A,
                      ),
                      SizedBox(height: 18.h),
                      CustomButton(
                        onTap: () {
                          if (forgotPassword) {
                            setState(() {
                              loginController.text = '';
                              forgotPassword = false;
                            });
                          } else {
                            Navigator.of(context).pushNamed(AppRoute.signUp);
                          }
                        },
                        textLabel: Text(
                          forgotPassword ? 'Назад' : 'Регистрация',
                          style: CustomTextStyle.black_14_w600_515150,
                        ),
                        btnColor: ColorStyles.greyE0E6EE,
                      ),
                    ],
                  ),
                  SizedBox(height: 34.h),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget firstStage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Вход',
          style: CustomTextStyle.black_20_w700,
        ),
        SizedBox(height: 18.h),
        CustomTextField(
          hintText: 'Телефон или E-mail',
          height: 50.h,
          focusNode: focusNodeLogin,
          textEditingController: signinLoginController,
          hintStyle: CustomTextStyle.grey_12_w400,
          onFieldSubmitted: (value) {
            requestStage1();
          },
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        ),
        SizedBox(height: 18.h),
        CustomTextField(
          hintText: 'Пароль',
          height: 50.h,
          focusNode: focusNodePassword,
          obscureText: !visiblePassword,
          onFieldSubmitted: (value) {
            requestStage1();
          },
          suffixIcon: GestureDetector(
            onTap: () {
              visiblePassword = !visiblePassword;
              setState(() {});
            },
            child: visiblePassword
                ? const Icon(Icons.remove_red_eye_outlined)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye_close.svg',
                        height: 18.h,
                      ),
                    ],
                  ),
          ),
          textEditingController: signinPasswordController,
          hintStyle: CustomTextStyle.grey_12_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
                style: CustomTextStyle.black_12_w400_515150,
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
          style: CustomTextStyle.black_20_w700,
        ),
        SizedBox(height: 18.h),
        CustomTextField(
          hintText: 'Телефон или E-mail',
          height: 50.h,
          focusNode: focusNodeResetLogin,
          textEditingController: loginController,
          hintStyle: CustomTextStyle.grey_12_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 85.h,
          child: Text(
            'Для сбросы пароля, введите номер Телефона или\nE-mail который был указан при регистрации.',
            style: CustomTextStyle.black_12_w400_515150,
          ),
        )
      ],
    );
  }
}
