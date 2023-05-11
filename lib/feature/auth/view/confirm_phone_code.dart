import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:pinput/pinput.dart';

class ConfirmCodePhonePage extends StatefulWidget {
  final String phone;
  const ConfirmCodePhonePage({
    super.key,
    required this.phone,
  });

  @override
  State<ConfirmCodePhonePage> createState() => _ConfirmCodePhonePageState();
}

class _ConfirmCodePhonePageState extends State<ConfirmCodePhonePage> {
  TextEditingController codeController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordRepeatController = TextEditingController();
  FocusNode focusNode = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  FocusNode focusNodePasswordRepeat = FocusNode();
  Timer? timer;
  int currentSecond = 59;
  bool confirmCode = false;

  void _startTimer() {
    if (timer == null || !timer!.isActive) {
      currentSecond = 59;
      timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (currentSecond == 0) {
            timer.cancel();
          } else {
            currentSecond -= 1;
          }
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    BlocProvider.of<ProfileBloc>(context).setAccess(null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          Loader.hide();
          if (current is EditPasswordSuccessState) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoute.home, ((route) => false));
          } else if (current is EditPasswordErrorState) {
            showAlertToast('Ошибка. Неправильный ввод пароля');
          } else if (current is ConfirmCodeResetSuccessState) {
            BlocProvider.of<ProfileBloc>(context).setAccess(current.access);
            confirmCode = true;
            return true;
          } else if (current is ConfirmCodeResetErrorState) {
            showAlertToast('Неверный код');
          }
          return false;
        },
        builder: (context, snapshot) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 60.h),
                    confirmCode ? secondStage() : firstStage(),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          CustomButton(
                            onTap: () async {
                              if (!confirmCode) {
                                if (codeController.text.isEmpty) {
                                  showAlertToast('Введите код');
                                } else {
                                  showLoaderWrapper(context);
                                  BlocProvider.of<AuthBloc>(context).add(
                                    ConfirmCodeResetEvent(
                                      widget.phone,
                                      codeController.text,
                                    ),
                                  );
                                }
                              } else {
                                if (passwordController.text.isEmpty ||
                                    passwordRepeatController.text.isEmpty) {
                                  showAlertToast('Укажите пароль');
                                } else if (passwordController.text.length < 6) {
                                  showAlertToast(
                                      'Минимальная длина пароля 6 символов');
                                } else if ((passwordController
                                            .text.isNotEmpty &&
                                        passwordRepeatController
                                            .text.isNotEmpty) &&
                                    (passwordController.text !=
                                        passwordRepeatController.text)) {
                                  showAlertToast('Пароли не совпадают');
                                } else {
                                  final token = await FirebaseMessaging.instance.getToken();
                                  showLoaderWrapper(context);
                                  BlocProvider.of<AuthBloc>(context).add(
                                    EditPasswordEvent(
                                      passwordController.text,
                                      BlocProvider.of<ProfileBloc>(context)
                                          .access!, token.toString()
                                    ),
                                  );
                                }
                              }
                            },
                            btnColor: ColorStyles.yellowFFD70A,
                            textLabel: Text(
                              confirmCode ? 'Изменить пароль' : 'Подтвердить',
                              style: CustomTextStyle.black_16_w600_171716,
                            ),
                          ),
                          SizedBox(height: 18.h),
                          CustomButton(
                            onTap: () {
                              if (confirmCode) {
                                confirmCode = false;
                                BlocProvider.of<ProfileBloc>(context)
                                    .setAccess(null);
                                setState(() {});
                              } else {
                                Navigator.of(context).pop();
                              }
                            },
                            btnColor: ColorStyles.greyE0E6EE,
                            textLabel: Text(
                              'Назад',
                              style: CustomTextStyle.black_16_w600_515150,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 34.h),
                  ],
                ),
                if (MediaQuery.of(context).viewInsets.bottom > 0 &&
                    focusNode.hasFocus)
                  Column(
                    children: [
                      const Spacer(),
                      AnimatedPadding(
                        duration: const Duration(milliseconds: 0),
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                color: Colors.grey[200],
                                child: MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(textScaleFactor: 1.0),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: InkWell(
                                        onTap: () {
                                          focusNode.unfocus();
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 9.0,
                                              horizontal: 12.0,
                                            ),
                                            child: const Text('Готово')),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget firstStage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Подтверждение телефона ',
                style: CustomTextStyle.black_22_w700,
              )
            ],
          ),
        ),
        SizedBox(height: 143.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(children: [
                    TextSpan(
                      text: 'Код подтверждения отправлен на\n',
                      style: CustomTextStyle.black_16_w400_515150,
                    ),
                    TextSpan(
                      text: widget.phone,
                      style: CustomTextStyle.black_16_w400_171716,
                    ),
                  ])),
              SizedBox(height: 18.h),
              SizedBox(
                height: 70.h,
                child: Pinput(
                  pinAnimationType: PinAnimationType.none,
                  showCursor: false,
                  length: 4,
                  androidSmsAutofillMethod:
                      AndroidSmsAutofillMethod.smsRetrieverApi,
                  controller: codeController,
                  focusNode: focusNode,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  onChanged: (value) {
                    if (value.length == 4) focusNode.unfocus();
                  },
                  onTap: () {
                    setState(() {});
                  },
                  defaultPinTheme: PinTheme(
                    width: 77.h,
                    height: 70.h,
                    decoration: BoxDecoration(
                      color: ColorStyles.greyEAECEE,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: CustomTextStyle.black_26_w600_171716,
                  ),
                ),
              ),
              SizedBox(height: 40.h),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Повторно отправить код ',
                      style: CustomTextStyle.grey_16_w400,
                    ),
                    TextSpan(
                      text: '$currentSecond сек.',
                      style: CustomTextStyle.black_16_w400_171716,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget secondStage() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Изменение пароля ',
                style: CustomTextStyle.black_22_w700,
              )
            ],
          ),
        ),
        SizedBox(height: 143.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          'Придумайте новый пароль и никому\nне сообщайте его',
                      style: CustomTextStyle.black_16_w400_515150,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                hintText: 'Новый пароль',
                height: 50.h,
                obscureText: true,
                focusNode: focusNodePassword,
                textEditingController: passwordController,
                hintStyle: CustomTextStyle.grey_14_w400,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
              SizedBox(height: 18.h),
              CustomTextField(
                hintText: 'Новый пароль повторно',
                height: 50.h,
                obscureText: true,
                focusNode: focusNodePasswordRepeat,
                textEditingController: passwordRepeatController,
                hintStyle: CustomTextStyle.grey_14_w400,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ],
    );
  }
}
