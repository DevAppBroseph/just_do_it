import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showAlertToast(String msg) {
  Fluttertoast.showToast(
    msg: msg,
    gravity: ToastGravity.TOP,
    backgroundColor: Colors.black,
    textColor: Colors.white,
    toastLength: Toast.LENGTH_LONG,
    timeInSecForIosWeb: 3,
    fontSize: 16,
  );
}

// void showSuccessAlertToast(String msg) {
//   Fluttertoast.showToast(
//       msg: '$msg',
//       timeInSecForIosWeb: 2,
//       gravity: ToastGravity.TOP,
//       backgroundColor: ColorStyles.primary,
//       textColor: Colors.white,
//       toastLength: Toast.LENGTH_LONG,
//       fontSize: 20,);
// }