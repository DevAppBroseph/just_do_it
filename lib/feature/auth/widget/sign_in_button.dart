import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';

enum ButtonType { google, apple }

class SignInButton extends StatelessWidget {
  final ButtonType buttonType;
  final String buttonText;
  final VoidCallback onPressed;

  const SignInButton({
    super.key,
    required this.buttonType,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Widget icon = buttonType == ButtonType.google
        ? SvgPicture.asset('assets/icons/google.svg', width: 20, height: 20)
        : SvgPicture.asset('assets/icons/apple.svg', width: 20, height: 20);

    return Container(
      decoration: BoxDecoration(
        color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
            ? DarkAppColors.whitePrimary
            : LightAppColors.whitePrimary,
        borderRadius: BorderRadius.circular(40),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        child: icon,
      ),
    );
  }
}
