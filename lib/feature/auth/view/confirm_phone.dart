import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:pinput/pinput.dart';

class ConfirmCodePage extends StatefulWidget {
  const ConfirmCodePage({super.key});

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
                      Text(
                        'Подтверждение телефона ',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 21.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      Text(
                        'Код подтверждения отправлен на\n+7 (999) *** **-32',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        height: 60.h,
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
                            if (value.length == 4) {
                              focusNode.unfocus();
                            }
                          },
                          defaultPinTheme: PinTheme(
                            width: 60.sp,
                            height: 60.sp,
                            decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(10)),
                            textStyle: TextStyle(
                              fontSize: 30.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color.fromRGBO(23, 23, 23, 1.0),
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
                                color: Colors.grey[300],
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            TextSpan(
                              text: '$currentSecond сек.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w400,
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
                        onTap: () =>
                            Navigator.of(context).pushNamed(AppRoute.home),
                        btnColor: Colors.yellow[600]!,
                        textLabel: Text(
                          'Подтвердить',
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomButton(
                        onTap: () => Navigator.of(context).pop(),
                        btnColor: Colors.grey[200]!,
                        textLabel: Text(
                          'Назад',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
