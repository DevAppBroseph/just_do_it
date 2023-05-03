import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:open_file/open_file.dart';
import 'package:scale_button/scale_button.dart';

enum CountryCode { ru, oae }

class Contractor extends StatefulWidget {
  Function(int) stage;

  Contractor(this.stage, {super.key});
  @override
  State<Contractor> createState() => _ContractorState();
}

class _ContractorState extends State<Contractor> {
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
  TextEditingController documentTypeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();

  String? gender;
  final GlobalKey _countryKey = GlobalKey();
  final GlobalKey _categoryButtonKey = GlobalKey();
  final GlobalKey _regionKey = GlobalKey();
  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  List<String> typeCategories = [];
  TextEditingController aboutMeController = TextEditingController();
  File? image;
  List<ArrayImages> photos = [];
  File? cv;
  bool confirmTermsPolicy = false;
  DateTime? dateTimeStart;
  DateTime? dateTimeEnd;
  UserRegModel user = UserRegModel(isEntity: false);
  List<Activities> listCategories = [];
  bool physics = false;

  CountryCode countryCode = CountryCode.ru;

  DateTime? dateTime;

  FocusNode focusNodeAbout = FocusNode();
  FocusNode focusNodeName = FocusNode();
  FocusNode focusNodeLastName = FocusNode();
  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeEmail = FocusNode();
  FocusNode focusNodePassword1 = FocusNode();
  FocusNode focusNodePassword2 = FocusNode();
  FocusNode focusNodeSerial = FocusNode();
  FocusNode focusNodeNumber = FocusNode();
  FocusNode focusNodeWhoTake = FocusNode();

  ScrollController scrollController1 = ScrollController();
  ScrollController scrollController2 = ScrollController();

  List<Countries> listCountries = [];
  Countries? selectCountries;

