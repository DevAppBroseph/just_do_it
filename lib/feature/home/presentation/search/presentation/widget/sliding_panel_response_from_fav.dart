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
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/response_from_favourite/response_fav_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelResponseFromFav extends StatefulWidget {
  final PanelController panelController;
  final Task? selectTask;

  const SlidingPanelResponseFromFav(this.panelController, {super.key, required this.selectTask});

  @override
  State<SlidingPanelResponseFromFav> createState() => _SlidingPanelResponseFromFavState();
}

class _SlidingPanelResponseFromFavState extends State<SlidingPanelResponseFromFav> {
  double heightPanel = 637.h;
  bool slide = false;
  TextEditingController descriptionTextController = TextEditingController();
  TextEditingController coastController = TextEditingController();
  TypeFilter typeFilter = TypeFilter.main;
  int groupValue = 0;
  int page = 0;
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

  bool customerFlag = true;
  bool contractorFlag = true;
  void getProfile() {
    context.read<ProfileBloc>().add(GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;

    return BlocBuilder<ResponseBlocFromFav, ResponseState>(buildWhen: (previous, current) {
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
        panel: panel(context),
        onPanelSlide: (position) {
          if (position == 0) {
            BlocProvider.of<ResponseBlocFromFav>(context).add(HideSlidingPanelEvent());
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

  Widget panel(
    BuildContext context,
  ) {
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
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
                          final access = await Storage().getAccessToken();
                          if (widget.selectTask != null) {
                            String error = 'Укажите:';
                            bool errorsFlag = false;
                            if (coastController.text.isEmpty) {
                              error += '\n- сумму';
                              errorsFlag = true;
                            }
                            if (descriptionTextController.text.isEmpty) {
                              error += '\n- описание';
                              errorsFlag = true;
                            }
                            if (errorsFlag == true) {
                              CustomAlert().showMessage(error, context);
                            } else {
                              widget.panelController.animatePanelToPosition(0);
                              if (widget.selectTask!.asCustomer!) {
                                Repository().createAnswer(
                                    widget.selectTask!.id!,
                                    access,
                                    int.parse(coastController.text.replaceAll(' ', '')),
                                    descriptionTextController.text,
                                    'Progress');
                              } else {
                                Repository().createAnswer(
                                    widget.selectTask!.id!,
                                    access,
                                    int.parse(coastController.text.replaceAll(' ', '')),
                                    descriptionTextController.text,
                                    'Selected');
                              }

                              coastController.clear();
                              descriptionTextController.clear();
                              context.read<TasksBloc>().add(UpdateTaskEvent());
                              BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
                              setState(() {});
                            }
                          }
                        },
                        btnColor: ColorStyles.yellowFFD70A,
                        textLabel: Text(
                          widget.selectTask!.asCustomer! ? 'Откликнуться' : 'Принять оффер',
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
                          onTap: () {},
                          btnColor: ColorStyles.purpleA401C4,
                          textLabel: Text(
                            'Стать первым',
                            style: CustomTextStyle.white_16_w600,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 150.w),
                          child: Align(
                            child: SvgPicture.asset(
                              SvgImg.help,
                              color: Colors.white,
                              width: 20,
                              height: 20,
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
                            FocusScope.of(context).unfocus();
                            context.read<ResponseBlocFromFav>().add(OpenSlidingPanelToEvent(500.h));
                          },
                          child: Text(
                            'Готово',
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
                'Ваш отклик на задание',
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
                            onTap: () {
                              context.read<ResponseBlocFromFav>().add(OpenSlidingPanelToEvent(600.h));
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
                  height: 150.h,
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
                        'Сопроводительное письмо',
                        style: CustomTextStyle.grey_14_w400,
                      ),
                      SizedBox(height: 3.h),
                      Row(
                        children: [
                          CustomTextField(
                            height: 90.h,
                            width: 285.w,
                            autocorrect: true,
                            maxLines: 3,
                            onTap: () {
                              context.read<ResponseBlocFromFav>().add(OpenSlidingPanelToEvent(700.h));
                              setState(() {});
                            },
                            style: CustomTextStyle.black_14_w400_171716,
                            textEditingController: descriptionTextController,
                            fillColor: ColorStyles.greyF9F9F9,
                            onChanged: (value) {
                              setState(() {});
                            },
                            formatters: [
                              LengthLimitingTextInputFormatter(100),
                              UpperEveryTextInputFormatter(),
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
            ],
          ),
        ),
      ],
    );
  }
}
