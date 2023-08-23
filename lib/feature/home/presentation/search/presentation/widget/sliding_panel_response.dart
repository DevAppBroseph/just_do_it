import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/widget/formatter_currency.dart';
import 'package:just_do_it/feature/auth/widget/formatter_upper.dart';
import 'package:just_do_it/feature/auth/widget/textfield_currency.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response/response_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelResponse extends StatefulWidget {
  final PanelController panelController;
  final Task? selectTask;

  const SlidingPanelResponse(this.panelController, {super.key, required this.selectTask});

  @override
  State<SlidingPanelResponse> createState() => _SlidingPanelResponseState();
}

class _SlidingPanelResponseState extends State<SlidingPanelResponse> {
  double heightPanel = 637.h;
  bool slide = false;
  FocusNode focusNodeDiscription = FocusNode();
  FocusNode focusCoastMax = FocusNode();
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController coastController = TextEditingController();
  TypeFilter typeFilter = TypeFilter.main;
  int groupValue = 0;
  int page = 0;
  bool isGraded = false;
  bool visiblePassword = false;
  bool visiblePasswordRepeat = false;
  bool additionalInfo = false;

  bool confirmTermsPolicy = false;
  DateTime? dateTimeStart;
  DateTime? dateTimeEnd;
  List<Activities> listCategories = [];
  bool physics = false;

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
  bool proverka = false;
  bool customerFlag = true;
  bool contractorFlag = true;
  bool res = false;
  void getProfile() {
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    log(proverka.toString());
    if (proverka == false) {
      focusNodeDiscription.unfocus();
      focusCoastMax.unfocus();
    }
    user = BlocProvider.of<ProfileBloc>(context).user;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    log(bottomInsets.toString());
    return BlocBuilder<ResponseBloc, ResponseState>(buildWhen: (previous, current) {
      if (current is OpenSlidingPanelToState) {
        heightPanel = current.height;
        widget.panelController.animatePanelToPosition(1);

        return true;
      } else {
        heightPanel = 500.h;
      }
      return true;
    }, builder: (context, snapshot) {
      return SlidingUpPanel(
        controller: widget.panelController,
        renderPanelSheet: false,
        panel: panel(context, bottomInsets),
        onPanelSlide: (position) {
          if (position == 0) {
            BlocProvider.of<ResponseBloc>(context).add(HideSlidingPanelEvent());
            typeFilter = TypeFilter.main;
            slide = false;
            focusNodeDiscription.unfocus();
            focusCoastMax.unfocus();
            proverka = false;
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

  Widget panel(BuildContext context, double bottomInsets) {
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
                        mainFilter(heightKeyBoard, bottomInsets),
                      ],
                    ),
                  ),
                  if (widget.selectTask?.asCustomer != null)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: CustomButton(
                        onTap: () async {
                          if (user!.isBanned!) {
                            if (widget.selectTask!.asCustomer!) {
                              banDialog(context, 'responses_to_tasks_is'.tr());
                            } else {
                              banDialog(context, 'responses_to_offers_is'.tr());
                            }
                          } else {
                            final access = await Storage().getAccessToken();
                            if (widget.selectTask != null) {
                              String error = 'specify'.tr();
                              bool errorsFlag = false;
                              if (coastController.text.isEmpty) {
                                error += '\n- ${'amount'.tr()}';
                                errorsFlag = true;
                              }
                              if (descriptionTextController.text.isEmpty) {
                                error += '\n- ${'description'.tr().toLowerCase()}';
                                errorsFlag = true;
                              }
                              if (errorsFlag == true) {
                                CustomAlert().showMessage(error, context);
                              } else {
                                if (widget.selectTask!.asCustomer!) {
                                  res = await Repository().createAnswer(
                                      widget.selectTask!.id!,
                                      access,
                                      int.parse(coastController.text.replaceAll(' ', '')),
                                      descriptionTextController.text,
                                      'Progress',
                                      isGraded);
                                  isGraded = false;
                                } else {
                                  res = await Repository().createAnswer(
                                      widget.selectTask!.id!,
                                      access,
                                      int.parse(coastController.text.replaceAll(' ', '')),
                                      descriptionTextController.text,
                                      'Selected',
                                      isGraded);
                                  isGraded = false;
                                }
                                if (res) {
                                  widget.panelController.animatePanelToPosition(0);
                                  coastController.clear();
                                  descriptionTextController.clear();
                                  context.read<TasksBloc>().add(UpdateTaskEvent());
                                  BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                                  setState(() {});
                                } else {
                                  noMoney(context, 'raise_response'.tr(), 'response_to_the_top'.tr());
                                }
                              }
                            }
                          }
                        },
                        btnColor: ColorStyles.yellowFFD70A,
                        textLabel: Text(
                          widget.selectTask!.asCustomer! ? 'respond'.tr() : 'accept_the_offer'.tr(),
                          style: CustomTextStyle.black_16_w600_171716,
                        ),
                      ),
                    ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomButton(
                          onTap: () {
                            if (isGraded) {
                            } else {
                              onTopDialog(context, 'put_on_top'.tr(), 'response_is_fixed_in_the_top'.tr(),
                                  'your_ad_is_now_above_others'.tr());
                              setState(() {
                                isGraded = true;
                              });
                            }
                          },
                          btnColor: isGraded ? ColorStyles.greyDADADA : ColorStyles.purpleA401C4,
                          textLabel: Text(
                            'become_the_first'.tr(),
                            style: isGraded ? CustomTextStyle.grey_14_w600 : CustomTextStyle.white_14,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 150.w),
                          child: Align(
                            child: GestureDetector(
                              onTap: () {
                                helpOnTopDialog(context, 'put_on_top'.tr(), 'the_visibility_of_your_response'.tr());
                              },
                              child: SvgPicture.asset(
                                SvgImg.help,
                                color: Colors.white,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
              if (bottomInsets > MediaQuery.of(context).size.height / 3.7)
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
                            proverka = false;
                            FocusScope.of(context).unfocus();
                            context.read<ResponseBloc>().add(OpenSlidingPanelToEvent(500.h));
                          },
                          child: Text(
                            'done'.tr(),
                            style: CustomTextStyle.black_empty,
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

  Widget mainFilter(double heightKeyBoard, double bottomInsets) {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
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
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              Text(
                'your_response_to_the_task'.tr(),
                style: CustomTextStyle.black_22_w700_171716,
              ),
              SizedBox(height: 30.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {},
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.selectTask?.currency?.name == null)
                        Text(
                          '${'budget_from'.tr()} ',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                      if (widget.selectTask?.currency?.name == 'Российский рубль')
                        Text(
                          '${'budget_from'.tr()} ₽',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                      if (widget.selectTask?.currency?.name == 'Доллар США')
                        Text(
                          '${'budget_from'.tr()} \$',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                      if (widget.selectTask?.currency?.name == 'Евро')
                        Text(
                          '${'budget_from'.tr()} €',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                      if (widget.selectTask?.currency?.name == 'Дирхам')
                        Text(
                          '${'budget_from'.tr()} AED',
                          style: CustomTextStyle.grey_14_w400,
                        ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          CustomTextFieldCurrency(
                            height: 20.h,
                            width: 80.w,
                            textInputType: TextInputType.number,
                            actionButton: false,
                            focusNode: focusCoastMax,
                            onTap: () {
                              proverka = true;
                              context.read<ResponseBloc>().add(OpenSlidingPanelToEvent(600.h));
                              setState(() {});
                            },
                            onChanged: (value) {},
                            onFieldSubmitted: (value) {
                              setState(() {});
                            },
                            formatters: [FilteringTextInputFormatter.digitsOnly, FormatterCurrency()],
                            contentPadding: EdgeInsets.zero,
                            hintText: '',
                            fillColor: ColorStyles.greyF9F9F9,
                            maxLines: null,
                            style: CustomTextStyle.black_14_w400_171716,
                            textEditingController: coastController,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              ScaleButton(
                onTap: () {},
                bound: 0.02,
                child: Container(
                  height: 165.h,
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'covering_letter'.tr(),
                        style: CustomTextStyle.grey_14_w400,
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          CustomTextField(
                            height: 90.h,
                            width: 285.w,
                            autocorrect: true,
                            actionButton: false,
                            focusNode: focusNodeDiscription,
                            maxLines: 3,
                            onTap: () {
                              proverka = true;
                              log(bottomInsets.toString());
                              context.read<ResponseBloc>().add(OpenSlidingPanelToEvent(700.h));
                              setState(() {});
                            },
                            style: CustomTextStyle.black_14_w400_171716,
                            textEditingController: descriptionTextController,
                            fillColor: ColorStyles.greyF9F9F9,
                            onChanged: (value) {
                              setState(() {});
                            },
                            formatters: [
                              UpperEveryTextInputFormatter(),
                              LengthLimitingTextInputFormatter(100),
                            ],
                            hintText: '',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${descriptionTextController.text.length}/100',
                            style: CustomTextStyle.grey_12_w400,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 18.h),
              SizedBox(height: bottomInsets)
            ],
          ),
        ),
      ],
    );
  }
}