  List<Regions> listRegions = [];
  Regions? selectRegions;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(GetCategoriesEvent());
    listCountries.addAll(BlocProvider.of<CountriesBloc>(context).country);
  }

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      File? file = File(getMedia.path);
      image = file;
      user.copyWith(photo: image?.readAsBytesSync());
    }
    setState(() {});
  }

  _selectImages() async {
    final getMedia = await ImagePicker().getMultiImage(imageQuality: 70);
    if (getMedia != null) {
      List<ArrayImages> files = [];
      for (var pickedFile in getMedia) {
        File? file = File(pickedFile.path);
        files.add(ArrayImages(null, file.readAsBytesSync(), file: file));
      }
      setState(() {
        photos.addAll(files);
        user.copyWith(images: photos);
      });
    }
  }

  _selectCV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      cv = File(result.files.first.path!);
      user.copyWith(cv: cv?.readAsBytesSync());
      setState(() {});
    }
  }

  void requestNextEmptyFocusStage1() {
    if (firstnameController.text.isEmpty) {
      focusNodeName.requestFocus();
      scrollController1.animateTo(0,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (lastnameController.text.isEmpty) {
      focusNodeName.unfocus();
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
    } else if (passwordController.text.isEmpty) {
      focusNodePassword1.requestFocus();
      scrollController1.animateTo(200.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (repeatPasswordController.text.isEmpty) {
      focusNodePassword2.requestFocus();
      scrollController1.animateTo(250.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    } else if (!confirmTermsPolicy) {
      scrollController1.animateTo(90.h,
          duration: const Duration(milliseconds: 100), curve: Curves.linear);
    }
  }

  void requestNextEmptyFocusStage2() {
    if (additionalInfo) {
      if (serialDocController.text.isEmpty) {
        focusNodeSerial.requestFocus();
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
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, snapshot) {
      listRegions.clear();
      listRegions.addAll(BlocProvider.of<CountriesBloc>(context).region);
      return MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
          Loader.hide();
          if (current is CheckUserState) {
            if (current.error != null) {
              showAlertToast(
                  'Пользователь с такой почтой или номером телефона уже зарегистрирован');
            } else {
              page = 1;
              widget.stage(2);
            }
          } else if (current is SendProfileSuccessState) {
            Navigator.of(context).pushNamed(AppRoute.confirmCodeRegister,
                arguments: [phoneController.text]);
          } else if (current is GetCategoriesState) {
            listCategories.clear();
            listCategories.addAll(current.res);
          } else if (current is SendProfileErrorState) {
            String messageError = 'Ошибка\n';
            if (current.error!['email'] != null &&
                current.error!['email'][0] != null) {
              String email = current.error!['email'][0];
              if (email
                  .contains('custom user with this Email already exists.')) {
                messageError =
                    'Пользователь с такой почтой уже зарегистрирован';
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

                    if (firstnameController.text.isEmpty) {
                      error += '\n- имя';
                      errorsFlag = true;
                    }

                    if (lastnameController.text.isEmpty) {
                      error += '\n- фамилию';
                      errorsFlag = true;
                    }

                    if (phoneController.text.isEmpty) {
                      error += '\n- мобильный номер';
                      errorsFlag = true;
                    }

                    if (emailController.text.isEmpty) {
                      error += '\n- почту';
                      errorsFlag = true;
                    }

                    if (passwordController.text.isEmpty ||
                        repeatPasswordController.text.isEmpty) {
                      error += '\n- пароль';
                      errorsFlag = true;
                    }

                    String email = emailController.text;

                    bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(email);

                    if (errorsFlag) {
                      if ((passwordController.text.isNotEmpty &&
                              repeatPasswordController.text.isNotEmpty) &&
                          (passwordController.text !=
                              repeatPasswordController.text)) {
                        error += '\n\nПароли не совпадают';
                      }
                      showAlertToast(error);
                    } else if (phoneController.text.length < 12) {
                      showAlertToast('- Некорректный номер телефона.');
                    } else if (emailController.text
                            .split('@')
                            .last
                            .split('.')
                            .last
                            .length <
                        2) {
                      showAlertToast('- Введите корректный адрес почты');
                    } else if ((passwordController.text.isNotEmpty &&
                            repeatPasswordController.text.isNotEmpty) &&
                        (passwordController.text !=
                            repeatPasswordController.text)) {
                      showAlertToast('- пароли не совпадают');
                    } else if (passwordController.text.length < 6) {
                      showAlertToast('- минимальная длина пароля 6 символов');
                    } else if (!emailValid) {
                      showAlertToast('Введите корректный адрес почты');
                    } else if (!confirmTermsPolicy) {
                      showAlertToast(
                          'Необходимо дать согласие на обработку персональных данных и пользовательское соглашение');
                    } else {
                      showLoaderWrapper(context);

                      BlocProvider.of<AuthBloc>(context).add(
                          CheckUserExistEvent(
                              phoneController.text, emailController.text));
                    }
                  } else {
                    List<int> categorySelect = [];
                    for (int i = 0; i < typeCategories.length; i++) {
                      for (int j = 0; j < listCategories.length; j++) {
                        if (typeCategories[i] ==
                            listCategories[j].description) {
                          categorySelect.add(listCategories[j].id);
                        }
                      }
                    }
                    requestNextEmptyFocusStage2();
                    user.copyWith(
                        activitiesDocument: categorySelect, groups: [4]);
                    String error = 'Укажите:';
                    bool errorsFlag = false;

                    if (countryController.text.isEmpty) {
                      error += '\n- страну';
                      errorsFlag = true;
                    }
                    if (regionController.text.isEmpty) {
                      error += '\n- регион';
                      errorsFlag = true;
                    }
                    if (typeCategories.isEmpty) {
                      error += '\n- до 3х категорий';
                      errorsFlag = true;
                    }
                    if (additionalInfo) {
                      if (serialDocController.text.isEmpty &&
                          user.docType != 'Resident_ID') {
                        error += '\n- серию документа';
                        errorsFlag = true;
                      }
                      if (numberDocController.text.isEmpty) {
                        error += '\n- номер документа';
                        errorsFlag = true;
                      }
                      if (whoGiveDocController.text.isEmpty) {
                        error += '\n- кем был вадан документ';
                        errorsFlag = true;
                      }
                      if (dateDocController.text.isEmpty) {
                        error += '\n- дату выдачи документа';
                        errorsFlag = true;
                      }
                    }

                    if (errorsFlag) {
                      showAlertToast(error);
                    } else {
                      if (dateTimeEnd != null &&
                          DateTime.now().isAfter(dateTimeEnd!)) {
                        showAlertToast('Ваш паспорт просрочен');
                      } else if (checkExpireDate(dateTimeEnd) != null) {
                        showAlertToast(checkExpireDate(dateTimeEnd)!);
                      } else {
                        showLoaderWrapper(context);

                        BlocProvider.of<AuthBloc>(context)
                            .add(SendProfileEvent(user));
                      }
                    }
                  }
                },
                btnColor: page == 0
                    ? confirmTermsPolicy
                        ? ColorStyles.yellowFFD70A
                        : ColorStyles.greyE0E6EE
                    : countryController.text.isNotEmpty &&
                            regionController.text.isNotEmpty &&
                            typeCategories.isNotEmpty
                        ? ColorStyles.yellowFFD70A
                        : ColorStyles.greyE0E6EE,
                textLabel: Text(
                  page == 0 ? 'Далее' : 'Зарегистрироваться',
                  style: CustomTextStyle.black_16_w600_171716,
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
                  style: CustomTextStyle.black_16_w600_515150,
                ),
              ),
              SizedBox(height: 34.h),
            ],
          );
        }),
      );
    });
  }

  Widget firstStage(double heightKeyBoard) {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      controller: scrollController1,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          focusNode: focusNodeName,
          hintText: 'Ваше имя*',
          height: 50.h,
          textEditingController: firstnameController,
          hintStyle: CustomTextStyle.grey_14_w400,
          formatters: [
            UpperTextInputFormatter(),
            FilteringTextInputFormatter.allow(RegExp("[а-яА-Яa-zA-Z- -]")),
          ],
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
          focusNode: focusNodeLastName,
          hintText: 'Ваша фамилия*',
          height: 50.h,
          textEditingController: lastnameController,
          hintStyle: CustomTextStyle.grey_14_w400,
          formatters: [
            UpperTextInputFormatter(),
            FilteringTextInputFormatter.allow(RegExp("[а-яА-Яa-zA-Z- -]")),
          ],
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
              style: CustomTextStyle.black_14_w400_171716,
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
          focusNode: focusNodePhone,
          hintText: 'Номер телефона*',
          height: 50.h,
          textInputType: TextInputType.phone,
          textEditingController: phoneController,
          hintStyle: CustomTextStyle.grey_14_w400,
          formatters: [
            MaskTextInputFormatter(
              mask: '+############',
              filter: {"#": RegExp(r'[0-9]')},
              type: MaskAutoCompletionType.eager,
            ),
          ],
          onTap: () {
            if (phoneController.text.isEmpty) phoneController.text = '+';
          },
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(phoneNumber: value);
          },
          onFieldSubmitted: (value) {
            if (phoneController.text == '+') phoneController.text = '';
            requestNextEmptyFocusStage1();
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          focusNode: focusNodeEmail,
          hintText: 'E-mail*',
          height: 50.h,
          textEditingController: emailController,
          hintStyle: CustomTextStyle.grey_14_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(email: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
          onTap: () {
            Future.delayed(const Duration(milliseconds: 250), () {
              scrollController1.animateTo(500.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          focusNode: focusNodePassword1,
          hintText: 'Пароль*',
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
          hintStyle: CustomTextStyle.grey_14_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(password: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
          onTap: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              scrollController1.animateTo(300.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          focusNode: focusNodePassword2,
          hintText: 'Повторите пароль*',
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
          hintStyle: CustomTextStyle.grey_14_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(password: value);
          },
          onFieldSubmitted: (value) {
            requestNextEmptyFocusStage1();
          },
          onTap: () {
            Future.delayed(const Duration(milliseconds: 300), () {
              scrollController1.animateTo(350.h,
                  duration: const Duration(milliseconds: 100),
                  curve: Curves.linear);
            });
          },
        ),
        SizedBox(height: 10.h),
        Text(
          '* - обязательные поля для заполнения',
          textAlign: TextAlign.start,
          style: CustomTextStyle.black_14_w400_515150,
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
                onTap: () {},
                child: Text(
                  'Согласен на обработку персональных данных и с пользовательским соглашением',
                  style: CustomTextStyle.black_14_w400_515150
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
      padding: EdgeInsets.zero,
      controller: scrollController2,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: _selectImage,
          child: CustomTextField(
            hintText: 'Добавить фото',
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            enabled: false,
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          ),
        ),
        if (image != null) SizedBox(height: 6.h),
        if (image != null)
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  OpenFile.open(image?.path);
                },
                child: SizedBox(
                  height: 60.h,
                  width: 60.h,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 50.h,
                        width: 50.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: Image.memory(
                            image!.readAsBytesSync(),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            image = null;
                            user.photo = null;
                            setState(() {});
                          },
                          child: Container(
                            height: 15.h,
                            width: 15.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(color: Colors.black)
                                ],
                                borderRadius: BorderRadius.circular(40.r)),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: 10.h,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        SizedBox(height: 16.h),
        GestureDetector(
          key: _countryKey,
          onTap: () => showCountry(
            context,
            _countryKey,
            (value) {
              countryController.text = value.name ?? '-';
              selectCountries = value;
              regionController.text = '';
              BlocProvider.of<CountriesBloc>(context)
                  .add(GetRegionEvent([selectCountries!]));
              user.copyWith(country: countryController.text);
              setState(() {});
            },
            listCountries,
            'Выберите страну',
          ),
          child: CustomTextField(
            hintText: 'Страна*',
            hintStyle: CustomTextStyle.grey_14_w400,
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
          key: _regionKey,
          onTap: () {
            if (countryController.text.isNotEmpty) {
              showRegion(
                context,
                _regionKey,
                (value) {
                  regionController.text = value.name ?? '-';
                  user.copyWith(region: regionController.text);
                  setState(() {});
                },
                listRegions,
                'Выберите регион',
              );
            } else {
              showAlertToast('Чтобы выбрать регион, сначала укажите страну');
            }
          },
          child: CustomTextField(
            hintText: 'Регион*',
            hintStyle: CustomTextStyle.grey_14_w400,
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
            GlobalKeys.keyIconBtn1,
            (value) {
              documentTypeController.text = value;
              additionalInfo = true;
              user.copyWith(
                docType: value == 'Паспорт РФ'
                    ? 'Passport'
                    : value == 'Резидент ID'
                        ? 'Resident_ID'
                        : 'International Passport',
              );
              setState(() {});
            },
            ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
            'Документ',
          ),
          child: Stack(
            key: GlobalKeys.keyIconBtn1,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: 'Документ',
                height: 50.h,
                enabled: false,
                onTap: () {},
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
                              dateTimeEnd = null;
                              dateTimeStart = null;
                              setState(() {});
                            },
                            child: const Icon(Icons.close),
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
        GestureDetector(
          onTap: () => showIconModalCategories(
            context,
            _categoryButtonKey,
            (value) {
              categoryController.text = '';

              String str = '';
              if (value.isNotEmpty) {
                str = value.first;
              }

              if (value.length > 1) {
                for (int i = 1; i < typeCategories.length; i++) {
                  str += ', ${typeCategories[i]}';
                }
              }

              categoryController.text = str;

              setState(() {});
            },
            listCategories,
            'Выбор до 3х категорий*',
            typeCategories,
          ),
          child: Stack(
            key: _categoryButtonKey,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: 'Выбор до 3х категорий*',
                height: 50.h,
                enabled: false,
                onTap: () {},
                textEditingController: categoryController,
                contentPadding: EdgeInsets.only(
                    left: 18.w, right: 45.w, top: 18.h, bottom: 18.h),
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: SvgPicture.asset(
                      SvgImg.arrowRight,
                      height: 18.h,
                      width: 18.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 130.h,
          decoration: BoxDecoration(
            color: ColorStyles.greyEAECEE,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 0.h),
                child: SizedBox(
                  child: CustomTextField(
                    focusNode: focusNodeAbout,
                    hintText: 'Описание своего опыта',
                    hintStyle: CustomTextStyle.grey_14_w400,
                    maxLines: 6,
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 100), () {
                        scrollController2.animateTo(
                          400.h,
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.linear,
                        );
                      });
                    },
                    textEditingController: aboutMeController,
                    onChanged: (value) {
                      user.copyWith(activity: value);
                      setState(() {});
                    },
                    formatters: [LengthLimitingTextInputFormatter(500)],
                    contentPadding: EdgeInsets.only(
                        left: 15.h, right: 15.h, top: 15.h, bottom: 20.h),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${aboutMeController.text.length}/500',
                    style: CustomTextStyle.grey_12_w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        if (photos.isNotEmpty || cv != null)
          SizedBox(
            height: 60.h,
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              children: [
                if (photos.isNotEmpty)
                  Row(
                    children: photos
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              OpenFile.open(e.file!.path);
                            },
                            child: SizedBox(
                              height: 60.h,
                              width: 60.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 50.h,
                                    width: 50.h,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10.r),
                                      child: Image.memory(
                                        e.byte!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        photos.remove(e);
                                        user.images = photos;
                                        setState(() {});
                                      },
                                      child: Container(
                                        height: 15.h,
                                        width: 15.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(color: Colors.black)
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(40.r)),
                                        child: Center(
                                          child: Icon(
                                            Icons.close,
                                            size: 10.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                if (cv != null)
                  SizedBox(
                    height: 60.h,
                    width: 60.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            OpenFile.open(cv!.path);
                          },
                          child: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(color: Colors.black)
                                ],
                                borderRadius: BorderRadius.circular(10.r)),
                            child: Center(
                              child: SvgPicture.asset(
                                SvgImg.documentText,
                                height: 25.h,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              cv = null;
                              user.cv = null;
                              setState(() {});
                            },
                            child: Container(
                              height: 15.h,
                              width: 15.h,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: const [
                                    BoxShadow(color: Colors.black)
                                  ],
                                  borderRadius: BorderRadius.circular(40.r)),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: 10.h,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        Row(
          children: [
            ScaleButton(
              duration: const Duration(milliseconds: 50),
              bound: 0.01,
              onTap: _selectImages,
              child: SizedBox(
                height: 40.h,
                width: 150.w,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 9.h, vertical: 11.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 14.h,
                                width: 14.h,
                                child: SvgPicture.asset(SvgImg.addCircle),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Изображения (10мб)',
                                style: CustomTextStyle.black_12_w400,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (photos.isNotEmpty)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                          child: Center(
                              child: Text(
                            photos.length.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 11.sp),
                          )),
                        ),
                      )
                  ],
                ),
              ),
            ),
            SizedBox(width: 5.h),
            ScaleButton(
              duration: const Duration(milliseconds: 50),
              bound: 0.01,
              onTap: _selectCV,
              child: SizedBox(
                width: 172.w,
                height: 40.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 9.h, vertical: 11.h),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 14.h,
                                width: 14.h,
                                child: SvgPicture.asset(SvgImg.documentText),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Загрузить резюме (10мб)',
                                style: CustomTextStyle.black_12_w400,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (cv != null)
                      Align(
                        alignment: Alignment.topRight,
                        child: Container(
                          height: 12.h,
                          width: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(40.r),
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text(
          '* - обязательные поля для заполнения',
          textAlign: TextAlign.start,
          style: CustomTextStyle.black_14_w400_515150,
        ),
        SizedBox(height: 16.h),
        SizedBox(height: 2.h),
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: physics,
              onChanged: (value) {
                user.copyWith(isEntity: value);
                setState(() {
                  physics = !physics;
                });
              },
              checkColor: Colors.black,
              activeColor: ColorStyles.yellowFFD70A,
            ),
            Flexible(
              child: Text(
                'Представитель юридического лица',
                textAlign: TextAlign.justify,
                style: CustomTextStyle.black_14_w400_515150,
              ),
            ),
          ],
        ),
        SizedBox(height: heightKeyBoard / 2 + 20.h),
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
          children: [
            if (user.docType != 'Resident_ID')
              CustomTextField(
                hintText: 'Серия',
                hintStyle: CustomTextStyle.grey_14_w400,
                height: 50.h,
                focusNode: focusNodeSerial,
                onFieldSubmitted: (value) {
                  requestNextEmptyFocusStage2();
                },
                onTap: () {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    scrollController2.animateTo(200.h,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.linear);
                  });
                },
                formatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                textInputType: TextInputType.number,
                width: ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 -
                    6.w,
                textEditingController: serialDocController,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                onChanged: (value) => documentEdit(),
              ),
            if (user.docType != 'Resident_ID') SizedBox(width: 12.w),
            CustomTextField(
              hintText: user.docType != 'Resident_ID' ? 'Номер' : 'Номер ID',
              focusNode: focusNodeNumber,
              hintStyle: CustomTextStyle.grey_14_w400,
              onFieldSubmitted: (value) {
                requestNextEmptyFocusStage2();
              },
              height: 50.h,
              textInputType: TextInputType.number,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  scrollController2.animateTo(200.h,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear);
                });
              },
              formatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              width: user.docType == 'Resident_ID'
                  ? MediaQuery.of(context).size.width - 30.w - 18.w
                  : ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 -
                      6.w,
              textEditingController: numberDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ],
        ),
        if (user.docType == 'Passport') SizedBox(height: 16.h),
        if (user.docType == 'Passport')
          CustomTextField(
            hintText: 'Кем выдан',
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear);
              });
            },
            focusNode: focusNodeWhoTake,
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            textEditingController: whoGiveDocController,
            onFieldSubmitted: (value) {
              requestNextEmptyFocusStage2();
            },
            formatters: [
              LengthLimitingTextInputFormatter(35),
            ],
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) => documentEdit(),
          ),
        if (user.docType != 'Resident_ID') SizedBox(height: 16.h),
        if (user.docType != 'Resident_ID')
          GestureDetector(
            onTap: () async {
              _showDatePicker(context, 0, true);
            },
            child: CustomTextField(
              hintText: 'Дата выдачи',
              enabled: false,
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 50.h,
              textEditingController: dateDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ),
        if (user.docType != 'Passport') SizedBox(height: 16.h),
        if (user.docType != 'Passport')
          GestureDetector(
            onTap: () async {
              _showDatePicker(context, 1, false);
            },
            child: CustomTextField(
              hintText: 'Срок действия',
              enabled: false,
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 50.h,
              textEditingController: whoGiveDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ),
        Text(
          checkExpireDate(dateTimeEnd) ?? '',
          style: CustomTextStyle.red_11_w400_171716,
        ),
        if (user.docType == 'Resident_ID') SizedBox(height: 16.h),
        if (user.docType == 'Resident_ID')
          CustomTextField(
            hintText: 'Место выдачи',
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear);
              });
            },
            focusNode: focusNodeWhoTake,
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            formatters: [
              LengthLimitingTextInputFormatter(35),
            ],
            textEditingController: dateDocController,
            onFieldSubmitted: (value) {
              requestNextEmptyFocusStage2();
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) => documentEdit(),
          ),
      ],
    );
  }

  void _showDatePicker(ctx, int index, bool isInternational) {
    DateTime initialDateTime = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month,
                dateTimeStart!.day + 2)
            : DateTime(DateTime.now().year - 15, DateTime.now().month,
                DateTime.now().day + 2)
        : dateTimeStart ??
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1);

    DateTime maximumDate = index == 1
        ? DateTime(
            DateTime.now().year + 15, DateTime.now().month, DateTime.now().day)
        : dateTimeEnd != null
            ? DateTime(
                dateTimeEnd!.year, dateTimeEnd!.month, dateTimeEnd!.day - 1)
            : DateTime(DateTime.now().year + 15, DateTime.now().month,
                DateTime.now().day);

    DateTime minimumDate = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month,
                dateTimeStart!.day + 1)
            : DateTime(DateTime.now().year - 15, DateTime.now().month,
                DateTime.now().day + 1)
        : DateTime(
            DateTime.now().year - 15, DateTime.now().month, DateTime.now().day);

    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => MediaQuery(
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.h,
                          color: Colors.white,
                          child: Row(
                            children: [
                              const Spacer(),
                              CupertinoButton(
                                padding: EdgeInsets.symmetric(horizontal: 15.w),
                                borderRadius: BorderRadius.zero,
                                child: Text(
                                  'Готово',
                                  style: TextStyle(
                                      fontSize: 15.sp, color: Colors.black),
                                ),
                                onPressed: () {
                                  if (index == 0) {
                                    if (dateTimeStart == null) {
                                      dateTimeStart = DateTime.now();
                                      if (isInternational) {
                                        dateDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      } else {
                                        whoGiveDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      }
                                    }
                                  } else {
                                    if (dateTimeEnd == null) {
                                      dateTimeEnd = DateTime.now();
                                      if (isInternational) {
                                        dateDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      } else {
                                        whoGiveDocController.text =
                                            DateFormat('dd.MM.yyyy')
                                                .format(DateTime.now());
                                      }
                                    }
                                  }

                                  Navigator.of(ctx).pop();
                                  setState(() {});
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
                        initialDateTime: initialDateTime,
                        minimumDate: minimumDate,
                        maximumDate: maximumDate,
                        onDateTimeChanged: (val) {
                          if (index == 0) {
                            dateTimeStart = val;
                            if (isInternational) {
                              dateDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            } else {
                              whoGiveDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            }
                            user.copyWith(
                                docInfo:
                                    'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          } else {
                            dateTimeEnd = val;
                            if (isInternational) {
                              dateDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            } else {
                              whoGiveDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            }
                            user.copyWith(
                                docInfo:
                                    'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          }
                        }),
                  ),
                ],
              ),
            ));
  }

  String? checkExpireDate(DateTime? value) {
    if (value != null) {
      if (value.difference(DateTime.now()).inDays < 30) {
        return 'Срок действия документа составляет менее 30 дней';
      }
    }
    return null;
  }

  void documentEdit() {
    user.copyWith(
      docInfo:
          'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}',
    );
  }
}
