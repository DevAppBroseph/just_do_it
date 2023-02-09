import 'package:flutter/material.dart';
import 'package:just_do_it/feature/auth/view/auth_page.dart';
import 'package:just_do_it/feature/auth/view/confirm_phone.dart';
import 'package:just_do_it/feature/auth/view/sign_up.dart';
import 'package:just_do_it/feature/home/presentation/home_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/personal_account/personal_account.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/profile/profile_page.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/rating_page.dart';

class AppRoute {
  static const home = '/';
  static const auth = '/auth';
  static const signUp = '/signUp';
  static const confirmCode = '/confirmCode';
  static const forgotPassword = '/forgotPassword';
  static const personalAccount = '/forgotPassword';
  static const profile = '/profile';
  static const rating = '/rating';

  static Route<dynamic>? onGenerateRoute(RouteSettings route) {
    switch (route.name) {
      case home:
        return MaterialPageRoute(builder: (_) => HomePage());
      case rating:
        return MaterialPageRoute(builder: (_) => RatingPage());
      case auth:
        return MaterialPageRoute(builder: (_) => const AuthPage());
      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case confirmCode:
        final list = route.arguments as List<dynamic>;
        String phone = list[0] as String;
        bool register = list[1] as bool;
        return MaterialPageRoute(
            builder: (_) => ConfirmCodePage(phone: phone, register: register));
      case personalAccount:
        return MaterialPageRoute(builder: (_) => PersonalAccountPage());
      case profile:
        return MaterialPageRoute(builder: (_) => ProfilePage());
      default:
        return null;
    }
  }
}
