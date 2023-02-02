import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:pinput/pinput.dart';

class ConfirmCodePage extends StatefulWidget {
  final String phone;
  const ConfirmCodePage({super.key, required this.phone});

  @override
  State<ConfirmCodePage> createState() => _ConfirmCodePageState();
}

class _ConfirmCodePageState extends State<ConfirmCodePage> {
  TextEditingController codeController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Timer? timer;
  int currentSecond = 59;
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
        if (current is AuthSendCodeState) {
          Navigator.of(context).pushNamed(AppRoute.home);
        }
        return false;
      }, builder: (context, snapshot) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                SizedBox(height: 60.h),
                Row(
                  children: [
                    Text(
                      'Подтверждение телефона ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'SFPro',
                      ),
                    )
                  ],
                ),
                SizedBox(height: 143.h),
                Column(
                  children: [
                    Text(
                      'Код подтверждения отправлен на\n${widget.phone}',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: const Color(0xFF171716),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SFPro',
                      ),
                    ),
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
                        defaultPinTheme: PinTheme(
                          width: 77.h,
                          height: 70.h,
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10)),
                          textStyle: TextStyle(
                            fontSize: 24.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF171716),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Повторно отправить код ',
                            style: TextStyle(
                              color: const Color(0xFFDADADA),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SFPro',
                            ),
                          ),
                          TextSpan(
                            text: '$currentSecond сек.',
                            style: TextStyle(
                              color: const Color(0xFF171716),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'SFPro',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  children: [
                    SizedBox(height: 20.h),
                    CustomButton(
                      onTap: () => BlocProvider.of<AuthBloc>(context).add(
                          ConfirmCodeEvent(widget.phone, codeController.text)),
                      btnColor: yellow,
                      textLabel: Text(
                        'Подтвердить',
                        style: TextStyle(
                          color: const Color(0xFF171716),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 18.h),
                    CustomButton(
                      onTap: () => Navigator.of(context).pop(),
                      btnColor: const Color(0xFFE0E6EE),
                      textLabel: Text(
                        'Назад',
                        style: TextStyle(
                          color: const Color(0xFF515150),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 34.h),
              ],
            ),
          ),
        );
      }),
    );
  }
}
