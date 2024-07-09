import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/firebase/fcm.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/data/register_confirmation_method.dart';
import 'package:just_do_it/feature/auth/widget/phone_confirmation_method_selection_dialog.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
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
      String fcmToken = await getFcmToken() ?? '';
      authBloc.add(
        ConfirmCodeEvent(
          lastSendProfileEvent.userRegModel.phoneNumber ?? '',
          codeController.text,
          lastSendProfileEvent.userRegModel,
          lastSendProfileEvent.registerConfirmationMethod,
          authBloc.sendCodeServer ?? '',
          codeController.text,
          fcmToken,
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

    final selectedMethod = await showConfirmationMethodDialog(context);
    if (selectedMethod != null) {
      if (!mounted) return;

      lastSendProfileEvent = BlocProvider.of<AuthBloc>(context, listen: false)
          .updateConfirmationMethod(widget.sendProfileEvent, selectedMethod);

      showLoaderWrapper(context);
      String? code = await BlocProvider.of<AuthBloc>(context, listen: false)
          .sendCodeForConfirmation(lastSendProfileEvent);
      Loader.hide();
      if (code != null) {
        _startTimer();
      } else {
        customAlert.showMessage('invalid_code'.tr());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String title = '';
    String value = '';
    if (lastSendProfileEvent.registerConfirmationMethod ==
        RegisterConfirmationMethod.email) {
      title = '${'confrim_email'.tr()} ';
      value = lastSendProfileEvent.userRegModel.email ?? '';
    } else if (lastSendProfileEvent.registerConfirmationMethod ==
        RegisterConfirmationMethod.whatsapp) {
      title = '${'confrim_whatsapp'.tr()} ';
      value = lastSendProfileEvent.userRegModel.phoneNumber ?? '';
    } else {
      title = '${'confrim_phone'.tr()} ';
      value = lastSendProfileEvent.userRegModel.phoneNumber ?? '';
    }

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: BlocBuilder<AuthBloc, AuthState>(
        buildWhen: (previous, current) {
          Loader.hide();
          // if (current is SendProfileSuccessState) {
          //   lastSendProfileEvent = current.sendProfileEvent;
          // } else
          if (current is ConfirmCodeRegistrSuccessState) {
            BlocProvider.of<ProfileBloc>(context).setAccess(current.access);

            Navigator.of(context)
                .pushNamedAndRemoveUntil(AppRoute.home, ((route) => false));
            scoreDialogRegistration(context, '200', 'registrations'.tr());
            if (context.read<AuthBloc>().refCode != null) {
              scoreDialog(
                  context, '100', 'registrations_by_referral_link'.tr());
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
                            title,
                            style: CustomTextStyle.sf22w700(
                                LightAppColors.blackSecondary),
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
                                  style: SettingsScope.themeOf(context)
                                      .theme
                                      .getStyle(
                                          (lightStyles) =>
                                              lightStyles.sf17w400BlackSec,
                                          (darkStyles) =>
                                              darkStyles.sf17w400BlackSec),
                                ),
                                TextSpan(
                                  text: value,
                                  style: SettingsScope.themeOf(context)
                                      .theme
                                      .getStyle(
                                          (lightStyles) =>
                                              lightStyles.sf17w400BlackSec,
                                          (darkStyles) =>
                                              darkStyles.sf17w400BlackSec),
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
                                  color: LightAppColors.greyPrimary,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                textStyle: CustomTextStyle.sf22w700(
                                        LightAppColors.greySecondary)
                                    .copyWith(
                                  fontSize: 26,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.h),
                          GestureDetector(
                            onTap: resendCode,
                            child: RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${'resend_code'.tr()} ',
                                    style: SettingsScope.themeOf(context)
                                        .theme
                                        .getStyle(
                                            (lightStyles) =>
                                                lightStyles.sf17w400BlackSec,
                                            (darkStyles) =>
                                                darkStyles.sf17w400BlackSec)
                                        .copyWith(
                                          color: timer?.isActive ?? false
                                              ? LightAppColors.greyTernary
                                              : LightAppColors.blackError,
                                        ),
                                  ),
                                  if (timer?.isActive ?? false)
                                    TextSpan(
                                      text: '$currentSecond ${'sec'.tr()}.',
                                      style: SettingsScope.themeOf(context)
                                          .theme
                                          .getStyle(
                                              (lightStyles) =>
                                                  lightStyles.sf17w400BlackSec,
                                              (darkStyles) =>
                                                  darkStyles.sf17w400BlackSec),
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
                            btnColor: LightAppColors.yellowPrimary,
                            textLabel: Text(
                              'confirm'.tr(),
                              style: CustomTextStyle.sf17w600(
                                  LightAppColors.blackSecondary),
                            ),
                          ),
                          SizedBox(height: 18.h),
                          CustomButton(
                            onTap: () => Navigator.of(context).pop(),
                            btnColor: LightAppColors.greyError,
                            textLabel: Text(
                              'back'.tr(),
                              style: CustomTextStyle.sf17w400(
                                  LightAppColors.blackAccent),
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
                                  data: MediaQuery.of(context).copyWith(
                                      textScaler: const TextScaler.linear(1.0)),
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

  Future<RegisterConfirmationMethod?> showConfirmationMethodDialog(
      BuildContext context) async {
    return showDialog<RegisterConfirmationMethod>(
      context: context,
      builder: (context) {
        return PhoneConfirmationMethodSelectionDialog(
          user: widget.sendProfileEvent.userRegModel,
          token: widget.sendProfileEvent.token,
        );
      },
    );
  }
}
