import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleSignInButton extends StatelessWidget {
  const AppleSignInButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        try {
          final appleCredential = await SignInWithApple.getAppleIDCredential(
            scopes: [
              AppleIDAuthorizationScopes.email,
              AppleIDAuthorizationScopes.fullName,
            ],
          );

          final email = appleCredential.email ?? "";
          final firstname = appleCredential.givenName ?? "";
          final lastname = appleCredential.familyName ?? "";

          context
              .read<AuthBloc>()
              .add(AppleSignInEvent(email, firstname, lastname));
        } catch (error) {
          print('Error during Apple Sign-In: $error');
        }
      },
      child: Text('Sign in with Apple'),
    );
  }
}
