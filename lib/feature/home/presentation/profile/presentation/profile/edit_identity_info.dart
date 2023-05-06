import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class EditIdentityInfo extends StatefulWidget {
  const EditIdentityInfo({Key? key}) : super(key: key);

  @override
  State<EditIdentityInfo> createState() => _EditIdentityInfoState();
}

class _EditIdentityInfoState extends State<EditIdentityInfo> {
  int groupValue = 0;
  int page = 0;
  bool visiblePassword = false;
  bool visiblePasswordRepeat = false;
  bool additionalInfo = false;
  TextEditingController passwordController = TextEditingController();
  TextEditingController repeatPasswordController = TextEditingController();
  TextEditingController serialDocController = TextEditingController();
  TextEditingController numberDocController = TextEditingController();
  TextEditingController whoGiveDocController = TextEditingController();
  TextEditingController dateDocController = TextEditingController();
  TextEditingController documentTypeController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController regionController = TextEditingController();
  List<String> typeDocument = [];
  List<String> typeWork = [];
  TextEditingController aboutMeController = TextEditingController();
  File? image;
  final GlobalKey _countryKey = GlobalKey();
  final GlobalKey _regionKey = GlobalKey();
  bool confirmTermsPolicy = false;
  DateTime? dateTimeStart;
  DateTime? dateTimeEnd;
  List<Activities> listCategories = [];
  bool physics = false;

  FocusNode focusNodeAbout = FocusNode();
  FocusNode focusNodePassword1 = FocusNode();
  FocusNode focusNodePassword2 = FocusNode();
  FocusNode focusNodeSerial = FocusNode();
  FocusNode focusNodeNumber = FocusNode();
  FocusNode focusNodeWhoTake = FocusNode();

  ScrollController scrollController2 = ScrollController();
  late UserRegModel? user;
  List<Countries> listCountries = [];
  Countries? selectCountries;

  List<Regions> listRegions = [];
  Regions? selectRegions;

  @override
  void initState() {
    super.initState();
    listCountries.addAll(BlocProvider.of<CountriesBloc>(context).country);
    user = BlocProvider.of<ProfileBloc>(context).user!;
    fillData(user);
  }

  @override
  Widget build(BuildContext context) {
    double heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        body: BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, snapshot) {
          return Column(
            children: [
              SizedBox(height: 60.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Row(
                  children: [
                    CustomIconButton(
                      onBackPressed: () {
                        Navigator.of(context).pop();
                      },
                      icon: SvgImg.arrowRight,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Безопасность',
                      style: CustomTextStyle.black_22_w700,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50.h),
              Expanded(child: secondStage(heightKeyBoard)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: CustomButton(
                  onTap: () {
                    if ((passwordController.text.isNotEmpty &&
                            repeatPasswordController.text.isNotEmpty) &&
                        (passwordController.text !=
                            repeatPasswordController.text)) {
                      showAlertToast('Пароли не совпадают');
                    } else if (passwordController.text.length < 6 &&
                        passwordController.text.isNotEmpty) {
                      showAlertToast('минимальная длина пароля 6 символов');
                    } else {
                      user!.copyWith(isEntity: physics);
                      BlocProvider.of<ProfileBloc>(context).setUser(user);
                      Repository().updateUser(
                          BlocProvider.of<ProfileBloc>(context).access, user!);
                      Navigator.of(context).pop();
                    }
                    if (dateTimeEnd != null &&
                        DateTime.now().isAfter(dateTimeEnd!)) {
                      showAlertToast('Ваш паспорт просрочен');
                    } else if (checkExpireDate(dateTimeEnd) != null) {
                      showAlertToast(checkExpireDate(dateTimeEnd)!);
                    } else {
                      user!.copyWith(isEntity: physics);
                      // BlocProvider.of<CountriesBloc>(context)
                      //     .add(ResetCountryEvent());
                      BlocProvider.of<ProfileBloc>(context).setUser(user);
                      Repository().updateUser(
                          BlocProvider.of<ProfileBloc>(context).access, user!);
                      Navigator.of(context).pop();
                    }
                  },
                  btnColor: ColorStyles.yellowFFD70B,
                  textLabel: Text(
                    'Сохранить',
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                ),
              ),
              SizedBox(height: 52.h),
            ],
          );
        }),
      ),
    );
  }

