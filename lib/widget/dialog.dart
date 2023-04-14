import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/personal_chat.dart';
import 'package:just_do_it/feature/home/presentation/welcom/welcom_page.dart';
import 'package:scale_button/scale_button.dart';

class MessageDialogs {
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
      // clickMaskDismiss: true,
      usePenetrate: false,
      clickMaskDismiss: true,
      consumeEvent: true,
      displayTime: const Duration(seconds: 3),
      builder: (context) => GestureDetector(
        onTap: () {
          if (id != null) {
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
          child: Container(
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 10,
                  spreadRadius: 3,
                  color: Color.fromRGBO(26, 42, 97, 0.06),
                ),
              ],
            ),
            child: Card(
              elevation: 0,
              child: ListTile(
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
            ),
          ),
        ),
      ),
      alignment: Alignment.topLeft,
      maskColor: Colors.transparent,
    );
  }
}
