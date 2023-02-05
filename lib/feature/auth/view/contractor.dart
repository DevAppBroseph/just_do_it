import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:scale_button/scale_button.dart';

class Contractor extends StatefulWidget {
  Function(int) stage;

  Contractor(this.stage);
  @override
  State<Contractor> createState() => _ContractorState();
}

class _ContractorState extends State<Contractor> {
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
  List<int> typeCategories = [];
  TextEditingController aboutMeController = TextEditingController();
  File? image;
  List<File> photos = [];
  File? cv;
  bool confirmTermsPolicy = false;
  UserRegModel user = UserRegModel(isEntity: false);
  List<Activities> listCategories = [];
  bool physics = false;
  FocusNode focusNodeAbout = FocusNode();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(GetCategoriesEvent());
  }

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      File? file = File(getMedia.path);
      image = file;
      user.copyWith(photo: image);
    }
  }

  _selectImages() async {
    final getMedia = await ImagePicker().getMultiImage(imageQuality: 70);
    if (getMedia != null) {
      List<File> files = [];
      for (var pickedFile in getMedia) {
        File? file = File(pickedFile.path);
        files.add(file);
      }
      photos.clear();
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
      user.copyWith(cv: cv);
    }
  }

  @override
  Widget build(BuildContext context) {
    double heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
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
            }
          } else if (current.error!['phone_number'] != null &&
              current.error!['phone_number'][0] != null) {
            String phoneNumber = current.error!['phone_number'][0];
            if (phoneNumber
                .contains('custom user with this Телефон already exists.')) {
              messageError =
                  'Пользователь с таким телефоном уже зарегистрирован';
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
                  if (passwordController.text.isEmpty ||
                      repeatPasswordController.text.isEmpty) {
                    error += '\n - пароль';
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
                  } else if (!confirmTermsPolicy) {
                    showAlertToast(
                        'Необходимо дать согласие на обработку персональных данных и пользовательское соглашение');
                  } else {
                    page = 1;
                    widget.stage(2);
                  }
                } else {
                  user.copyWith(
                      activitiesDocument: typeCategories, groups: [4]);
                  String error = 'Укажите:\n';
                  bool errorsFlag = false;

                  if (phoneController.text.isEmpty) {
                    error += ' - мобильный номер\n';
                    errorsFlag = true;
                  }
                  if (emailController.text.isEmpty) {
                    error += ' - почту\n';
                    errorsFlag = true;
                  }
                  if (passwordController.text.isEmpty) {
                    error += ' - пароль\n';
                    errorsFlag = true;
                  }
                  if (firstnameController.text.isEmpty) {
                    error += ' - имя\n';
                    errorsFlag = true;
                  }
                  if (lastnameController.text.isEmpty) {
                    error += ' - фамилию\n';
                    errorsFlag = true;
                  }
                  if (typeCategories.isEmpty) {
                    error += ' - до 3-ёх категорий';
                    errorsFlag = true;
                  }

                  if (errorsFlag) {
                    showAlertToast(error);
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

  Widget firstStage(double heightKeyBoard) {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: 'Ваше имя',
          height: 50.h,
          textEditingController: firstnameController,
          hintStyle: CustomTextStyle.grey_12_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(firstname: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Ваша фамилия',
          height: 50.h,
          textEditingController: lastnameController,
          hintStyle: CustomTextStyle.grey_12_w400,
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
          height: 50.h,
          textEditingController: phoneController,
          hintStyle: CustomTextStyle.grey_12_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(phoneNumber: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'E-mail',
          height: 50.h,
          textEditingController: emailController,
          hintStyle: CustomTextStyle.grey_12_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(email: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Пароль',
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
          hintStyle: CustomTextStyle.grey_12_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(password: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Повторите пароль',
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
          hintStyle: CustomTextStyle.grey_12_w400,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          onChanged: (value) {
            user.copyWith(password: value);
          },
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
        SizedBox(height: heightKeyBoard / 2),
      ],
    );
  }

  Widget secondStage(double heightKeyBoard) {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: _selectImage,
          child: CustomTextField(
            hintText: 'Добавить фото',
            hintStyle: CustomTextStyle.grey_12_w400,
            height: 50.h,
            enabled: false,
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
          ),
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
                key: iconBtn,
                hintText: 'Тип документа',
                height: 50.h,
                enabled: false,
                onTap: () {},
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
        GestureDetector(
          onTap: () => showIconModalCategories(
            context,
            iconBtnCategory,
            (value) {
              // typeCategories.clear();
              // typeCategories.addAll(value);
              // user.copyWith(activitiesDocument: typeCategories);
              setState(() {});
            },
            listCategories,
            'Выбор до 3ех категорий',
            typeCategories,
          ),
          child: Stack(
            key: iconBtnCategory,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: 'Выбор до 3ех категорий',
                height: 50.h,
                enabled: false,
                onTap: () {},
                textEditingController:
                    TextEditingController(text: 'Дизайн, ремонт, доставка'),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
                    hintStyle: CustomTextStyle.grey_12_w400,
                    maxLines: 6,
                    textEditingController: aboutMeController,
                    onChanged: (value) {
                      user.copyWith(activity: value);
                      setState(() {});
                    },
                    formatters: [LengthLimitingTextInputFormatter(250)],
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
                    '${aboutMeController.text.length}/250',
                    style: CustomTextStyle.grey_10_w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            ScaleButton(
              duration: const Duration(milliseconds: 50),
              bound: 0.01,
              onTap: _selectImages,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 11.h),
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
                    SizedBox(width: 9.17.w),
                    Text(
                      'Изображения (10мб)',
                      style: CustomTextStyle.black_10_w400,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(width: 12.h),
            ScaleButton(
              duration: const Duration(milliseconds: 50),
              bound: 0.01,
              onTap: _selectCV,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 11.h),
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
                    SizedBox(width: 9.17.w),
                    Text(
                      'Загрузить резюме (10мб)',
                      style: CustomTextStyle.black_10_w400,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
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
