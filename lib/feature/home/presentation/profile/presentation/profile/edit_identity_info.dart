import 'dart:io';
import 'dart:math';

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
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';

class EditIdentityInfo extends StatefulWidget {
  const EditIdentityInfo({Key? key}) : super(key: key);

  @override
  State<EditIdentityInfo> createState() => _EditIdentityInfoState();
}

class _EditIdentityInfoState extends State<EditIdentityInfo> {
  final GlobalKey _iconBtn = GlobalKey();

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
  DateTime? dateTime;
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
  @override
  void initState() {
    user = BlocProvider.of<ProfileBloc>(context).user!;
    fillData(user);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        body: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Transform.rotate(
                      angle: pi,
                      child: SvgPicture.asset(
                        'assets/icons/arrow_right.svg',
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Безопасность',
                    style: CustomTextStyle.black_21_w700,
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            Expanded(child: secondStage(heightKeyBoard)),
            // const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: CustomButton(
                onTap: () {
                  user!.copyWith(isEntity: physics);
                  BlocProvider.of<ProfileBloc>(context).setUser(user);
                  Repository().updateUser(
                      BlocProvider.of<ProfileBloc>(context).access, user!);
                  Navigator.of(context).pop();
                },
                btnColor: ColorStyles.yellowFFD70B,
                textLabel: Text(
                  'Сохранить',
                  style: CustomTextStyle.black_14_w600_171716,
                ),
              ),
            ),
            SizedBox(height: 52.h),
          ],
        ),
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
        // CustomTextField(
        //   hintText: 'Пароль',
        //   hintStyle: CustomTextStyle.grey_13_w400,
        //   height: 50.h,
        //   focusNode: focusNodePassword1,
        //   obscureText: !visiblePassword,
        //   suffixIcon: GestureDetector(
        //     onTap: () {
        //       visiblePassword = !visiblePassword;
        //       setState(() {});
        //     },
        //     child: visiblePassword
        //         ? const Icon(Icons.remove_red_eye_outlined)
        //         : Stack(
        //             alignment: Alignment.center,
        //             children: [
        //               SvgPicture.asset(
        //                 'assets/icons/eye_close.svg',
        //                 height: 18.h,
        //               ),
        //             ],
        //           ),
        //   ),
        //   textEditingController: passwordController,
        //   contentPadding:
        //       EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        //   onChanged: (value) {
        //     user!.copyWith(password: value);
        //   },
        //   onFieldSubmitted: (value) {
        //     requestNextEmptyFocusStage2();
        //   },
        //   onTap: () {
        //     Future.delayed(const Duration(milliseconds: 300), () {
        //       scrollController2.animateTo(0.h,
        //           duration: const Duration(milliseconds: 100),
        //           curve: Curves.linear);
        //     });
        //   },
        // ),
        // SizedBox(height: 16.h),
        // CustomTextField(
        //   hintText: 'Повторите пароль',
        //   hintStyle: CustomTextStyle.grey_13_w400,
        //   height: 50.h,
        //   focusNode: focusNodePassword2,
        //   obscureText: !visiblePasswordRepeat,
        //   suffixIcon: GestureDetector(
        //     onTap: () {
        //       visiblePasswordRepeat = !visiblePasswordRepeat;
        //       setState(() {});
        //     },
        //     child: visiblePasswordRepeat
        //         ? const Icon(Icons.remove_red_eye_outlined)
        //         : Stack(
        //             alignment: Alignment.center,
        //             children: [
        //               SvgPicture.asset(
        //                 'assets/icons/eye_close.svg',
        //                 height: 18.h,
        //               ),
        //             ],
        //           ),
        //   ),
        //   onFieldSubmitted: (value) {
        //     requestNextEmptyFocusStage2();
        //   },
        //   textEditingController: repeatPasswordController,
        //   contentPadding:
        //       EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
        //   onTap: () {
        //     Future.delayed(const Duration(milliseconds: 300), () {
        //       scrollController2.animateTo(50.h,
        //           duration: const Duration(milliseconds: 100),
        //           curve: Curves.linear);
        //     });
        //   },
        // ),
        // SizedBox(height: 16.h),
        GestureDetector(
          key: _countryKey,
          onTap: () => showCountry(
            context,
            _countryKey,
            (value) {
              countryController.text = value;
              regionController.text = '';
              user?.copyWith(country: countryController.text);
              setState(() {});
            },
            country,
            'Выберите страну',
          ),
          child: CustomTextField(
            hintText: 'Страна',
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
          key: _regionKey,
          onTap: () {
            if (countryController.text.isNotEmpty) {
              showRegion(
                context,
                _regionKey,
                (value) {
                  regionController.text = value;
                  user!.copyWith(region: value);
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
            GlobalKeys.keyIconBtn2,
            (value) {
              documentTypeController.text = value;
              additionalInfo = true;
              user?.copyWith(docType: mapDocumentType(value));
              setState(() {});
            },
            ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
            'Тип документа',
          ),
          child: Stack(
            key: GlobalKeys.keyIconBtn2,
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
                hintStyle: CustomTextStyle.grey_13_w400,
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
              hintStyle: CustomTextStyle.grey_13_w400,
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
            hintStyle: CustomTextStyle.grey_13_w400,
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
              _showDatePicker(context, false,
                  title: user?.docType == 'Resident_ID'
                      ? 'Срок действия'
                      : 'Дата выдачи');
            },
            child: CustomTextField(
              hintText: user?.docType == 'Resident_ID'
                  ? 'Срок действия'
                  : 'Дата выдачи',
              enabled: false,
              hintStyle: CustomTextStyle.grey_13_w400,
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
            hintStyle: CustomTextStyle.grey_13_w400,
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
            hintStyle: CustomTextStyle.grey_13_w400,
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

  void _showDatePicker(ctx, bool isInternational, {String? title}) {
    print('title is: $title');
    dateTime = null;
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
                                      fontSize: 14.sp, color: Colors.black),
                                ),
                                onPressed: () {
                                  if (dateTime == null) {
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
                        maximumDate: title != null
                            ? title == 'Срок действия'
                                ? DateTime(DateTime.now().year + 10,
                                    DateTime.now().month, DateTime.now().day)
                                : DateTime.now()
                            : DateTime.now(),
                        minimumDate: DateTime(2000, 1, 1, 1),
                        onDateTimeChanged: (val) {
                          dateTime = val;
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
                        }),
                  ),
                ],
              ),
            ));
  }

  void documentEdit() {
    print(dateDocController.text);
    user!.copyWith(
      docInfo:
          'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}',
    );
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
    print(countryController.text);
    if (userRegModel.country != null) {
      countryController.text = userRegModel.country!;
    }

    if (userRegModel.docInfo == null) return;
    additionalInfo = true;
    serialDocController.text =
        DocumentInfo.fromJson(userRegModel.docInfo!).serial ?? '';
    print(DocumentInfo.fromJson(userRegModel.docInfo!).serial);
    numberDocController.text =
        DocumentInfo.fromJson(userRegModel.docInfo!).documentNumber ?? '';
    whoGiveDocController.text =
        DocumentInfo.fromJson(userRegModel.docInfo!).whoGiveDocument ?? '';
    dateDocController.text =
        DocumentInfo.fromJson(userRegModel.docInfo!).documentData ?? '';
  }
}
