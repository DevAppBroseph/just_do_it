import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
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
  final Widget? prefixicon;
  final String? prefixText;
  final bool? enabled;
  final Color? fillColor;
  double? height;
  double? width;
  TextStyle? hintStyle;
  TextStyle? style;
  EdgeInsets? contentPadding;
  bool dismisTap;
  bool actionButton;
  CustomTextField({
    Key? key,
    this.dismisTap = false,
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
    this.prefixicon,
    this.prefixText,
    this.enabled,
    this.fillColor,
    this.hintStyle,
    this.style,
    this.height,
    this.width,
    this.contentPadding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    Color filColor = fillColor ?? ColorStyles.greyEAECEE;
    Color hintTextColor = Colors.grey[400]!;
    height = height ?? 175.h;
    hintStyle = hintStyle ??
        CustomTextStyle.grey_13_w400.copyWith(overflow: TextOverflow.ellipsis);

    style = style ??
        TextStyle(
          fontSize: 12.sp,
          color: Colors.black,
          overflow: TextOverflow.ellipsis,
        );

    var widthOfScreen = width ?? MediaQuery.of(context).size.width;

    if (!actionButton) {
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: SizedBox(
          key: key,
          height: height,
          width: widthOfScreen,
          child: TextFormField(
            // key: key,
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
              prefixIcon: prefixicon,
              suffixText: suffixText,
              suffix: suffix,
              prefixText: prefixText,
              prefixStyle: const TextStyle(
                  fontSize: 14.5,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis),
              suffixIcon: suffixIcon,
              suffixStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                color: hintTextColor,
                fontWeight: FontWeight.w400,
              ),
              errorStyle: const TextStyle(fontSize: 10.0),
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
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: SizedBox(
        key: key,
        height: height,
        width: widthOfScreen,
        child: KeyboardActions(
          disableScroll: true,
          tapOutsideToDismiss: dismisTap,
          config: KeyboardActionsConfig(
            defaultDoneWidget: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                child: const Text('Готово'),
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
            // key: key,
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
              prefixIcon: prefixicon,
              suffixText: suffixText,
              suffix: suffix,
              prefixText: prefixText,
              prefixStyle: const TextStyle(
                  fontSize: 14.5,
                  color: Colors.black,
                  overflow: TextOverflow.ellipsis),
              suffixIcon: suffixIcon,
              suffixStyle: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: 14,
                color: hintTextColor,
                fontWeight: FontWeight.w400,
              ),
              errorStyle: const TextStyle(fontSize: 10.0),
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