  Widget secondStage(double heightKeyBoard) {
    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      controller: scrollController2,
      shrinkWrap: true,
      children: [
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: ColorStyles.greyEAECEE,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const Spacer(),
                  CustomTextField(
                    hintText: '',
                    hintStyle: CustomTextStyle.grey_14_w400,
                    height: 30.h,
                    focusNode: focusNodePassword1,
                    obscureText: !visiblePassword,
                    onFieldSubmitted: (value) {
                      requestNextEmptyFocusStage2();
                    },
                    textEditingController: passwordController,
                    contentPadding: EdgeInsets.only(left: 18.w, right: 50.w),
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        scrollController2.animateTo(50.h,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.linear);
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 18.h),
                child: Text(
                  'Новый пароль',
                  style: CustomTextStyle.grey_12_w400,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: GestureDetector(
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
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: ColorStyles.greyEAECEE,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const Spacer(),
                  CustomTextField(
                    hintText: '',
                    hintStyle: CustomTextStyle.grey_14_w400,
                    height: 30.h,
                    focusNode: focusNodePassword2,
                    obscureText: !visiblePasswordRepeat,
                    onFieldSubmitted: (value) {
                      requestNextEmptyFocusStage2();
                    },
                    textEditingController: repeatPasswordController,
                    contentPadding: EdgeInsets.only(left: 18.w, right: 50.w),
                    onTap: () {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        scrollController2.animateTo(50.h,
                            duration: const Duration(milliseconds: 100),
                            curve: Curves.linear);
                      });
                    },
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, left: 18.h),
                child: Text(
                  'Повторите пароль',
                  style: CustomTextStyle.grey_12_w400,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.w),
                  child: GestureDetector(
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
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        GestureDetector(
          key: _countryKey,
          onTap: () => showCountry(
            context,
            _countryKey,
            (value) async {
              countryController.text = value.name ?? '-';
              selectCountries = value;
              regionController.text = '';
              listRegions.clear();
              listRegions = await Repository().regions(selectCountries!);
              user?.copyWith(country: countryController.text);
              setState(() {});
            },
            listCountries,
            'Выберите страну',
          ),
          child: CustomTextField(
            hintText: 'Страна',
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
            log('message $listRegions');
            if (countryController.text.isNotEmpty) {
              showRegion(
                context,
                _regionKey,
                (value) {
                  regionController.text = value.name ?? '-';
                  user!.copyWith(region: regionController.text);
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
            hintText: 'Регион',
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
            GlobalKeys.keyIconBtn2,
            (value) {
              documentTypeController.text = value;
              additionalInfo = true;
              user?.copyWith(docType: mapDocumentType(value));
              setState(() {});
            },
            ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
            'Документ',
          ),
          child: Stack(
            key: GlobalKeys.keyIconBtn2,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: 'Документ',
                hintStyle: CustomTextStyle.grey_14_w400,
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
                              dateTimeStart = null;
                              dateTimeEnd = null;
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
        SizedBox(height: heightKeyBoard / 2),
      ],
    );
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

  Widget additionalInfoWidget() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 16.h),
        Row(
          children: [
            if (user?.docType != 'Resident_ID')
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
            if (user?.docType != 'Resident_ID') SizedBox(width: 12.w),
            CustomTextField(
              hintText: user?.docType == 'Resident_ID' ? 'Номер ID' : 'Номер',
              focusNode: focusNodeNumber,
              hintStyle: CustomTextStyle.grey_14_w400,
              onFieldSubmitted: (value) {
                requestNextEmptyFocusStage2();
              },
              formatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              height: 50.h,
              textInputType: TextInputType.number,
              onTap: () {
                Future.delayed(const Duration(milliseconds: 300), () {
                  scrollController2.animateTo(200.h,
                      duration: const Duration(milliseconds: 100),
                      curve: Curves.linear);
                });
              },
              width: user?.docType != 'Resident_ID'
                  ? ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 -
                      6.w
                  : MediaQuery.of(context).size.width - 42.w,
              textEditingController: numberDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ],
        ),
        if (user?.docType == 'Passport') SizedBox(height: 16.h),
        if (user?.docType == 'Passport')
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
            formatters: [
              LengthLimitingTextInputFormatter(35),
            ],
            height: 50.h,
            textEditingController: whoGiveDocController,
            onFieldSubmitted: (value) {
              requestNextEmptyFocusStage2();
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) => documentEdit(),
          ),
        if (user?.docType == 'International Passport') SizedBox(height: 16.h),
        if (user?.docType == 'International Passport')
          GestureDetector(
            onTap: () async {
              _showDatePicker(
                context,
                0,
                false,
                title: 'Дата выдачи',
              );
            },
            child: CustomTextField(
              hintText: 'Дата выдачи',
              enabled: false,
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 50.h,
              textEditingController: whoGiveDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              formatters: [
                LengthLimitingTextInputFormatter(15),
              ],
              onChanged: (value) => documentEdit(),
            ),
          ),
        SizedBox(height: 16.h),
        GestureDetector(
          onTap: () async {
            _showDatePicker(
              context,
              1,
              user?.docType == 'Resident_ID'
                  ? true
                  : user?.docType == 'Passport'
                      ? true
                      : true,
              title: 'Срок действия',
            );
          },
          child: CustomTextField(
            hintText: 'Срок действия',
            enabled: false,
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            textEditingController: dateDocController,
            contentPadding:
                EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            formatters: [
              LengthLimitingTextInputFormatter(15),
            ],
            onChanged: (value) => documentEdit(),
          ),
        ),
        Text(
          checkExpireDate(dateTimeEnd) ?? '',
          style: CustomTextStyle.red_11_w400_171716,
        ),
        if (user?.docType == 'Resident_ID') SizedBox(height: 16.h),
        if (user?.docType == 'Resident_ID')
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
            formatters: [
              LengthLimitingTextInputFormatter(35),
            ],
            height: 50.h,
            textEditingController: whoGiveDocController,
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

  String? checkExpireDate(DateTime? value) {
    if (value != null) {
      if (value.difference(DateTime.now()).inDays < 30) {
        return 'Срок действия документа составляет менее 30 дней';
      }
    }
    return null;
  }

  void _showDatePicker(ctx, int index, bool isInternational, {String? title}) {
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
                            user!.copyWith(
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
                            user!.copyWith(
                                docInfo:
                                    'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          }
                        }),
                  ),
                ],
              ),
            ));
  }

