import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/personal_chat.dart';

class MessageDialogs {
  // int tap = 0;
  void showMessage(
    String from,
    String message,
    BuildContext context1, {
    String? id,
    String? name,
    String? idWithChat,
    String? image,
  }) {
    SmartDialog.showToast(
      message,
      usePenetrate: false,
      clickMaskDismiss: true,
      consumeEvent: true,
      displayTime: const Duration(seconds: 3),
      builder: (context) => GestureDetector(
        onTap: () {
          if (id != null) {
            SmartDialog.dismiss(status: SmartStatus.allToast);
            Navigator.push(
              context1,
              MaterialPageRoute(
                builder: (context) => PersonalChat(
                  id,
                  name!,
                  idWithChat!,
                  image,
                ),
              ),
            );
          }
        },
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
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
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    minLeadingWidth: 10,
                    leading: SvgPicture.asset(
                      'assets/icons/chat.svg',
                      color: ColorStyles.yellowFFCA0D,
                      width: 30,
                      height: 30,
                    ),
                    title: Text(from),
                    subtitle: Text(message),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset('assets/icons/translate.svg'),
                        SizedBox(width: 8.h),
                        Text(
                          'Показать оригинал',
                          style: CustomTextStyle.blue_14_w400_336FEE,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      alignment: Alignment.topLeft,
      maskColor: Colors.transparent,
    );
  }
}

class TaskDialogs {
  // int tap = 0;
  void showTaskMessage(
    String message,
  ) {
    SmartDialog.showToast(
      message,
      usePenetrate: false,
      clickMaskDismiss: true,
      consumeEvent: true,
      displayTime: const Duration(seconds: 3),
      builder: (context) => GestureDetector(
        onTap: () {
          SmartDialog.dismiss(status: SmartStatus.allToast);
        },
        child: Container(
          margin: const EdgeInsets.only(top: 50, left: 20, right: 20),
          decoration: BoxDecoration(
            color: Colors.white,
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
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    minLeadingWidth: 10,
                    leading: SvgPicture.asset(
                      'assets/icons/chat.svg',
                      color: ColorStyles.yellowFFCA0D,
                      width: 30,
                      height: 30,
                    ),
                    title: Text(message),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SvgPicture.asset('assets/icons/translate.svg'),
                        SizedBox(width: 8.h),
                        Text(
                          'Показать оригинал',
                          style: CustomTextStyle.blue_14_w400_336FEE,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      alignment: Alignment.topLeft,
      maskColor: Colors.transparent,
    );
  }
}
