import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/task/task_category.dart';
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
  final GlobalKey _documentKey = GlobalKey();
  bool confirmTermsPolicy = false;
  DateTime? dateTimeStart;
  DateTime? dateTimeEnd;
  List<TaskCategory> listCategories = [];

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

  String region = '';
  String docinfo = '';
  String docType = '';

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user!.duplicate();
    fillData(user);
  }

  @override
  Widget build(BuildContext context) {
    if (documentTypeController.text.isNotEmpty) {
      additionalInfo = true;
      documentEdit();
    } else {
      additionalInfo = false;
    }
    double heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;

    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: LightAppColors.whitePrimary,
        body: Column(
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
                    'security'.tr(),
                    style:
                        CustomTextStyle.sf22w700(LightAppColors.blackSecondary),
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
                  if (passwordController.text.isNotEmpty ||
                      repeatPasswordController.text.isNotEmpty) {
                    if (passwordController.text.length < 6) {
                      CustomAlert().showMessage(
                          'the_minimum_password_length_is_6_characters'.tr());
                      return;
                    } else if (passwordController.text !=
                        repeatPasswordController.text) {
                      CustomAlert().showMessage('passwords_dont_match'.tr());
                      return;
                    }
                  }

                  if (dateTimeEnd != null &&
                      DateTime.now().isAfter(dateTimeEnd!) &&
                      docType != 'Resident_ID') {
                    CustomAlert().showMessage('your_document_is_overdue'.tr());
                  } else if (dateTimeEnd != null &&
                      DateTime.now().isAfter(dateTimeEnd!) &&
                      docType == 'Resident_ID') {
                    CustomAlert().showMessage('your_document_is_overdue'.tr());
                  } else if (checkExpireDate(dateTimeEnd) != null) {
                    CustomAlert().showMessage(checkExpireDate(dateTimeEnd)!);
                  } else if (regionController.text.isEmpty) {
                    CustomAlert().showMessage('select_a_region'.tr());
                  } else {
                    if (additionalInfo) {
                      additionalInfo = true;
                      String error = 'specify'.tr();
                      if (docType != 'Resident_ID' &&
                          serialDocController.text.isEmpty) {
                        error += '\n- ${'document_series'.tr()}';
                      }
                      if (numberDocController.text.isEmpty) {
                        error += '\n- ${'document_number'.tr()}';
                      }
                      if (numberDocController.text.length < 5) {
                        error += '\n- ${'number_document'.tr()}';
                      }
                      if (whoGiveDocController.text.length < 3) {
                        if (docType == 'Resident_ID') {
                          error +=
                              '\n- ${'who_issued_the_document_more'.tr().toLowerCase()}';
                        }
                      }

                      if (whoGiveDocController.text.isEmpty) {
                        if (docType == 'Passport') {
                          error +=
                              '\n- ${'who_issued_the_document'.tr().toLowerCase()}';
                        } else if (docType == 'Resident_ID') {
                          error +=
                              '\n- ${'place_of_issue_of_the_document'.tr().toLowerCase()}';
                        } else {
                          error +=
                              '\n- ${'date_of_issue_of_the_document'.tr().toLowerCase()}';
                        }
                      }
                      if (dateDocController.text.isEmpty) {
                        error +=
                            '\n- ${'validity_period_of_the_document'.tr().toLowerCase()}';
                      }
                      if (error == 'specify'.tr()) {
                        user!.copyWith(
                            password: passwordController.text.isEmpty
                                ? null
                                : passwordController.text,
                            docInfo: docinfo,
                            region: regionController.text,
                            docType:
                                mapDocumentType(documentTypeController.text),
                            isEntity: false,
                            canAppellate: true);
                        BlocProvider.of<ProfileBloc>(context).setUser(user);
                        Repository().updateUser(
                            BlocProvider.of<ProfileBloc>(context).access,
                            user!);
                        BlocProvider.of<ProfileBloc>(context)
                            .add(UpdateProfileEvent(user));

                        Navigator.of(context).pop();
                      } else {
                        CustomAlert().showMessage(error);
                      }
                    } else {
                      user!.copyWith(
                          password: passwordController.text.isEmpty
                              ? null
                              : passwordController.text,
                          docInfo: '',
                          region: regionController.text,
                          docType: '',
                          isEntity: false,
                          canAppellate: true);
                      BlocProvider.of<ProfileBloc>(context).setUser(user);
                      Repository().updateUser(
                          BlocProvider.of<ProfileBloc>(context).access, user!);
                      BlocProvider.of<ProfileBloc>(context)
                          .add(UpdateProfileEvent(user));
                      Navigator.of(context).pop();
                    }
                  }
                },
                btnColor: LightAppColors.yellowSecondary,
                textLabel: Text(
                  'save'.tr(),
                  style:
                      CustomTextStyle.sf17w600(LightAppColors.blackSecondary),
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
        Container(
          height: 50.h,
          decoration: BoxDecoration(
            color: LightAppColors.greyPrimary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const Spacer(),
                  CustomTextField(
                    hintText: '',
                    hintStyle:
                        CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
                  'new_password'.tr(),
                  style: CustomTextStyle.sf13w400(LightAppColors.greySecondary),
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
            color: LightAppColors.greyPrimary,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  const Spacer(),
                  CustomTextField(
                    hintText: '',
                    hintStyle:
                        CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
                  'repeat_the_password'.tr(),
                  style: CustomTextStyle.sf13w400(LightAppColors.greySecondary),
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
              countryController.text =
                  user?.rus ?? true ? value.name ?? '-' : value.engName ?? '-';
              selectCountries = value;
              regionController.text = '';
              listRegions.clear();
              listRegions = await Repository().regions(selectCountries!);
              user?.copyWith(country: countryController.text);
              setState(() {});
            },
            listCountries,
            'select_a_country'.tr(),
          ),
          child: CustomTextField(
            hintText: 'country'.tr(),
            hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
            if (listRegions.isNotEmpty) {
              showRegion(
                context,
                _regionKey,
                (value) {
                  regionController.text = user?.rus ?? true
                      ? value.name ?? '-'
                      : value.engName ?? '-';
                  // user!.copyWith(region: regionController.text);
                  region = regionController.text;
                  setState(() {});
                },
                listRegions,
                'select_a_region'.tr(),
              );
            } else {
              CustomAlert().showMessage(
                  'to_select_a_region_first_specify_the_country'.tr());
            }
          },
          child: CustomTextField(
            hintText: 'region'.tr(),
            hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
            _documentKey,
            (value) {
              documentTypeController.text = value;
              additionalInfo = true;
              // user?.copyWith(docType: mapDocumentType(value));
              docType = mapDocumentType(value);
              setState(() {});
            },
            [
              'passport_of_the_RF'.tr(),
              'foreign_passport'.tr(),
              'resident_ID'.tr()
            ],
            'document'.tr(),
          ),
          child: Stack(
            key: _documentKey,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: 'document'.tr(),
                hintStyle:
                    CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
                              docinfo = '';
                              docType = '';
                              user?.copyWith(docType: '', docInfo: '');
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
            if (docType != 'Resident_ID')
              CustomTextField(
                hintText: 'series'.tr(),
                hintStyle:
                    CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
            if (docType != 'Resident_ID') SizedBox(width: 12.w),
            CustomTextField(
              hintText:
                  docType == 'Resident_ID' ? 'id_number'.tr() : 'number'.tr(),
              focusNode: focusNodeNumber,
              hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
              width: docType != 'Resident_ID'
                  ? ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 -
                      6.w
                  : MediaQuery.of(context).size.width - 48.w,
              textEditingController: numberDocController,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ],
        ),
        if (docType == 'Passport') SizedBox(height: 16.h),
        if (docType == 'Passport')
          CustomTextField(
            hintText: 'issued_by_whom'.tr(),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear);
              });
            },
            focusNode: focusNodeWhoTake,
            hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
        if (docType == 'International Passport') SizedBox(height: 16.h),
        if (docType == 'International Passport')
          GestureDetector(
            onTap: () async {
              _showDatePicker(
                context,
                0,
                false,
                title: 'date_of_issue'.tr(),
              );
            },
            child: CustomTextField(
              hintText: 'date_of_issue'.tr(),
              enabled: false,
              hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
              docType == 'Resident_ID'
                  ? true
                  : docType == 'Passport'
                      ? true
                      : true,
              title: 'validity_period'.tr(),
            );
          },
          child: CustomTextField(
            hintText: 'validity_period'.tr(),
            enabled: false,
            hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
        if (checkExpireDate(dateTimeEnd) != null)
          Text(
            checkExpireDate(dateTimeEnd)!,
            style: CustomTextStyle.sf12w400(LightAppColors.redSecondary),
          ),
        if (docType == 'Resident_ID') SizedBox(height: 16.w),
        if (docType == 'Resident_ID')
          CustomTextField(
            hintText: 'place_of_issue'.tr(),
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.linear);
              });
            },
            focusNode: focusNodeWhoTake,
            hintStyle: CustomTextStyle.sf15w400(LightAppColors.greySecondary),
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
        return 'the_validity_period_of_the_document_is_less_than_30_days'.tr();
      }
    }
    return null;
  }

  void _showDatePicker(ctx, int index, bool isInternational, {String? title}) {
    DateTime initialDateTime = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month,
                dateTimeStart!.day + 2)
            : DateTime(DateTime.now().year, DateTime.now().month,
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
            : DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1);

    DateTime minimumDate = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month,
                dateTimeStart!.day + 1)
            : DateTime(DateTime.now().year - 100, DateTime.now().month,
                DateTime.now().day + 1)
        : DateTime(DateTime.now().year - 100, DateTime.now().month,
            DateTime.now().day);

    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: const TextScaler.linear(1.0)),
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
                                  'done'.tr(),
                                  style: CustomTextStyle.sf17w400(
                                      LightAppColors.blackSecondary),
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
                            docinfo =
                                'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}';
                            // user!.copyWith(
                            // docInfo:
                            // 'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          } else {
                            dateTimeEnd = val;
                            if (isInternational) {
                              dateDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            } else {
                              whoGiveDocController.text =
                                  DateFormat('dd.MM.yyyy').format(val);
                            }
                            docinfo =
                                'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}';
                            // user!.copyWith(
                            //     docInfo:
                            //         'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          }
                        }),
                  ),
                ],
              ),
            ));
  }

  void documentEdit() {
    docinfo =
        'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}';
    // user!.copyWith(
    // docInfo:
    // 'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}',
    // );
  }

  void getCountries() async {
    listCountries = await Repository().countries();
    initRegions();
  }

  void initRegions() async {
    for (var element in listCountries) {
      if (user?.country?.toLowerCase() == element.name?.toLowerCase()) {
        listRegions = await Repository().regions(element);
        break;
      }
    }
    setState(() {});
  }

  fillData(UserRegModel? userRegModel) {
    if (userRegModel == null) return;
    if (userRegModel.docType != null && userRegModel.docType!.isNotEmpty) {
      documentTypeController.text =
          reverseMapDocumentType(userRegModel.docType!);
      docType = userRegModel.docType!;
    }
    if (userRegModel.region != null) {
      regionController.text = userRegModel.region!;
    }
    if (userRegModel.country != null) {
      countryController.text = userRegModel.country!;
    }

    if (userRegModel.docInfo != null && userRegModel.docInfo!.isNotEmpty) {
      additionalInfo = true;
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
    getCountries();
  }
}
