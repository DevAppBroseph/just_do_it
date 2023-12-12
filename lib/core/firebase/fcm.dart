import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';

Future<String?> getFcmToken() async {
  try {
    final token = await FirebaseMessaging.instance.getToken();
    return token;
  } catch (e) {
    debugPrint(e.toString());
    return null;
  }
}
