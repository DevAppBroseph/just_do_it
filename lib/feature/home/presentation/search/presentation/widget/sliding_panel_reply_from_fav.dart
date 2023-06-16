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
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply_from_favourite/reply_fav_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelReplyFromFav extends StatefulWidget {
  final PanelController panelController;

  const SlidingPanelReplyFromFav(this.panelController, {super.key});

  @override
  State<SlidingPanelReplyFromFav> createState() => _SlidingPanelReplyFromFavState();
}

class _SlidingPanelReplyFromFavState extends State<SlidingPanelReplyFromFav> {
  double heightPanel = 637.h;
  List<Countries> countries = [];
  bool slide = false;
  DateTime? startDate;
  DateTime? endDate;

  TypeFilter typeFilter = TypeFilter.main;
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
  final GlobalKey _documentKey = GlobalKey();
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

  String region = '';
  String docinfo = '';
  String docType = '';

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();

  ScrollController mainScrollController = ScrollController();

  bool customerFlag = true;
  bool contractorFlag = true;

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;

    fillData(user);
    if (documentTypeController.text.isNotEmpty) {
      additionalInfo = true;
      documentEdit();
    } else {
      additionalInfo = false;
    }

    return BlocBuilder<ReplyFromFavBloc, ReplyState>(buildWhen: (previous, current) {
      if (current is OpenSlidingPanelToState) {
        heightPanel = current.height;
        widget.panelController.animatePanelToPosition(1);
        return true;
      } else {
        heightPanel = 637.h;
      }
      return true;
    }, builder: (context, snapshot) {
      return SlidingUpPanel(
        controller: widget.panelController,
        renderPanelSheet: false,
        panel: panel(context),
        onPanelSlide: (position) {
          if (position == 0) {
            BlocProvider.of<ReplyFromFavBloc>(context).add(HideSlidingPanelEvent());
            typeFilter = TypeFilter.main;
            slide = false;
          }
        },
        maxHeight: heightPanel,
        minHeight: 0.h,
        backdropEnabled: true,
        backdropColor: Colors.black,
        backdropOpacity: 0.8,
        defaultPanelState: PanelState.CLOSED,
      );
    });
  }

  Widget panel(BuildContext context) {
    double heightKeyBoard = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.r),
              topRight: Radius.circular(45.r),
            ),
            color: ColorStyles.whiteFFFFFF,
          ),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        mainFilter(heightKeyBoard),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      onTap: () {
                        if (dateTimeEnd != null && DateTime.now().isAfter(dateTimeEnd!) && docType != 'Resident_ID') {
                          CustomAlert().showMessage('Ваш паспорт просрочен', context);
                        } else if (dateTimeEnd != null &&
                            DateTime.now().isAfter(dateTimeEnd!) &&
                            docType == 'Resident_ID') {
                          CustomAlert().showMessage('Ваш документ просрочен', context);
                        } else if (checkExpireDate(dateTimeEnd) != null) {
                          CustomAlert().showMessage(checkExpireDate(dateTimeEnd)!, context);
                        } else {
                          if (additionalInfo) {
                            additionalInfo = true;
                            String error = 'Укажите:';
                            if (docType != 'Resident_ID' && serialDocController.text.isEmpty) {
                              error += '\n- серию документа';
                            }
                            if (numberDocController.text.isEmpty) {
                              error += '\n- номер документа';
                            }
                            if (whoGiveDocController.text.isEmpty) {
                              if (docType == 'Passport') {
                                error += '\n- кем выдан документ';
                              } else if (docType == 'Resident_ID') {
                                error += '\n- место выдачи документа';
                              } else {
                                error += '\n- дату выдачи документа';
                              }
                            }
                            if (dateDocController.text.isEmpty) {
                              error += '\n- срок действия документа';
                            }
                            if (error == 'Укажите:') {
                              user?.copyWith(docInfo: docinfo, docType: mapDocumentType(documentTypeController.text));
                              BlocProvider.of<ProfileBloc>(context).setUser(user);
                              log(user.toString());
                              Repository().updateUser(BlocProvider.of<ProfileBloc>(context).access, user!);
                              widget.panelController.animatePanelToPosition(0);
                            } else {
                              CustomAlert().showMessage(error, context);
                            }
                          } else {
                            user?.copyWith(docInfo: '', docType: '');
                            BlocProvider.of<ProfileBloc>(context).setUser(user);
                            Repository().updateUser(BlocProvider.of<ProfileBloc>(context).access, user!);
                            widget.panelController.animatePanelToPosition(0);
                          }
                        }
                      },
                      btnColor: ColorStyles.yellowFFD70A,
                      textLabel: Text(
                        'Готово',
                        style: CustomTextStyle.black_16_w600_171716,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainFilter(double heightKeyBoard) {
    String date = '';
    if (startDate == null && endDate == null) {
    } else {
      date = startDate != null ? DateFormat('dd.MM.yyyy').format(startDate!) : '';
      date += ' - ${endDate != null ? DateFormat('dd.MM.yyyy').format(endDate!) : ''}';
    }

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        SizedBox(height: 8.h),
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: 5.h,
              width: 81.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.r),
                color: ColorStyles.blueFC6554,
              ),
            ),
          ],
        ),
        SizedBox(height: 27.h),
        SizedBox(
          height: 510.h,
          child: ListView(
            shrinkWrap: true,
            controller: mainScrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              Text(
                'Станьте исполнителем',
                style: CustomTextStyle.black_22_w700_171716,
              ),
              SizedBox(height: 12.h),
              Text(
                'Чтобы выполнять задания, Вам необходимо дозаполнить информацию о себе.',
                style: CustomTextStyle.black_13_w400_515150,
              ),
              SizedBox(height: 30.h),
              GestureDetector(
                onTap: () => showIconModal(
                  context,
                  _documentKey,
                  (value) {
                    documentTypeController.text = value;
                    additionalInfo = true;
                    docType = mapDocumentType(value);
                    setState(() {});
                  },
                  ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
                  'Документ',
                ),
                child: Stack(
                  key: _documentKey,
                  alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      hintText: 'Документ',
                      hintStyle: CustomTextStyle.grey_14_w400,
                      width: 350.w,
                      height: 50.h,
                      enabled: false,
                      onTap: () {},
                      fillColor: Colors.grey[200],
                      textEditingController: documentTypeController,
                      contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
          ),
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
            if (docType != 'Resident_ID')
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
                        duration: const Duration(milliseconds: 100), curve: Curves.linear);
                  });
                },
                formatters: [
                  LengthLimitingTextInputFormatter(15),
                ],
                textInputType: TextInputType.number,
                width: ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 - 6.w,
                textEditingController: serialDocController,
                contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                onChanged: (value) => documentEdit(),
              ),
            if (docType != 'Resident_ID') SizedBox(width: 12.w),
            CustomTextField(
              hintText: docType == 'Resident_ID' ? 'Номер ID' : 'Номер',
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
                  scrollController2.animateTo(200.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
                });
              },
              width: docType != 'Resident_ID'
                  ? ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 - 6.w
                  : MediaQuery.of(context).size.width - 48.w,
              textEditingController: numberDocController,
              contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              onChanged: (value) => documentEdit(),
            ),
          ],
        ),
        if (docType == 'Passport') SizedBox(height: 16.h),
        if (docType == 'Passport')
          CustomTextField(
            hintText: 'Кем выдан',
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
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
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
                title: 'Дата выдачи',
              );
            },
            child: CustomTextField(
              hintText: 'Дата выдачи',
              enabled: false,
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 50.h,
              textEditingController: whoGiveDocController,
              contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
              title: 'Срок действия',
            );
          },
          child: CustomTextField(
            hintText: 'Срок действия',
            enabled: false,
            hintStyle: CustomTextStyle.grey_14_w400,
            height: 50.h,
            textEditingController: dateDocController,
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            formatters: [
              LengthLimitingTextInputFormatter(15),
            ],
            onChanged: (value) => documentEdit(),
          ),
        ),
        if (checkExpireDate(dateTimeEnd) != null)
          Text(
            checkExpireDate(dateTimeEnd)!,
            style: CustomTextStyle.red_11_w400_171716,
          ),
        if (docType == 'Resident_ID') SizedBox(height: 16.w),
        if (docType == 'Resident_ID')
          CustomTextField(
            hintText: 'Место выдачи',
            onTap: () {
              Future.delayed(const Duration(milliseconds: 300), () {
                scrollController2.animateTo(300.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
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
            contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            onChanged: (value) => documentEdit(),
          ),
      ],
    );
  }

  void _showDatePicker(ctx, int index, bool isInternational, {String? title}) {
    DateTime initialDateTime = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month, dateTimeStart!.day + 2)
            : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 2)
        : dateTimeStart ?? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1);

    DateTime maximumDate = index == 1
        ? DateTime(DateTime.now().year + 15, DateTime.now().month, DateTime.now().day)
        : dateTimeEnd != null
            ? DateTime(dateTimeEnd!.year, dateTimeEnd!.month, dateTimeEnd!.day - 1)
            : DateTime(DateTime.now().year + 15, DateTime.now().month, DateTime.now().day);

    DateTime minimumDate = index == 1
        ? dateTimeStart != null
            ? DateTime(dateTimeStart!.year, dateTimeStart!.month, dateTimeStart!.day + 1)
            : DateTime(DateTime.now().year - 15, DateTime.now().month, DateTime.now().day + 1)
        : DateTime(DateTime.now().year - 15, DateTime.now().month, DateTime.now().day);

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
                                  style: CustomTextStyle.black_15,
                                ),
                                onPressed: () {
                                  if (index == 0) {
                                    if (dateTimeStart == null) {
                                      dateTimeStart = DateTime.now();
                                      if (isInternational) {
                                        dateDocController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
                                      } else {
                                        whoGiveDocController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
                                      }
                                    }
                                  } else {
                                    if (dateTimeEnd == null) {
                                      dateTimeEnd = DateTime.now();
                                      if (isInternational) {
                                        dateDocController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
                                      } else {
                                        whoGiveDocController.text = DateFormat('dd.MM.yyyy').format(DateTime.now());
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
                              dateDocController.text = DateFormat('dd.MM.yyyy').format(val);
                            } else {
                              whoGiveDocController.text = DateFormat('dd.MM.yyyy').format(val);
                            }
                            docinfo =
                                'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}';
                            // user!.copyWith(
                            // docInfo:
                            // 'Серия: ${serialDocController.text}\nНомер: ${numberDocController.text}\nКем выдан: ${whoGiveDocController.text}\nДата выдачи: ${dateDocController.text}');
                          } else {
                            dateTimeEnd = val;
                            if (isInternational) {
                              dateDocController.text = DateFormat('dd.MM.yyyy').format(val);
                            } else {
                              whoGiveDocController.text = DateFormat('dd.MM.yyyy').format(val);
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

  String? checkExpireDate(DateTime? value) {
    if (value != null) {
      if (value.difference(DateTime.now()).inDays < 30) {
        return 'Срок действия документа составляет менее 30 дней';
      }
    }
    return null;
  }

  void requestNextEmptyFocusStage2() {
    if (additionalInfo) {
      if (serialDocController.text.isEmpty) {
        focusNodeSerial.requestFocus();
        scrollController2.animateTo(150.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else if (numberDocController.text.isEmpty) {
        focusNodeNumber.requestFocus();
        scrollController2.animateTo(150.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
      } else if (whoGiveDocController.text.isEmpty) {
        focusNodeWhoTake.requestFocus();
        scrollController2.animateTo(150.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
      }
    }
  }

  fillData(UserRegModel? userRegModel) {
    if (userRegModel == null) return;

    if (userRegModel.docType != null && userRegModel.docType!.isNotEmpty) {
      documentTypeController.text = reverseMapDocumentType(userRegModel.docType!);
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
      serialDocController.text = DocumentInfo.fromJson(userRegModel.docInfo!).serial ?? '';
      numberDocController.text = DocumentInfo.fromJson(userRegModel.docInfo!).documentNumber ?? '';
      whoGiveDocController.text = DocumentInfo.fromJson(userRegModel.docInfo!).whoGiveDocument ?? '';
      dateDocController.text = DocumentInfo.fromJson(userRegModel.docInfo!).documentData ?? '';
    }

    final start = dateDocController.text.split('.');
    final regDate = RegExp(r'\d{2}.\d{2}.\d{4}');
    if (start.isNotEmpty && regDate.hasMatch(dateDocController.text)) {
      dateTimeStart = DateTime(int.parse(start[2]), int.parse(start[1]), int.parse(start[0]));
    }

    final end = whoGiveDocController.text.split('.');
    if (end.isNotEmpty) {}
  }
}