import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/sign_in_button.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SignInButton(
      buttonType: ButtonType.google,
      buttonText: 'Sign in with Google',
      onPressed: () async {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
        if (googleUser != null) {
          final GoogleSignInAuthentication googleAuth =
              await googleUser.authentication;
          final String idToken = googleAuth.idToken!;
          final String fcmToken = await getFCMToken();

          if (!context.mounted) return;

          context.read<AuthBloc>().add(GoogleSignInEvent(idToken, fcmToken));
        }
      },
    );
  }

  Future<String> getFCMToken() async {
    final fcmToken = await FirebaseMessaging.instance.getToken();
    return fcmToken ?? '';
  }
}
