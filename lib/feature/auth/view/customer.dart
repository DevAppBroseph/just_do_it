import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/drop_down.dart';
import 'package:just_do_it/feature/auth/widget/radio.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/user_reg.dart';

class Customer extends StatefulWidget {
  Function(int) stage;

  Customer(this.stage);
  @override
  State<Customer> createState() => _CustomerState();
}

class _CustomerState extends State<Customer> {
  GlobalKey iconBtn = GlobalKey();
  GlobalKey iconBtnCategory = GlobalKey();
  TextEditingController experienceController = TextEditingController();

  int groupValue = 0;
  int page = 0;
  bool visiblePassword = false;
  bool visiblePasswordRepeat = false;
  bool additionalInfo = false;
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController serialDocController = TextEditingController();
  TextEditingController numberDocController = TextEditingController();
  TextEditingController whoGiveDocController = TextEditingController();
  TextEditingController dateDocController = TextEditingController();
  String? gender;
  TextEditingController regionController = TextEditingController();
  List<String> typeDocument = [];
  List<String> typeWork = [];
  TextEditingController aboutMeController = TextEditingController();
  Uint8List? image;
  List<Uint8List> photos = [];
  Uint8List? cv;
  bool confirmTermsPolicy = false;
  UserRegModel user = UserRegModel(isEntity: false);
  List<Activities> listCategories = [];
  bool physics = false;

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      Uint8List? file = await File(getMedia.path).readAsBytes();
      image = file;
      user.copyWith(photo: image);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
        if (current is SendProfileSuccessState) {
          Navigator.of(context).pushNamed(AppRoute.confirmCode,
              arguments: [phoneController.text, true]);
        } else if (current is GetCategoriesState) {
          listCategories.clear();
          listCategories.addAll(current.res);
        }
        return false;
      }, builder: (context, snapshot) {
        return Column(
          children: [
            Expanded(child: page == 0 ? firstStage() : secondStage()),
            SizedBox(height: 10.h),
            CustomButton(
              onTap: () {
                if (page == 0) {
                  String error = 'Укажите:';
                  bool errorsFlag = false;

                  if (phoneController.text.isEmpty) {
                    error += '\n - мобильный номер';
                    errorsFlag = true;
                  }
                  if (emailController.text.isEmpty) {
                    error += '\n - почту';
                    errorsFlag = true;
                  }
                  if (firstnameController.text.isEmpty) {
                    error += '\n - имя';
                    errorsFlag = true;
                  }
                  if (lastnameController.text.isEmpty) {
                    error += '\n - фамилию';
                    errorsFlag = true;
                  }

                  if (errorsFlag) {
                    showAlertToast(error);
                  } else {
                    page = 1;
                    widget.stage(2);
                  }
                } else {
                  user.copyWith(groups: [3]);
                  String error = 'Укажите:\n';
                  bool errorsFlag = false;

                  if (passwordController.text.isEmpty ||
                      repeatPasswordController.text.isEmpty) {
                    error += ' - пароль';
                    errorsFlag = true;
                  }

                  if (errorsFlag) {
                    if ((passwordController.text.isNotEmpty &&
                            repeatPasswordController.text.isNotEmpty) &&
                        (passwordController.text !=
                            repeatPasswordController.text)) {
                      error += '\n\n Пароли не совпадают';
                    }
                    showAlertToast(error);
                  } else if ((passwordController.text.isNotEmpty &&
                          repeatPasswordController.text.isNotEmpty) &&
                      (passwordController.text !=
                          repeatPasswordController.text)) {
                    showAlertToast('- пароли не совпадают');
                  } else {
                    BlocProvider.of<AuthBloc>(context)
                        .add(SendProfileEvent(user));
                  }
                }
              },
              btnColor: ColorStyles.yellowFFD70A,
              textLabel: Text(
                page == 0 ? 'Далее' : 'Зарегистрироваться',
                style: CustomTextStyle.black_14_w600_171716,
              ),
            ),
            SizedBox(height: 18.h),
            CustomButton(
              onTap: () {
                if (page == 1) {
                  page = 0;
                  widget.stage(1);
                } else {
                  Navigator.of(context).pop();
                }
              },
              btnColor: ColorStyles.greyE0E6EE,
              textLabel: Text(
                'Назад',
                style: CustomTextStyle.black_14_w600_515150,
              ),
            ),
            SizedBox(height: 34.h),
          ],
        );
      }),
    );
  }

  Widget firstStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: 'Ваше имя',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          textEditingController: firstnameController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(firstname: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Ваша фамилия',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          textEditingController: lastnameController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(lastname: value);
          },
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Text(
              'Ваш пол',
              style: CustomTextStyle.black_12_w400_171716,
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = 0;
                  gender = 'Мужчина';
                  user.copyWith(sex: groupValue == 0 ? true : false);
                });
              },
              child: CustomCircleRadioButtonItem(
                label: 'Муж.',
                value: 0,
                groupValue: groupValue,
              ),
            ),
            SizedBox(width: 15.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = 1;
                  gender = 'Женщина';
                  user.copyWith(sex: groupValue == 0 ? true : false);
                });
              },
              child: CustomCircleRadioButtonItem(
                label: 'Жен.',
                value: 1,
                groupValue: groupValue,
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
        CustomTextField(
          hintText: 'Номер телефона',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          textEditingController: phoneController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(phoneNumber: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'E-mail',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          textEditingController: emailController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(email: value);
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: _selectImage,
          child: CustomTextField(
            hintText: 'Добавить фото',
            hintStyle: CustomTextStyle.grey_12_w400,
            height: 50.h,
            enabled: false,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            suffixIcon: Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.h),
                  child: SvgPicture.asset(
                    SvgImg.gallery,
                    height: 15.h,
                    width: 15.h,
                  ),
                ),
              ],
            ),
            textEditingController: TextEditingController(),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: confirmTermsPolicy,
              onChanged: (value) {
                setState(() {
                  confirmTermsPolicy = !confirmTermsPolicy;
                });
              },
              checkColor: Colors.black,
              activeColor: ColorStyles.yellowFFD70A,
            ),
            Flexible(
              child: Text(
                'Согласен на обработку персональных данных и с пользовательским соглашением',
                textAlign: TextAlign.justify,
                style: CustomTextStyle.black_12_w400_515150,
              ),
            ),
          ],
        ),
        SizedBox(height: 23.h),
      ],
    );
  }

  Widget secondStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: 'Пароль',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          obscureText: !visiblePassword,
          suffixIcon: GestureDetector(
            onTap: () {
              visiblePassword = !visiblePassword;
              setState(() {});
            },
            child: visiblePassword
                ? const Icon(Icons.remove_red_eye_outlined)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye_close.svg',
                        height: 18.h,
                      ),
                    ],
                  ),
          ),
          textEditingController: passwordController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(password: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Повторите пароль',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          obscureText: !visiblePasswordRepeat,
          suffixIcon: GestureDetector(
            onTap: () {
              visiblePasswordRepeat = !visiblePasswordRepeat;
              setState(() {});
            },
            child: visiblePasswordRepeat
                ? const Icon(Icons.remove_red_eye_outlined)
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/icons/eye_close.svg',
                        height: 18.h,
                      ),
                    ],
                  ),
          ),
          textEditingController: repeatPasswordController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Регион',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          textEditingController: regionController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(region: value);
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () => showIconModal(
            context,
            iconBtn,
            (value) {
              additionalInfo = true;
              // user.copyWith(docType: value);
              setState(() {});
            },
            ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
            'Тип документа',
          ),
          child: Stack(
            key: iconBtn,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: 'Тип документа',
                hintStyle: CustomTextStyle.grey_12_w400,
                height: 50.h,
                enabled: false,
                onTap: () {},
                fillColor: Colors.grey[200],
                textEditingController:
                    TextEditingController(text: 'Тип документа'),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      SvgImg.arrowBottom,
                      width: 16.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (additionalInfo) additionalInfoWidget(),
        SizedBox(height: 16.h),
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: physics,
              onChanged: (value) {
                setState(() {
                  physics = !physics;
                });
              },
              checkColor: Colors.black,
              activeColor: ColorStyles.yellowFFD70A,
            ),
            Flexible(
              child: Text(
                'Юридическое лицо',
                textAlign: TextAlign.justify,
                style: CustomTextStyle.black_12_w400_515150,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget additionalInfoWidget() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              hintText: 'Серия',
              hintStyle: CustomTextStyle.grey_12_w400,
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 - 6.w,
              textEditingController: serialDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
            SizedBox(width: 12.w),
            CustomTextField(
              hintText: 'Номер',
              hintStyle: CustomTextStyle.grey_12_w400,
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 - 6.w,
              textEditingController: numberDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Кем выдан',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          textEditingController: whoGiveDocController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) => documentEdit(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Дата выдачи',
          hintStyle: CustomTextStyle.grey_12_w400,
          height: 50.h,
          textEditingController: dateDocController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) => documentEdit(),
        ),
      ],
    );
  }

  void documentEdit() {
    user.copyWith(
      docInfo:
          'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}',
    );
  }
}
