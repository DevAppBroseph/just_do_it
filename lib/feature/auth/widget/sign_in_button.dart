import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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

    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
      ),
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          buttonText,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Roboto',
            color: Colors.black,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          disabledForegroundColor: Colors.grey.withOpacity(0.38),
          disabledBackgroundColor: Colors.grey.withOpacity(0.12),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}
