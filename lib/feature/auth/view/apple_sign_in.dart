import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/sign_in_button.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.apple,
      buttonText: 'Sign in with Apple',
      onPressed: () async {
        try {
          final appleSignInResult = await signInWithApple(context: context);
          if (appleSignInResult.isNotEmpty) {
            if (!context.mounted) return;

            context.read<AuthBloc>().add(AppleSignInEvent(
                  email: appleSignInResult['email'] ?? "",
                  firstname: appleSignInResult['firstname'] ?? "",
                  lastname: appleSignInResult['lastname'] ?? "",
                  fcmToken: appleSignInResult['fcm_token'] ?? "",
                ));
          } else {
            log('Apple Sign-In: Missing email or name.');
          }
        } catch (error) {
          log('Error during Apple Sign-In: $error');
        }
      },
    );
  }
}

Future<Map<String, String?>> signInWithApple(
    {required BuildContext context}) async {
  try {
    AppleAuthProvider appleProvider = AppleAuthProvider();
    appleProvider.addScope('email');
    appleProvider.addScope('name');

    final credential =
        await FirebaseAuth.instance.signInWithProvider(appleProvider);

    final fcmToken = await getFCMToken();

    final data = {
      'email': credential.user?.email,
      'firstname': credential.user?.displayName?.split(' ').first ?? 'User',
      'lastname': credential.user?.displayName?.split(' ').last ?? 'User',
      'fcm_token': fcmToken,
    };

    return data;
  } catch (e) {
    debugPrint(e.toString());
    rethrow;
  }
}

Future<String> getFCMToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  return fcmToken ?? '';
}
