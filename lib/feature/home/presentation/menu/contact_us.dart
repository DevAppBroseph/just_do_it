import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/formatter_upper.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class ContactUs extends StatefulWidget {
  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerTheme = TextEditingController();
  TextEditingController controllerMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
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
                              'Связаться с нами',
                              style: CustomTextStyle.black_22_w700,
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
                    hintText: 'Контактный E-mail',
                    textEditingController: controllerEmail,
                    fillColor: ColorStyles.greyF9F9F9,
                    contentPadding: EdgeInsets.all(18.h),
                  ),
                ),
                SizedBox(height: 19.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: CustomTextField(
                    height: 50.h,
                    width: 327.w,
                    hintText: 'Тема обращения',
                     formatters: [
                            UpperEveryTextInputFormatter()
                          ],
                    textEditingController: controllerTheme,
                    fillColor: ColorStyles.greyF9F9F9,
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
                          color: ColorStyles.greyF9F9F9,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: CustomTextField(
                          hintText: 'Ваше сообщение',
                          formatters: [
                            UpperEveryTextInputFormatter()
                          ],
                          textEditingController: controllerMessage,
                          fillColor: ColorStyles.greyF9F9F9,
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
                    onTap: () {},
                    btnColor: ColorStyles.yellowFFD70B,
                    textLabel: Text(
                      'Отправить',
                      style: CustomTextStyle.black_16_w600_171716,
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
                              data: MediaQuery.of(context)
                                  .copyWith(textScaleFactor: 1.0),
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
      ),
    );
  }
}
