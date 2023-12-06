import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/data/register_confirmation_method.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:pinput/pinput.dart';

class ConfirmCodeRegisterPage extends StatefulWidget {
  // final String phone;
  final SendProfileEvent sendProfileEvent;
  const ConfirmCodeRegisterPage({
    super.key,
    required this.sendProfileEvent,
  });

  @override
  State<ConfirmCodeRegisterPage> createState() =>
      _ConfirmCodeRegisterPageState();
}

class _ConfirmCodeRegisterPageState extends State<ConfirmCodeRegisterPage> {
  late SendProfileEvent lastSendProfileEvent;

  TextEditingController codeController = TextEditingController();
  FocusNode focusNode = FocusNode();
  Timer? timer;
  int currentSecond = 59;

  CustomAlert customAlert = CustomAlert();

  void _startTimer() {
    timer?.cancel();
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
    lastSendProfileEvent = widget.sendProfileEvent;
    _startTimer();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  onTapConfirm() async {
    if (codeController.text.isNotEmpty) {
      showLoaderWrapper(context);

      final authBloc = BlocProvider.of<AuthBloc>(context, listen: false);
      authBloc.add(
        ConfirmCodeEvent(
          lastSendProfileEvent.userRegModel.phoneNumber ?? '',
          codeController.text,
          lastSendProfileEvent.userRegModel,
          lastSendProfileEvent.registerConfirmationMethod,
          authBloc.sendCodeServer ?? '',
          codeController.text,
        ),
      );
    } else {
      CustomAlert().showMessage('enter_the_code'.tr());
    }
  }

  resendCode() async {
    if (timer?.isActive ?? false) {
      customAlert.showMessage(
          '${'please_wait'.tr()}, $currentSecond ${'seconds'.tr()}');
      return;
    }

    showLoaderWrapper(context);
    String? code = await BlocProvider.of<AuthBloc>(context, listen: false)
        .sendCodeForConfirmation(widget.sendProfileEvent);
    Loader.hide();
    if (code != null) {
      _startTimer();
    } else {
      customAlert.showMessage('invalid_code'.tr());
    }
  }

  @override
  Widget build(BuildContext context) {
    // late final int refCode;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          Loader.hide();
          // if (current is SendProfileSuccessState) {
          //   lastSendProfileEvent = current.sendProfileEvent;
          // } else
          if (current is ConfirmCodeRegistrSuccessState) {
            BlocProvider.of<ProfileBloc>(context).setAccess(null);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoute.home, ((route) => false));
            scoreDialog(context, '50', 'registrations'.tr());
            if (context.read<AuthBloc>().refCode != null) {
              scoreDialog(
                  context, '200', 'registrations_by_referral_link'.tr());
            }
          } else if (current is ConfirmRestoreSuccessState) {
            BlocProvider.of<ProfileBloc>(context).setAccess(current.access);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoute.home, ((route) => false));
          } else if (current is ConfirmCodeRegisterErrorState) {
            CustomAlert().showMessage('invalid_code'.tr());
          } else if (current is ConfirmRestoreErrorState) {
            CustomAlert().showMessage('invalid_code'.tr());
          }
          return false;
        },
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(height: 60.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            lastSendProfileEvent.registerConfirmationMethod ==
                                    RegisterConfirmationMethod.email
                                ? '${'confrim_email'.tr()} '
                                : '${'confrim_phone'.tr()} ',
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
                                  text: '${'code_confirm_sent'.tr()}\n',
                                  style: CustomTextStyle.black_16_w400_515150,
                                ),
                                TextSpan(
                                  text: lastSendProfileEvent
                                              .registerConfirmationMethod ==
                                          RegisterConfirmationMethod.email
                                      ? widget
                                          .sendProfileEvent.userRegModel.email
                                      : lastSendProfileEvent
                                          .userRegModel.phoneNumber,
                                  style: CustomTextStyle.black_16_w400_171716,
                                ),
                              ],
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
                          GestureDetector(
                            // onTap: (){
                            //   resendCode();
                            // },
                            onTap: resendCode,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${'resend_code'.tr()} ',
                                    style: CustomTextStyle.grey_16_w400,
                                    // recognizer: TapGestureRecognizer()
                                    //   ..onTap = resendCode,
                                  ),
                                  TextSpan(
                                    text: '$currentSecond ${'sec'.tr()}.',
                                    style: CustomTextStyle.black_16_w400_171716,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: Column(
                        children: [
                          SizedBox(height: 20.h),
                          CustomButton(
                            onTap: onTapConfirm,
                            btnColor: ColorStyles.yellowFFD70A,
                            textLabel: Text(
                              'confirm'.tr(),
                              style: CustomTextStyle.black_16_w600_171716,
                            ),
                          ),
                          SizedBox(height: 18.h),
                          CustomButton(
                            onTap: () => Navigator.of(context).pop(),
                            btnColor: ColorStyles.greyE0E6EE,
                            textLabel: Text(
                              'back'.tr(),
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
                                            child: Text('done'.tr())),
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
}
