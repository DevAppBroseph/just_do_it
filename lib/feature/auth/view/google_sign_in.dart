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
          if (!context.mounted) return;

          context.read<AuthBloc>().add(GoogleSignInEvent(idToken));
        }
      },
    );
  }
}
