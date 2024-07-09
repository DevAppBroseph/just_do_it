import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';

class UsedForRegistrationCheckbox extends StatelessWidget {
  const UsedForRegistrationCheckbox(
      {super.key, required this.isSelected, required this.onSelected});

  final bool isSelected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h, bottom: 16.h),
      child: GestureDetector(
        onTap: onSelected,
        child: Row(
          children: [
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
            const SizedBox(width: 8),
            Text(
              'is_used_for_registration'.tr(),
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? SettingsScope.themeOf(context).theme.mode ==
                            ThemeMode.dark
                        ? LightAppColors.whitePrimary
                        : DarkAppColors.blackPrima
                    : SettingsScope.themeOf(context).theme.mode ==
                            ThemeMode.dark
                        ? LightAppColors.whitePrimary
                        : DarkAppColors.blackPrima,
              ),
            )
          ],
        ),
      ),
    );
  }
}
