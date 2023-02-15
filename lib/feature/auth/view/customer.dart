import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/drop_down.dart';
import 'package:just_do_it/feature/auth/widget/formatter_first_upper.dart';
import 'package:just_do_it/feature/auth/widget/loader.dart';
import 'package:just_do_it/feature/auth/widget/radio.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:url_launcher/url_launcher.dart';

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
  TextEditingController phoneController = TextEditingController(text: '+');
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController serialDocController = TextEditingController();
  TextEditingController numberDocController = TextEditingController();
  TextEditingController whoGiveDocController = TextEditingController();
  TextEditingController dateDocController = TextEditingController();
  TextEditingController documentTypeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  String? gender;
  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  List<String> typeDocument = [];
  List<String> typeWork = [];
  TextEditingController aboutMeController = TextEditingController();
  File? image;
  GlobalKey keyCountry = GlobalKey();
  GlobalKey keyRegion = GlobalKey();
  bool confirmTermsPolicy = false;
  DateTime? dateTime;
  UserRegModel user = UserRegModel(isEntity: false);
  List<Activities> listCategories = [];
  bool physics = false;
  List<String> country = ['Россия', 'ОАЭ'];
  List<String> countryRussia = [
    'Краснодарский край',
    'Красноярский край',
    'Пермский край',
    'Белгородская область',
    'Курская область',
    'Московская область',
    'Смоленская область',
  ];
  List<String> countryOAE = [
    'Дубай',
    'Абу-Даби',
    'Аджмана',
    'Фуджейры',
    'Рас-Эль-Хаймы',
    'Шарджи',
  ];

  FocusNode focusNodeAbout = FocusNode();
  FocusNode focusNodeName = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword1 = FocusNode();
  FocusNode focusNodePassword2 = FocusNode();
  FocusNode focusNodeSeria = FocusNode();
  FocusNode focusNodeNumber = FocusNode();
  FocusNode focusNodeWhoTake = FocusNode();

  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      File? file = File(getMedia.path);
      image = file;
      user.copyWith(photo: image);
    }
    setState(() {});
  }

  void requestNextEmptyFocusStage1() {
    if (firstnameController.text.isEmpty) {
      focusNodeName.requestFocus();
      scrollController1.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (lastnameController.text.isEmpty) {
      focusNodeLastName.requestFocus();
      scrollController1.animateTo(50.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (phoneController.text.isEmpty) {
      focusNodePhone.requestFocus();
      scrollController1.animateTo(100.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (emailController.text.isEmpty) {
      focusNodeEmail.requestFocus();
      scrollController1.animateTo(150.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  void requestNextEmptyFocusStage2() {
    if (passwordController.text.isEmpty) {
      focusNodePassword1.requestFocus();
      scrollController2.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (repeatPasswordController.text.isEmpty) {
      focusNodePassword2.requestFocus();
      scrollController2.animateTo(50.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (additionalInfo) {
      if (serialDocController.text.isEmpty) {
        focusNodeSeria.requestFocus();
        scrollController2.animateTo(150.h,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else if (numberDocController.text.isEmpty) {
        focusNodeNumber.requestFocus();
        scrollController2.animateTo(150.h,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else if (whoGiveDocController.text.isEmpty) {
        focusNodeWhoTake.requestFocus();
        scrollController2.animateTo(150.h,
            duration: const Duration(milliseconds: 100), curve: Curves.linear);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
        Loader.hide();
        if (current is SendProfileSuccessState) {
          Navigator.of(context).pushNamed(AppRoute.confirmCode,
              arguments: [phoneController.text, true]);
        } else if (current is GetCategoriesState) {
          listCategories.clear();
          listCategories.addAll(current.res);
        } else if (current is SendProfileErrorState) {
          print('object ${current.error!}');
          String messageError = 'Ошибка\n';
          if (current.error!['email'] != null &&
              current.error!['email'][0] != null) {
            String email = current.error!['email'][0];
            if (email.contains('custom user with this Email already exists.')) {
              messageError = 'Пользователь с такой почтой уже зарегистрирован';
            } else if (email.contains('Enter a valid email address.')) {
              messageError = 'Введите корректный адрес почты';
            }
          } else if (current.error!['phone_number'] != null &&
              current.error!['phone_number'][0] != null) {
            String phoneNumber = current.error!['phone_number'][0];
            if (phoneNumber
                .contains('custom user with this Телефон already exists.')) {
              messageError =
                  'Пользователь с таким телефоном уже зарегистрирован';
            } else if (phoneNumber
                .contains('The phone number entered is not valid.')) {
              messageError = 'Введите корректный номер телефона';
            }
          }
          showAlertToast(messageError);
        }
        return false;
      }, builder: (context, snapshot) {
        return Column(
          children: [
            Expanded(
                child: page == 0
                    ? firstStage(heightKeyBoard)
                    : secondStage(heightKeyBoard)),
            SizedBox(height: 10.h),
            CustomButton(
              onTap: () {
                if (page == 0) {
                  requestNextEmptyFocusStage1();
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

                  String email = emailController.text;

                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(email);

                  if (errorsFlag) {
                    showAlertToast(error);
                  } else if (!emailValid) {
                    showAlertToast('Введите корректный адрес почты');
                  } else if (!confirmTermsPolicy) {
                    showAlertToast(
                        'Необходимо дать согласие на обработку персональных данных и пользовательское соглашение');
                  } else {
                    page = 1;
                    widget.stage(2);
                  }
                } else {
                  requestNextEmptyFocusStage2();
                  user.copyWith(groups: [3]);
                  String error = 'Укажите:';
                  bool errorsFlag = false;

                  if (countryController.text.isEmpty) {
                    error += '\n - страну';
                    errorsFlag = true;
                  }
                  if (regionController.text.isEmpty) {
                    error += '\n - город';
                    errorsFlag = true;
                  }

                  if (passwordController.text.isEmpty ||
                      repeatPasswordController.text.isEmpty) {
                    error += '\n- пароль';
                    errorsFlag = true;
                  }

                  if (additionalInfo) {
                    if (serialDocController.text.isEmpty) {
                      error += '\n - серию докемента';
                      errorsFlag = true;
                    }
                    if (numberDocController.text.isEmpty) {
                      error += '\n - номер документа';
                      errorsFlag = true;
                    }
                    if (whoGiveDocController.text.isEmpty) {
                      error += '\n - кем был выдан документ';
                      errorsFlag = true;
                    }
                    if (dateDocController.text.isEmpty) {
                      error += '\n - дату выдачи документа';
                      errorsFlag = true;
                    }
                  }

                  if (errorsFlag) {
                    if ((passwordController.text.isNotEmpty &&
                            repeatPasswordController.text.isNotEmpty) &&
                        (passwordController.text !=
                            repeatPasswordController.text)) {
                      error += '\n\n Пароли не совпадают';
                    }
                    showAlertToast(error);
                  } else if (passwordController.text.length < 6) {
                    showAlertToast('- минимальная длинна пароля 6 символов');
                  } else if ((passwordController.text.isNotEmpty &&
                          repeatPasswordController.text.isNotEmpty) &&
                      (passwordController.text !=
                          repeatPasswordController.text)) {
                    // error += 'Пароли не совпадают';
                    showAlertToast('Пароли не совпадают');
                  } else {
                    showLoaderWrapper(context);
                    documentEdit();
                    BlocProvider.of<AuthBloc>(context)
                        .add(SendProfileEvent(user));
                  }

                  print(
                      'object $errorsFlag ${passwordController.text}-${repeatPasswordController.text}');
                }
              },
              btnColor: confirmTermsPolicy
                  ? ColorStyles.yellowFFD70A
                  : ColorStyles.greyE0E6EE,
              textLabel: Text(
                page == 0 ? 'Далее' : 'Зарегистрироваться',
                style: CustomTextStyle.black_15_w600_171716,
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
                style: CustomTextStyle.black_15_w600_515150,
              ),
            ),
            SizedBox(height: 34.h),
          ],
        );
      }),
    );
  }

  Widget firstStage(double heightKeyBoard) {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      controller: scrollController1,
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: 'Ваше имя',
          focusNode: focusNodeName,
          hintStyle: CustomTextStyle.grey_13_w400,
          height: 50.h,
          textEditingController: firstnameController,
          formatters: [UpperTextInputFormatter()],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(firstname: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Ваша фамилия',
          focusNode: focusNodeLastName,
          hintStyle: CustomTextStyle.grey_13_w400,
          height: 50.h,
          textEditingController: lastnameController,
          formatters: [UpperTextInputFormatter()],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(lastname: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Text(
              'Ваш пол',
              style: CustomTextStyle.black_13_w400_171716,
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
          hintStyle: CustomTextStyle.grey_13_w400,
          height: 50.h,
          focusNode: focusNodePhone,
          textEditingController: phoneController,
          formatters: [
            MaskTextInputFormatter(
              initialText: '+ ',
              mask: '+############',
              filter: {"#": RegExp(r'[0-9]')},
            ),
            LengthLimitingTextInputFormatter(13)
          ],
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(phoneNumber: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
          onTap: () {
            Future.delayed(Duration(milliseconds: 350), () {
              scrollController1.animateTo(200.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'E-mail',
          hintStyle: CustomTextStyle.grey_13_w400,
          height: 50.h,
          focusNode: focusNodeEmail,
          textEditingController: emailController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(email: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
          onTap: () {
            Future.delayed(Duration(milliseconds: 300), () {
              scrollController1.animateTo(250.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: _selectImage,
          child: CustomTextField(
            hintText: 'Добавить фото',
            hintStyle: CustomTextStyle.grey_13_w400,
            height: 50.h,
            enabled: false,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            suffixIcon: Stack(
              alignment: Alignment.centerRight,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 16.h),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        SvgImg.gallery,
                        height: 15.h,
                        width: 15.h,
                      ),
                      if (user.photo != null)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(width: 5.w),
                            const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          ],
                        )
                    ],
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
              child: GestureDetector(
                onTap: () {
                  launch('https://dzen.ru/news?issue_tld=by');
                },
                child: Text(
                  'Согласен на обработку персональных данных\nи с пользовательским соглашением',
                  style: CustomTextStyle.black_13_w400_515150
                      .copyWith(decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        SizedBox(height: heightKeyBoard / 2),
      ],
    );
  }

  Widget secondStage(double heightKeyBoard) {
    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.zero,
      controller: scrollController2,
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: 'Пароль',
          hintStyle: CustomTextStyle.grey_13_w400,
          height: 50.h,
          focusNode: focusNodePassword1,
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
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage2();
          },
          onTap: () {
            Future.delayed(Duration(milliseconds: 300), () {
              scrollController2.animateTo(0.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Повторите пароль',
          hintStyle: CustomTextStyle.grey_13_w400,
          height: 50.h,
          focusNode: focusNodePassword2,
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
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage2();
          },
          textEditingController: repeatPasswordController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onTap: () {
            Future.delayed(Duration(milliseconds: 300), () {
              scrollController2.animateTo(50.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          key: keyCountry,
          onTap: () => showCountry(
            context,
            keyCountry,
            (value) {
              countryController.text = value;
              regionController.text = '';
              setState(() {});
            },
            country,
            'Выберите страну',
          ),
          child: CustomTextField(
            hintText: 'Страну',
            hintStyle: CustomTextStyle.grey_13_w400,
            height: 50.h,
            enabled: false,
            textEditingController: countryController,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) {},
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          key: keyRegion,
          onTap: () {
            if (countryController.text.isNotEmpty) {
              showRegion(
                context,
                keyRegion,
                (value) {
                  regionController.text = value;
                  user.copyWith(region: value);
                  setState(() {});
                },
                countryController.text == 'Россия' ? countryRussia : countryOAE,
                'Выберите регион',
              );
            } else {
              showAlertToast('Чтобы выбрать регион, сначала укажите страну');
            }
          },
          child: CustomTextField(
            hintText: 'Регион',
            hintStyle: CustomTextStyle.grey_13_w400,
            height: 50.h,
            enabled: false,
            textEditingController: regionController,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) {},
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () => showIconModal(
            context,
            iconBtn,
            (value) {
              documentTypeController.text = value;
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
                hintStyle: CustomTextStyle.grey_13_w400,
                height: 50.h,
                enabled: false,
                onTap: () {},
                fillColor: Colors.grey[200],
                textEditingController: documentTypeController,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    documentTypeController.text.isNotEmpty
                        ? GestureDetector(
                            onTap: () {
                              additionalInfo = false;
                              documentTypeController.text = '';
                              serialDocController.text = '';
                              numberDocController.text = '';
                              whoGiveDocController.text = '';
                              dateDocController.text = '';
                              dateTime = null;
                              setState(() {});
                            },
                            child: Icon(Icons.close),
                          )
                        : SvgPicture.asset(
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
                style: CustomTextStyle.black_13_w400_515150,
              ),
            ),
          ],
        ),
        SizedBox(height: heightKeyBoard / 2),
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
              hintStyle: CustomTextStyle.grey_13_w400,
              height: 50.h,
              textInputType: TextInputType.number,
              focusNode: focusNodeSeria,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 - 6.w,
              textEditingController: serialDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
              onFieldSubmitted: (value) {
                requestNextEmptyFocusStage2();
              },
              onTap: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  scrollController2.animateTo(350.h,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear);
                });
              },
            ),
            SizedBox(width: 12.w),
            CustomTextField(
              hintText: 'Номер',
              hintStyle: CustomTextStyle.grey_13_w400,
              height: 50.h,
              textInputType: TextInputType.number,
              focusNode: focusNodeNumber,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 - 6.w,
              textEditingController: numberDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
              onFieldSubmitted: (value) {
                requestNextEmptyFocusStage2();
              },
              onTap: () {
                Future.delayed(Duration(milliseconds: 300), () {
                  scrollController2.animateTo(350.h,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear);
                });
              },
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Кем выдан',
          hintStyle: CustomTextStyle.grey_13_w400,
          height: 50.h,
          focusNode: focusNodeWhoTake,
          textEditingController: whoGiveDocController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) => documentEdit(),
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage2();
          },
          onTap: () {
            Future.delayed(Duration(milliseconds: 300), () {
              scrollController2.animateTo(350.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () async {
            _showDatePicker(context);
          },
          child: CustomTextField(
            hintText: 'Дата выдачи',
            hintStyle: CustomTextStyle.grey_13_w400,
            height: 50.h,
            enabled: false,
            textEditingController: dateDocController,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) => documentEdit(),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(ctx) {
    dateTime = null;
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Column(
                children: [
                  Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.h,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Spacer(),
                              CupertinoButton(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                borderRadius: BorderRadius.zero,
                                child: Text(
                                  'Готово',
                                  style: TextStyle(
                                      fontSize: 14.sp, color: Colors.black),
                                ),
                                onPressed: () {
                                  if (dateTime == null) {
                                    dateDocController.text =
                                        DateFormat('dd.MM.yyyy')
                                            .format(DateTime.now());
                                  }

                                  Navigator.of(ctx).pop();
                                },
                              ),
                              SizedBox(width: 5.w),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 200.h,
                    color: Colors.white,
                    child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          dateTime = val;
                          dateDocController.text =
                              DateFormat('dd.MM.yyyy').format(val);
                        }),
                  ),
                ],
              ),
            ));
  }

  void documentEdit() {
    user.copyWith(
      docInfo:
          'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}',
    );
  }
}
