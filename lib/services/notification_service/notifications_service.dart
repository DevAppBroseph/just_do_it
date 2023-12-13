import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:just_do_it/core/firebase/fcm.dart';
import 'package:just_do_it/firebase_options.dart';
import 'package:just_do_it/services/notification_service/i_notifications_service.dart';

class NotificationService implements INotificationService {
  Future<void> inject() async {
    try {
      debugPrint('initing firebase notification service...');
      final plugin = FlutterLocalNotificationsPlugin();
      // await fcmInit(plugin);
      await getToken();
      await plugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(const AndroidNotificationChannel(
            'default_notification_channel',
            'Notifications',
            description: 'This channel is used for notifications.',
            importance: Importance.max,
          ));

      await plugin.initialize(
        const InitializationSettings(
          android: AndroidInitializationSettings('app_icon'),
          iOS: DarwinInitializationSettings(),
        ),
      );
      listener(plugin: plugin);
      onTapWhenAppBg(
        onTap: () {},
      );
    } catch (e) {
      debugPrint('error initing firebase local notifications: $e');
    }
  }

  @override
  Future<void> fcmInit(FlutterLocalNotificationsPlugin plugin) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseMessaging fcm = FirebaseMessaging.instance;
    final result = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  @override
  Future getToken() async {
    final token = await getFcmToken();
    return token;
  }

  @override
  Future<void> listener({FlutterLocalNotificationsPlugin? plugin}) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;
      if (notification != null) {
        plugin?.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            iOS: DarwinNotificationDetails(),
            android: AndroidNotificationDetails(
              'default_notification_channel',
              'Notifications',
              channelDescription: 'This channel is used for notifications.',
              // icon: SvgImg.justDoIt,
            ),
          ),
        );
      }
    });
  }

  @override
  Future<void> backgroundHandler() async {
    FirebaseMessaging.onBackgroundMessage(
      (RemoteMessage message) async {
        if (Platform.isIOS) {
          await Firebase.initializeApp(options: DefaultFirebaseOptions.ios);
        } else {
          await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
        }
      },
    );
  }

  @override
  Future<void> onTapWhenAppBg({Function()? onTap}) async {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      onTap;
    });
  }

  @override
  Future<void> onTapWhenAppClosed({Function()? onTap}) async {
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        onTap;
      }
    });
  }
}
