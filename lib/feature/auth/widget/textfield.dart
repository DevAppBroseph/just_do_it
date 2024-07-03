import 'package:easy_localization/easy_localization.dart' as intl;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class CustomTextField extends StatelessWidget {
  final Function? onTap;
  final bool? readOnly;
  final FocusNode? focusNode;
  final TextInputAction? inputAction;
  final String hintText;
  final Icon? icon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final TextEditingController textEditingController;
  final TextCapitalization? textCapitalization;
  final Color? mainColor;
  final Color? bgColor;
  final int? maxLines;
  final List<TextInputFormatter>? formatters;
  final TextInputType? textInputType;
  final bool? obscureText;
  final FormFieldValidator<String>? validateFunction;
  final Widget? suffix;
  final Widget? suffixIcon;
  final String? suffixText;
  final Widget? prefixIcon;
  final String? prefixText;
  final bool? enabled;
  final Color? fillColor;
  final bool? autocorrect;
  double? height;
  double? width;
  TextStyle? hintStyle;
  TextStyle? style;
  EdgeInsets? contentPadding;
  bool dismissTap;
  bool actionButton;
  TextDirection? textDirection;
  CustomTextField({
    super.key,
    this.dismissTap = false,
    this.actionButton = true,
    this.onTap,
    this.readOnly,
    this.inputAction,
    this.focusNode,
    required this.hintText,
    this.icon,
    this.onChanged,
    this.onFieldSubmitted,
    required this.textEditingController,
    this.mainColor,
    this.bgColor,
    this.maxLines,
    this.formatters,
    this.textInputType,
    this.obscureText,
    this.validateFunction,
    this.suffix,
    this.suffixIcon,
    this.suffixText,
    this.prefixIcon,
    this.prefixText,
    this.enabled,
    this.fillColor,
    this.hintStyle,
    this.style,
    this.height,
    this.width,
    this.contentPadding = EdgeInsets.zero,
    this.textCapitalization,
    this.autocorrect,
    this.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    Color filColor = fillColor ??
        (SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
            ? DarkAppColors.blackSurface
            : LightAppColors.greyPrimary);
    height = height ?? 175.h;
    hintStyle = hintStyle ??
        CustomTextStyle.sf15w400(LightAppColors.greySecondary)
            .copyWith(overflow: TextOverflow.ellipsis);

    style = style ??
        SettingsScope.themeOf(context).theme.getStyle(
              (lightStyles) => lightStyles.sf13w400BlackSec.copyWith(
                overflow: TextOverflow.ellipsis,
              ),
              (darkStyles) => darkStyles.sf13w400BlackSec.copyWith(
                overflow: TextOverflow.ellipsis,
              ),
            );

    var widthOfScreen = width ?? MediaQuery.of(context).size.width;

    if (!actionButton) {
      return MediaQuery(
        data: MediaQuery.of(context)
            .copyWith(textScaler: const TextScaler.linear(1.0)),
        child: SizedBox(
          key: key,
          height: height,
          width: widthOfScreen,
          child: TextFormField(
            textDirection: textDirection,
            autocorrect: true,
            onFieldSubmitted: onFieldSubmitted,
            enabled: enabled,
            focusNode: focusNode,
            onTap: onTap as void Function()?,
            validator: validateFunction,
            readOnly: readOnly ?? false,
            textInputAction: inputAction,
            controller: textEditingController,
            onChanged: onChanged,
            obscureText: obscureText ?? false,
            maxLines: maxLines ?? 1,
            minLines: 1,
            inputFormatters: formatters,
            keyboardType: textInputType,
            style: style,
            decoration: InputDecoration(
              fillColor: filColor,
              icon: icon,
              prefixIcon: prefixIcon,
              suffixText: suffixText,
              suffix: suffix,
              prefixText: prefixText,
              prefixStyle: CustomTextStyle.sf17w400(Colors.grey[400]!).copyWith(
                overflow: TextOverflow.ellipsis,
              ),
              suffixIcon: suffixIcon,
              suffixStyle: CustomTextStyle.sf17w400(Colors.grey[400]!).copyWith(
                overflow: TextOverflow.ellipsis,
              ),
              errorStyle: CustomTextStyle.sf11w400(LightAppColors.blackPrimary),
              contentPadding: contentPadding,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                  style: BorderStyle.solid,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                    style: BorderStyle.solid,
                  )),
              hintStyle: hintStyle,
              hintText: hintText,
            ),
          ),
        ),
      );
    }
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: SizedBox(
        key: key,
        height: height,
        width: widthOfScreen,
        child: KeyboardActions(
          disableScroll: true,
          tapOutsideToDismiss: dismissTap,
          config: KeyboardActionsConfig(
            defaultDoneWidget: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(textScaler: const TextScaler.linear(1.0)),
                child: Text('done'.tr()),
              ),
            ),
            actions: [
              KeyboardActionsItem(
                focusNode: focusNode ?? FocusNode(),
                onTapAction: () => focusNode,
              ),
            ],
          ),
          child: TextFormField(
            textDirection: textDirection,
            autocorrect: true,
            onFieldSubmitted: onFieldSubmitted,
            enabled: enabled,
            focusNode: focusNode,
            onTap: onTap as void Function()?,
            validator: validateFunction,
            readOnly: readOnly ?? false,
            textInputAction: inputAction,
            controller: textEditingController,
            onChanged: onChanged,
            obscureText: obscureText ?? false,
            maxLines: maxLines ?? 1,
            minLines: 1,
            inputFormatters: formatters,
            keyboardType: textInputType,
            style: style,
            decoration: InputDecoration(
              fillColor: filColor,
              icon: icon,
              prefixIcon: prefixIcon,
              suffixText: suffixText,
              suffix: suffix,
              prefixText: prefixText,
              prefixStyle: CustomTextStyle.sf17w400(Colors.grey[400]!).copyWith(
                overflow: TextOverflow.ellipsis,
              ),
              suffixIcon: suffixIcon,
              suffixStyle: CustomTextStyle.sf17w400(Colors.grey[400]!).copyWith(
                overflow: TextOverflow.ellipsis,
              ),
              errorStyle: CustomTextStyle.sf12w400(LightAppColors.blackPrimary),
              contentPadding: contentPadding,
              filled: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                  style: BorderStyle.solid,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                  style: BorderStyle.solid,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: Colors.transparent,
                  width: 0.0,
                  style: BorderStyle.solid,
                ),
              ),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(
                    color: Colors.transparent,
                    width: 0.0,
                    style: BorderStyle.solid,
                  )),
              hintStyle: hintStyle,
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
