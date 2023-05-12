import 'dart:async';
import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:just_do_it/widget/back_icon_button_black.dart';

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
        Loader.hide();
        if (current is ResetPasswordSuccessState) {
          Navigator.of(context).pushNamed(AppRoute.confirmPhoneCode,
              arguments: [loginController.text]);
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
                      CustomIconButtonBlack(
                        onBackPressed: () {
                          if (forgotPassword) {
                            forgotPassword = !forgotPassword;
                            setState(() {});
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 50.w),
                    child: Center(
                      child: Text(
                        'jobyfine'.toUpperCase(),
                        style: CustomTextStyle.black_39_w900_171716,
                      ),
                    ),
                  ),
                  SizedBox(height: 82.h),
                  forgotPassword ? secondStage() : firstStage(),
                  const Spacer(),
                  Column(
                    children: [
                      CustomButton(
                        onTap: () async{
                          if (forgotPassword &&
                              loginController.text.isNotEmpty) {
                            showLoaderWrapper(context);
                            BlocProvider.of<AuthBloc>(context)
                                .add(RestoreCodeEvent(loginController.text));
                          } else {
                            final token = await FirebaseMessaging.instance.getToken();
                            showLoaderWrapper(context);
                            log(signinPasswordController.text);
                            BlocProvider.of<AuthBloc>(context).add(SignInEvent(
                                signinLoginController.text,
                                signinPasswordController.text, token.toString()));
                          }
                        },
                        textLabel: Text(
                          forgotPassword ? 'Отправить' : 'Войти',
                          style: CustomTextStyle.black_16_w600_171716,
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
                          style: CustomTextStyle.black_16_w600_515150,
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
          style: CustomTextStyle.black_22_w700,
        ),
        SizedBox(height: 18.h),
        CustomTextField(
          hintText: 'Телефон или E-mail',
          height: 50.h,
          focusNode: focusNodeLogin,
          textEditingController: signinLoginController,
          hintStyle: CustomTextStyle.grey_14_w400,
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
          hintStyle: CustomTextStyle.grey_14_w400,
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
                style: CustomTextStyle.black_14_w400_515150,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Восстановление доступа',
              style: CustomTextStyle.black_22_w700,
            ),
          ],
        ),
        SizedBox(height: 18.h),
        CustomTextField(
          hintText: 'Телефон или E-mail',
          height: 50.h,
          focusNode: focusNodeResetLogin,
          textEditingController: loginController,
          hintStyle: CustomTextStyle.grey_14_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 85.h,
          child: Text(
            'Для сброса пароля, введите номер телефона\nили E-mail, который был указан при регистрации.',
            style: CustomTextStyle.black_14_w400_515150,
          ),
        )
      ],
    );
  }
}
