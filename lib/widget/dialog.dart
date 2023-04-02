import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';

class MessageDialogs {
  void showMessage(String from, String message) {
    SmartDialog.showToast(
      message,
      displayTime: const Duration(seconds: 3),
      builder: (context) => Padding(
        padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
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
      alignment: Alignment.topLeft,
      maskColor: Colors.transparent,
    );
  }
}
