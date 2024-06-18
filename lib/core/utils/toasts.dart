import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';

class CustomAlert {
  void showMessage(
    String text, {
    String? id,
    String? name,
    String? idWithChat,
    String? image,
  }) {
    SmartDialog.showToast(
      text,
      usePenetrate: false,
      clickMaskDismiss: true,
      consumeEvent: true,
      displayTime: const Duration(seconds: 3),
      builder: (context) => Container(
        margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(10.r),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 10,
              spreadRadius: 3,
              color: Color.fromRGBO(26, 42, 97, 0.06),
            ),
          ],
        ),
        child: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
          child: Padding(
            padding: EdgeInsets.all(10.h),
            child: Text(
              text,
              style: CustomTextStyle.sf17w400(AppColors.whitePrimary),
            ),
          ),
        ),
      ),
      alignment: Alignment.topCenter,
      maskColor: Colors.transparent,
    );
  }
}
