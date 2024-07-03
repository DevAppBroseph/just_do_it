import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/widget/formatter_upper.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class ContactUs extends StatefulWidget {
  final String name;
  final String theme;
  const ContactUs({super.key, required this.name, required this.theme});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerTheme = TextEditingController();
  TextEditingController controllerMessage = TextEditingController();
  @override
  void initState() {
    super.initState();
    controllerMessage.text = widget.name;
    controllerTheme.text = widget.theme;
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor:
            SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                ? DarkAppColors.whitePrimary
                : LightAppColors.whitePrimary,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 70.h),
                Padding(
                  padding: EdgeInsets.only(left: 25.w, right: 28.w),
                  child: SizedBox(
                    height: 35.h,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        CustomIconButton(
                          onBackPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: SvgImg.arrowRight,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'contact_us'.tr(),
                              style: SettingsScope.themeOf(context)
                                  .theme
                                  .getStyle(
                                      (lightStyles) =>
                                          lightStyles.sf22w700BlackSec,
                                      (darkStyles) =>
                                          darkStyles.sf22w700BlackSec),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 40.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomTextField(
                    height: 50.h,
                    width: 327.w,
                    hintText: 'contact_email'.tr(),
                    textEditingController: controllerEmail,
                    fillColor: SettingsScope.themeOf(context).theme.mode ==
                            ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.greyActive,
                    contentPadding: EdgeInsets.all(18.h),
                  ),
                ),
                SizedBox(height: 19.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomTextField(
                    height: 50.h,
                    width: 327.w,
                    hintText: 'subject_appeal'.tr(),
                    formatters: [UpperEveryTextInputFormatter()],
                    textEditingController: controllerTheme,
                    fillColor: SettingsScope.themeOf(context).theme.mode ==
                            ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.greyActive,
                    contentPadding: EdgeInsets.all(18.h),
                  ),
                ),
                SizedBox(height: 19.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      Container(
                        height: 130.h,
                        width: 327.w,
                        decoration: BoxDecoration(
                          color: SettingsScope.themeOf(context).theme.mode ==
                                  ThemeMode.dark
                              ? DarkAppColors.blackSurface
                              : LightAppColors.greyActive,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: CustomTextField(
                          hintText: 'your_message'.tr(),
                          formatters: [UpperEveryTextInputFormatter()],
                          textEditingController: controllerMessage,
                          fillColor:
                              SettingsScope.themeOf(context).theme.mode ==
                                      ThemeMode.dark
                                  ? DarkAppColors.blackSurface
                                  : LightAppColors.greyActive,
                          contentPadding: EdgeInsets.all(18.h),
                          maxLines: 6,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomButton(
                    onTap: () {
                      String error = 'specify'.tr();
                      bool errorsFlag = false;
                      bool emailValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(controllerEmail.text);

                      if (!emailValid && controllerEmail.text.isNotEmpty) {
                        error += '\n- ${'correct_email'.tr()}';
                        errorsFlag = true;
                      }
                      if (controllerTheme.text.isEmpty) {
                        error +=
                            '\n- ${'subject_appeal_second'.tr().toLowerCase()}';
                        errorsFlag = true;
                      }
                      if (controllerMessage.text.isEmpty) {
                        error += '\n- ${'description'.tr().toLowerCase()}';
                        errorsFlag = true;
                      }
                      if (errorsFlag == true) {
                        CustomAlert().showMessage(error);
                      } else {
                        Repository().sendMessageToSupport(
                            BlocProvider.of<ProfileBloc>(context).access,
                            controllerEmail.text,
                            controllerMessage.text,
                            controllerTheme.text);
                        CustomAlert()
                            .showMessage('the_message_has_been_sent'.tr());
                        controllerTheme.text = '';
                        controllerEmail.text = '';
                        controllerMessage.text = '';
                      }
                    },
                    btnColor: LightAppColors.yellowSecondary,
                    textLabel: Text(
                      'send'.tr(),
                      style: CustomTextStyle.sf17w600(
                          LightAppColors.blackSecondary),
                    ),
                  ),
                ),
                SizedBox(height: 34.h),
              ],
            ),
            if (MediaQuery.of(context).viewInsets.bottom > 0)
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
                                      FocusScope.of(context).unfocus();
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
      ),
    );
  }
}