  void documentEdit() {
    user!.copyWith(
      docInfo:
          'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}',
    );
  }

  initRegions() async {
    for (var element in listCountries) {
      if (user?.country?.toLowerCase() == element.name?.toLowerCase()) {
        listRegions = await Repository().regions(element);
      }
    }
  }

  fillData(UserRegModel? userRegModel) {
    if (userRegModel == null) return;
    if (userRegModel.docType != null) {
      documentTypeController.text =
          reverseMapDocumentType(userRegModel.docType!);
    }
    if (userRegModel.region != null) {
      regionController.text = userRegModel.region!;
    }
    if (userRegModel.country != null) {
      countryController.text = userRegModel.country!;
    }

    additionalInfo = true;
    if (userRegModel.docInfo != null) {
      serialDocController.text =
          DocumentInfo.fromJson(userRegModel.docInfo!).serial ?? '';
      numberDocController.text =
          DocumentInfo.fromJson(userRegModel.docInfo!).documentNumber ?? '';
      whoGiveDocController.text =
          DocumentInfo.fromJson(userRegModel.docInfo!).whoGiveDocument ?? '';
      dateDocController.text =
          DocumentInfo.fromJson(userRegModel.docInfo!).documentData ?? '';
    }

    final start = dateDocController.text.split('.');
    final regDate = RegExp(r'\d{2}.\d{2}.\d{4}');
    if (start.isNotEmpty && regDate.hasMatch(dateDocController.text)) {
      dateTimeStart = DateTime(
          int.parse(start[2]), int.parse(start[1]), int.parse(start[0]));
    }

    final end = whoGiveDocController.text.split('.');
    if (end.isNotEmpty) {}
    initRegions();
  }
}
