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
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply_from_favourite/reply_fav_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelReplyFromFav extends StatefulWidget {
  final PanelController panelController;
  final Task? selectTask;
  const SlidingPanelReplyFromFav(this.panelController,
      {super.key, this.selectTask});

  @override
  State<SlidingPanelReplyFromFav> createState() =>
      _SlidingPanelReplyFromFavState();
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
  List<TaskCategory> listCategories = [];
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

    return BlocBuilder<ReplyFromFavBloc, ReplyState>(
        buildWhen: (previous, current) {
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
            BlocProvider.of<ReplyFromFavBloc>(context)
                .add(HideSlidingPanelEvent());
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
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(45.r),
              topRight: Radius.circular(45.r),
            ),
            color: LightAppColors.whitePrimary,
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
                        mainFilter(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      onTap: () {
                        if (dateTimeEnd != null &&
                            DateTime.now().isAfter(dateTimeEnd!) &&
                            docType != 'Resident_ID') {
                          CustomAlert().showMessage('Ваш паспорт просрочен');
                        } else if (dateTimeEnd != null &&
                            DateTime.now().isAfter(dateTimeEnd!) &&
                            docType == 'Resident_ID') {
                          CustomAlert().showMessage('Ваш документ просрочен');
                        } else if (checkExpireDate(dateTimeEnd) != null) {
                          CustomAlert()
                              .showMessage(checkExpireDate(dateTimeEnd)!);
                        } else {
                          if (additionalInfo) {
                            additionalInfo = true;
                            String error = 'specify'.tr();
                            if (docType != 'Resident_ID' &&
                                serialDocController.text.isEmpty) {
                              error += '\n- серию документа';
                            }
                            if (numberDocController.text.isEmpty) {
                              error += '\n- номер документа';
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
                            if (error == 'specify'.tr()) {
                              user?.copyWith(
                                  docInfo: docinfo,
                                  docType: mapDocumentType(
                                      documentTypeController.text));
                              BlocProvider.of<ProfileBloc>(context)
                                  .setUser(user);

                              Repository().updateUser(
                                  BlocProvider.of<ProfileBloc>(context).access,
                                  user!);
                              widget.panelController.animatePanelToPosition(0);
                            } else {
                              CustomAlert().showMessage(error);
                            }
                          } else {
                            user?.copyWith(docInfo: '', docType: '');
                            BlocProvider.of<ProfileBloc>(context).setUser(user);
                            Repository().updateUser(
                                BlocProvider.of<ProfileBloc>(context).access,
                                user!);
                            widget.panelController.animatePanelToPosition(0);
                          }
                        }
                      },
                      btnColor: LightAppColors.yellowPrimary,
                      textLabel: Text(
                        'done'.tr(),
                        style: CustomTextStyle.sf17w600(
                            LightAppColors.blackSecondary),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
              if (bottomInsets > MediaQuery.of(context).size.height / 4)
                Positioned(
                  bottom: bottomInsets,
                  child: Container(
                    height: 60.h,
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        const Spacer(),
                        CupertinoButton(
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            context
                                .read<ReplyFromFavBloc>()
                                .add(OpenSlidingPanelToEvent(637.h));
                          },
                          child: Text(
                            'done'.tr(),
                            style: CustomTextStyle.blackEmpty,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainFilter() {
    if (startDate == null && endDate == null) {
    } else {}

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
                color: LightAppColors.bluePrimary,
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
              if (widget.selectTask != null)
                Text(
                  widget.selectTask!.isTask!
                      ? 'become_a_performer'.tr()
                      : 'become_a_customer'.tr(),
                  style:
                      CustomTextStyle.sf22w700(LightAppColors.blackSecondary),
                ),
              SizedBox(height: 12.h),
              if (widget.selectTask != null)
                Text(
                  !widget.selectTask!.isTask!
                      ? 'to_accept_the_offer'.tr()
                      : 'to_complete_tasks'.tr(),
                  style: CustomTextStyle.sf17w400(LightAppColors.blackAccent),
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
                      hintStyle: CustomTextStyle.sf15w400(
                          LightAppColors.greySecondary),
                      width: 350.w,
                      height: 50.h,
                      enabled: false,
                      onTap: () {},
                      fillColor: Colors.grey[200],
                      textEditingController: documentTypeController,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 18.h),
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
                hintText: 'series'.tr(),
                hintStyle:
                    CustomTextStyle.sf15w400(LightAppColors.greySecondary),
                actionButton: false,
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
              actionButton: false,
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
                  // scrollController2.animateTo(200.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
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
              // Future.delayed(const Duration(milliseconds: 300), () {
              //   scrollController2.animateTo(300.h, duration: const Duration(milliseconds: 100), curve: Curves.linear);
              // });

              context
                  .read<ReplyFromFavBloc>()
                  .add(OpenSlidingPanelToEvent(720.h));
            },
            actionButton: false,
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

  String? checkExpireDate(DateTime? value) {
    if (value != null) {
      if (value.difference(DateTime.now()).inDays < 30) {
        return 'validity_period_v'.tr();
      }
    }
    return null;
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
      serialDocController.text = '';
      numberDocController.text = '';
      whoGiveDocController.text = '';
      dateDocController.text = '';
    }

    final start = dateDocController.text.split('.');
    final regDate = RegExp(r'\d{2}.\d{2}.\d{4}');
    if (start.isNotEmpty && regDate.hasMatch(dateDocController.text)) {
      dateTimeStart = DateTime(
          int.parse(start[2]), int.parse(start[1]), int.parse(start[0]));
    }

    final end = whoGiveDocController.text.split('.');
    if (end.isNotEmpty) {}
  }
}
