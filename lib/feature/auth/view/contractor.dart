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
  Uint8List? image;
  List<Uint8List> photos = [];
  Uint8List? cv;
  bool confirmTermsPolicy = false;
  UserRegModel user = UserRegModel(isEntity: false);
  List<Activities> listCategories = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(GetCategoriesEvent());
  }

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      Uint8List? file = await File(getMedia.path).readAsBytes();
      image = file;
      user.copyWith(photo: image);
    }
  }

  _selectImages() async {
    final getMedia = await ImagePicker().getMultiImage(imageQuality: 70);
    if (getMedia != null) {
      List<Uint8List> files = [];
      for (var pickedFile in getMedia) {
        Uint8List? file = await File(pickedFile.path).readAsBytes();
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
      allowedExtensions: ['pdf', 'doc'],
    );
    if (result != null) {
      cv = result.files.first.bytes;
      user.copyWith(cv: cv);
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
                  page = 1;
                  widget.stage(2);
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
              btnColor: yellow,
              textLabel: Text(
                page == 0 ? 'Далее' : 'Зарегистрироваться',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF171716),
                ),
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
              btnColor: const Color(0xFFE0E6EE),
              textLabel: Text(
                'Назад',
                style: TextStyle(
                  color: const Color(0xFF515150),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
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
          height: 50.h,
          textEditingController: firstnameController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          onChanged: (value) {
            user.copyWith(firstname: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Ваша фамилия',
          height: 50.h,
          textEditingController: lastnameController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          onChanged: (value) {
            user.copyWith(lastname: value);
          },
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Text(
              'Ваш пол',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
              ),
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
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          onChanged: (value) {
            user.copyWith(phoneNumber: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'E-mail',
          height: 50.h,
          textEditingController: emailController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          onChanged: (value) {
            user.copyWith(email: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Пароль',
          height: 50.h,
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
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          onChanged: (value) {
            user.copyWith(password: value);
          },
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Повторите пароль',
          height: 50.h,
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
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
              activeColor: yellow,
            ),
            Flexible(
              child: Text(
                'Согласен на обработку персональных данных и с пользовательским соглашением',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF515150),
                ),
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
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: _selectImage,
          child: CustomTextField(
            hintText: '   Добавить фото',
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
                EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          ),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Регион',
          height: 50.h,
          textEditingController: regionController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
              user.copyWith(docType: value);
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
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
                    EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 18.h, right: 18.h, top: 18.h, bottom: 30.h),
                child: SizedBox(
                  height: 100.h,
                  child: TextFormField(
                    maxLines: null,
                    onChanged: (value) {
                      user.copyWith(activity: value);
                      setState(() {});
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(250)],
                    controller: aboutMeController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: 'Описание своего опыта',
                      hintStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12.sp,
                        color: const Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SFPro',
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${aboutMeController.text.length}/250',
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 10.sp,
                      color: const Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'SFPro',
                    ),
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
                    SizedBox(width: 10.w),
                    Text(
                      'Изображения',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SFPro',
                      ),
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
                    SizedBox(width: 10.w),
                    Text(
                      'Загрузить резюме (10мб)',
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'SFPro',
                      ),
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
              value: true,
              onChanged: (value) {},
              checkColor: Colors.black,
              activeColor: yellow,
            ),
            Flexible(
              child: Text(
                'Юридическое лицо',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
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
          children: [
            CustomTextField(
              hintText: 'Серия',
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 - 6.w,
              textEditingController: serialDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              onChanged: (value) => documentEdit(),
            ),
            SizedBox(width: 12.w),
            CustomTextField(
              hintText: 'Номер',
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 - 6.w,
              textEditingController: numberDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              onChanged: (value) => documentEdit(),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Кем выдан',
          height: 50.h,
          textEditingController: whoGiveDocController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
          onChanged: (value) => documentEdit(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: 'Дата выдачи',
          height: 50.h,
          textEditingController: dateDocController,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
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
