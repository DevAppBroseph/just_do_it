import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/feature/auth/data/register_confirmation_method.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/models/user_reg.dart';

Future<RegisterConfirmationMethod?> showPhoneConfirmationMethodSelectionDialog(
    BuildContext context, UserRegModel user, String token) async {
  final registerConfirmationMethod = await showDialog(
      context: context,
      builder: (context) {
        return PhoneConfirmationMethodSelectionDialog(
          user: user,
          token: token.toString(),
        );
      });
  return registerConfirmationMethod;
}

class PhoneConfirmationMethodSelectionDialog extends StatefulWidget {
  const PhoneConfirmationMethodSelectionDialog(
      {super.key, required this.user, required this.token});

  final UserRegModel user;
  final String token;

  @override
  State<PhoneConfirmationMethodSelectionDialog> createState() =>
      _PhoneConfirmationMethodSelectionDialogState();
}

class _PhoneConfirmationMethodSelectionDialogState
    extends State<PhoneConfirmationMethodSelectionDialog> {
  RegisterConfirmationMethod? registerConfirmationMethod;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white,
          ),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 32),
                SvgPicture.asset(
                  "assets/icons/password-check.svg",
                  height: 90,
                  width: 90,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Куда прислать код?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      registerConfirmationMethod = RegisterConfirmationMethod.phone;
                    });
                  },
                  child: _PhoneConfirmationMethodItemWidget(
                    icon: "assets/icons/sms.svg",
                    text: 'На телефон по SMS',
                    isSelected: registerConfirmationMethod == RegisterConfirmationMethod.phone,
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      registerConfirmationMethod = RegisterConfirmationMethod.whatsapp;
                    });
                  },
                  child: _PhoneConfirmationMethodItemWidget(
                    icon: "assets/icons/whatsapp.svg",
                    text: 'На WhatsApp',
                    isSelected: registerConfirmationMethod == RegisterConfirmationMethod.whatsapp,
                  ),
                ),
                const SizedBox(height: 40),
                CustomButton(
                    onTap: () {
                        Navigator.pop(context, registerConfirmationMethod);
                    },
                    btnColor: registerConfirmationMethod != null
                        ? const Color(0xffFFD70A)
                        : const Color(0xffDADADA),
                    textLabel: Text(
                      'Далее',
                      style: TextStyle(
                          color: registerConfirmationMethod != null
                              ? Colors.black
                              : const Color(0xff939393),
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
                const SizedBox(height: 24),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoneConfirmationMethodItemWidget extends StatelessWidget {
  const _PhoneConfirmationMethodItemWidget(
      {super.key, required this.icon, required this.text, required this.isSelected});

  final String icon;
  final String text;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xffEAECEE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            icon,
            height: 24,
            width: 24,
          ),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          SizedBox(
            height: 20,
            width: 20,
            child: isSelected
                ? DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xffFFCA0D),
                        width: 5,
                      ),
                      color: Colors.black,
                    ),
                  )
                : DecoratedBox(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xffDADADA),
                        width: 2,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
