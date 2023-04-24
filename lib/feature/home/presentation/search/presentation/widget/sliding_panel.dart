import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/models/category.dart';
import 'package:just_do_it/models/category_select.dart';
import 'package:just_do_it/models/city.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelSearch extends StatefulWidget {
  PanelController panelController;

  SlidingPanelSearch(this.panelController, {super.key});

  @override
  State<SlidingPanelSearch> createState() => _SlidingPanelSearchState();
}

class _SlidingPanelSearchState extends State<SlidingPanelSearch> {
  double heightPanel = 686.h;
  bool passportAndCV = false;
  bool allCategory = false;
  bool allSubCategory = false;
  bool allCity = false;
  bool allCountry = false;
  int groupValueCity = 0;
  String str = '';
  String str2 = '';
  int? groupValueCountry;
  Activities? selectActivities;
  List<int?> selectSubCategory = [];
  List<Activities> activities = [];
  Activities? selectCategory;
  bool slide = false;
  List<String> isRegion = [];

  TypeFilter typeFilter = TypeFilter.main;

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();

  String? country;
  String? region;

  FocusNode focusCoastMin = FocusNode();
  FocusNode focusCoastMax = FocusNode();
  FocusNode focusCoastKeyWord = FocusNode();
  int openCategory = -1;
  ScrollController mainScrollController = ScrollController();

  bool customerFlag = true;
  bool contractorFlag = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(buildWhen: (previous, current) {
      if (current is OpenSlidingPanelToState) {
        heightPanel = current.height;
        // widget.panelController.open();
        widget.panelController.animatePanelToPosition(1);
        return true;
      } else {
        heightPanel = 686.h;
      }
      return true;
    }, builder: (context, snapshot) {
      return SlidingUpPanel(
        controller: widget.panelController,
        renderPanelSheet: false,
        panel: panel(context),
        onPanelSlide: (position) {
          if (position == 0) {
            BlocProvider.of<SearchBloc>(context).add(HideSlidingPanelEvent());
            typeFilter = TypeFilter.main;
            focusCoastMin.unfocus();
            focusCoastMax.unfocus();
            focusCoastKeyWord.unfocus();
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
    String? access = BlocProvider.of<ProfileBloc>(context).access;
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
                        typeFilter == TypeFilter.main
                            ? mainFilter()
                            : typeFilter == TypeFilter.category
                                ? categoryFirst()
                                : typeFilter == TypeFilter.category1
                                    ? categorySecond()
                                    : typeFilter == TypeFilter.date
                                        ? dateFilter()
                                        : typeFilter == TypeFilter.country
                                            ? listRegion(allRegoins)
                                            : const SizedBox()
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      onTap: () {
                        widget.panelController.animatePanelToPosition(0);
                        if (coastMinController.text == '') {
                          coastMinController.text = '0';
                        }
                        if (coastMaxController.text == '') {
                          coastMaxController.text = '50000000';
                        }
                        var format1 = endDate == null
                            ? null
                            : "${endDate?.year}-${endDate?.month}-${endDate?.day}";
                        var format2 = startDate == null
                            ? null
                            : "${startDate?.year}-${startDate?.month}-${startDate?.day}";

                        context.read<TasksBloc>().add(
                              GetTasksEvent(
                                access,
                                keyWordController.text,
                                format1,
                                format2,
                                int.parse(coastMinController.text),
                                int.parse(coastMaxController.text),
                                isRegion,
                                selectSubCategory,
                                (contractorFlag && customerFlag) ||
                                        (!contractorFlag && !customerFlag)
                                    ? null
                                    : customerFlag,
                              ),
                            );
                      },
                      btnColor: ColorStyles.yellowFFD70A,
                      textLabel: Text(
                        'Показать задания',
                        style: CustomTextStyle.black_16_w600_171716,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
              if (MediaQuery.of(context).viewInsets.bottom > 0 &&
                  (focusCoastMin.hasFocus ||
                      focusCoastMax.hasFocus ||
                      focusCoastKeyWord.hasFocus))
                Column(
                  children: [
                    const Spacer(),
                    AnimatedPadding(
                      duration: const Duration(milliseconds: 0),
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              color: Colors.grey[200],
                              child: MediaQuery(
                                data: MediaQuery.of(context)
                                    .copyWith(textScaleFactor: 1.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: InkWell(
                                      onTap: () {
                                        FocusScope.of(context).unfocus();
                                        slide = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 9.0,
                                            horizontal: 12.0,
                                          ),
                                          child: const Text('Готово')),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget mainFilter() {
    String date = '';
    if (startDate == null && endDate == null) {
      date =
          '${DateFormat('dd.MM.yyyy').format(DateTime.now())} - ${DateFormat('dd.MM.yyyy').format(DateTime.now())}';
    } else {
      date =
          startDate != null ? DateFormat('dd.MM.yyyy').format(startDate!) : '';
      date +=
          ' - ${endDate != null ? DateFormat('dd.MM.yyyy').format(endDate!) : ''}';
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
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    'Фильтры',
                    style: CustomTextStyle.black_22_w700,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      // endDate = DateTime.now();
                      // startDate = DateTime.now();
                      coastMinController.text = '';
                      coastMaxController.text = '';
                      keyWordController.text = '';
                      isRegion = [];
                      selectSubCategory = [];

                      country = '';
                      setState(() {});
                    },
                    child: Text(
                      'Очистить',
                      style: CustomTextStyle.red_16_w400,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
        SizedBox(
          height: 510.h,
          child: ListView(
            shrinkWrap: true,
            controller: mainScrollController,
            physics: const ClampingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            children: [
              ScaleButton(
                onTap: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(OpenSlidingPanelToEvent(686.h));
                  typeFilter = TypeFilter.category;
                },
                bound: 0.02,
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/crown.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Категории',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Все категории',
                            style: CustomTextStyle.black_14_w400_171716,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorStyles.greyBDBDBD,
                        size: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(OpenSlidingPanelToEvent(686.h));
                  typeFilter = TypeFilter.country;
                },
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/location.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'По регионам',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              country != null && country!.isNotEmpty
                                  ? country!
                                  : 'Все регионы',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: CustomTextStyle.black_14_w400_171716,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorStyles.greyBDBDBD,
                        size: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
              // SizedBox(height: 20.h),
              // ScaleButton(
              //   bound: 0.02,
              //   onTap: () {
              //     if (country != null && country!.isNotEmpty) {
              //       BlocProvider.of<SearchBloc>(context)
              //           .add(OpenSlidingPanelToEvent(686.h));
              //       typeFilter = TypeFilter.region;
              //     } else {
              //       showAlertToast('Выберите страну');
              //     }
              //   },
              //   child: Container(
              //     height: 55.h,
              //     padding: EdgeInsets.only(left: 16.w, right: 16.w),
              //     decoration: BoxDecoration(
              //       color: ColorStyles.greyF9F9F9,
              //       borderRadius: BorderRadius.circular(10.r),
              //     ),
              //     child: Row(
              //       children: [
              //         SvgPicture.asset('assets/icons/location.svg'),
              //         SizedBox(width: 10.w),
              //         Column(
              //           crossAxisAlignment: CrossAxisAlignment.start,
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Text(
              //               'По региону',
              //               style: CustomTextStyle.grey_12_w400,
              //             ),
              //             SizedBox(height: 3.h),
              //             SizedBox(
              //               width: 200.w,
              //               child: Text(
              //                 region != null && region!.isNotEmpty
              //                     ? region!
              //                     : 'Все регионы',
              //                 maxLines: 1,
              //                 overflow: TextOverflow.ellipsis,
              //                 style: CustomTextStyle.black_12_w400_171716,
              //               ),
              //             ),
              //           ],
              //         ),
              //         const Spacer(),
              //         Icon(
              //           Icons.arrow_forward_ios,
              //           color: ColorStyles.greyBDBDBD,
              //           size: 16.h,
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(OpenSlidingPanelToEvent(414.h));
                  typeFilter = TypeFilter.date;
                },
                child: Container(
                  height: 55.h,
                  padding: EdgeInsets.only(left: 16.w, right: 16.w),
                  decoration: BoxDecoration(
                    color: ColorStyles.greyF9F9F9,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset('assets/icons/calendar.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Даты начала и окончания',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            date,
                            style: CustomTextStyle.black_14_w400_171716,
                          ),
                        ],
                      ),
                      const Spacer(),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: ColorStyles.greyBDBDBD,
                        size: 16.h,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: ScaleButton(
                      bound: 0.02,
                      onTap: () {
                        focusCoastMin.requestFocus();
                        openKeyboard();
                      },
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
                            Text(
                              'Бюджет от ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomTextField(
                                  height: 20.h,
                                  width: 80.w,
                                  textInputType: TextInputType.number,
                                  focusNode: focusCoastMin,
                                  actionButton: false,
                                  onTap: () {
                                    slide = true;
                                    mainScrollController.animateTo(heightPanel,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.linear);
                                    setState(() {});
                                  },
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    slide = false;
                                    setState(() {});
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '',
                                  fillColor: ColorStyles.greyF9F9F9,
                                  maxLines: null,
                                  style: CustomTextStyle.black_14_w400_171716,
                                  textEditingController: coastMinController,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 21.w),
                  Expanded(
                    child: ScaleButton(
                      bound: 0.02,
                      onTap: () {
                        focusCoastMax.requestFocus();
                        openKeyboard();
                      },
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
                            Text(
                              'Бюджет до ₽',
                              style: CustomTextStyle.grey_14_w400,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomTextField(
                                  height: 20.h,
                                  width: 80.w,
                                  focusNode: focusCoastMax,
                                  actionButton: false,
                                  textInputType: TextInputType.number,
                                  onTap: () {
                                    slide = true;
                                    mainScrollController.animateTo(heightPanel,
                                        duration: const Duration(seconds: 1),
                                        curve: Curves.linear);
                                    setState(() {});
                                  },
                                  onChanged: (value) {},
                                  onFieldSubmitted: (value) {
                                    slide = false;
                                    setState(() {});
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  hintText: '',
                                  fillColor: ColorStyles.greyF9F9F9,
                                  maxLines: null,
                                  style: CustomTextStyle.black_14_w400_171716,
                                  textEditingController: coastMaxController,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  focusCoastKeyWord.requestFocus();
                  openKeyboard();
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 99.h,
                        padding:
                            EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
                        decoration: BoxDecoration(
                          color: ColorStyles.greyF9F9F9,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/quote-up-square.svg'),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ключевые слова',
                                      style: CustomTextStyle.grey_14_w400,
                                    ),
                                    Row(
                                      children: [
                                        CustomTextField(
                                          height: 60.h,
                                          width: 250.w,
                                          actionButton: false,
                                          textInputType: TextInputType.name,
                                          focusNode: focusCoastKeyWord,
                                          onTap: () {
                                            slide = true;
                                            Future.delayed(
                                                const Duration(
                                                    milliseconds: 200), () {
                                              mainScrollController.animateTo(
                                                  heightPanel,
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  curve: Curves.linear);
                                            });
                                            setState(() {});
                                          },
                                          onChanged: (value) {},
                                          onFieldSubmitted: (value) {
                                            slide = false;
                                            setState(() {});
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          hintText:
                                              'Например, покупка апельсинов..',
                                          fillColor: ColorStyles.greyF9F9F9,
                                          maxLines: 4,
                                          style: CustomTextStyle
                                              .black_14_w400_171716,
                                          textEditingController:
                                              keyWordController,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Паспортные данные загружены и есть резюме',
                      style: CustomTextStyle.black_13_w500_171716,
                    ),
                  ),
                  // const Spacer(),
                  Switch.adaptive(
                    activeColor: ColorStyles.yellowFFD70B,
                    value: passportAndCV,
                    onChanged: (value) {
                      passportAndCV = !passportAndCV;
                      setState(() {});
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r)),
                      value: customerFlag,
                      onChanged: (value) {
                        setState(() {
                          customerFlag = !customerFlag;
                        });
                      },
                      checkColor: Colors.black,
                      activeColor: ColorStyles.yellowFFD70A,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Задания от заказчиков',
                    style: CustomTextStyle.black_12_w400_515150,
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.r)),
                      value: contractorFlag,
                      onChanged: (value) {
                        setState(() {
                          contractorFlag = !contractorFlag;
                        });
                      },
                      checkColor: Colors.black,
                      activeColor: ColorStyles.yellowFFD70A,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Text(
                    'Задания от исполнителей',
                    style: CustomTextStyle.black_12_w400_515150,
                  ),
                ],
              ),
              if (slide) SizedBox(height: 250.h),
            ],
          ),
        ),
      ],
    );
  }

  void openKeyboard() {
    slide = true;
    mainScrollController.animateTo(heightPanel,
        duration: const Duration(seconds: 1), curve: Curves.linear);
    setState(() {});
  }

  Widget categoryFirst() {
    activities.clear();
    activities.addAll(BlocProvider.of<AuthBloc>(context).activities);
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
        Row(
          children: [
            CustomIconButton(
              onBackPressed: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              icon: SvgImg.arrowRight,
            ),
            SizedBox(width: 12.h),
            Text(
              'Категории',
              style: CustomTextStyle.black_22_w700,
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ScaleButton(
          bound: 0.02,
          child: Container(
            height: 55.h,
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  'Все категории',
                  style: CustomTextStyle.black_14_w400_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  activeColor: ColorStyles.yellowFFD70B,
                  value: allCategory,
                  onChanged: (value) {
                    allCategory = !allCategory;
                    setState(() {});
                    if (allCategory == true) {
                      for (int i = 0; i < activities.length; i++) {
                        for (int y = 0;
                            y < activities[i].subcategory.length;
                            y++) {
                          activities[i].subcategory[y].isSelect = true;
                          selectSubCategory
                              .add(activities[i].subcategory[y].id);
                        }
                        activities[i].isSelect = true;
                      }
                    }
                    if (allCategory == false) {
                      for (int i = 0; i < activities.length; i++) {
                        for (int y = 0;
                            y < activities[i].subcategory.length;
                            y++) {
                          activities[i].subcategory[y].isSelect = false;
                          selectSubCategory = [];
                        }
                        activities[i].isSelect = false;
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        SizedBox(
          height: 440.h,
          child: ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 3.w),
              physics: const ClampingScrollPhysics(),
              itemCount: activities.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    elementCategory(
                      activities[index].photo ?? '',
                      activities[index].description ?? '',
                      index,
                      choice: activities[index].selectSubcategory,
                    ),
                  ],
                );
              }),
        ),
      ],
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex,
      {List<String> choice = const []}) {
    String selectWork = '';
    if (choice.isNotEmpty) {
      selectWork = '- ${choice.first}';
      if (choice.length > 1) {
        for (int i = 1; i < choice.length; i++) {
          selectWork += ', ${choice[i]}';
        }
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w),
      child: GestureDetector(
        onTap: () {
          selectActivities = activities[currentIndex];
          BlocProvider.of<SearchBloc>(context)
              .add(OpenSlidingPanelToEvent(686.h));
          typeFilter = TypeFilter.category1;
        },
        child: Container(
          decoration: BoxDecoration(
            color: ColorStyles.whiteFFFFFF,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.shadowFC6554,
                offset: const Offset(0, -4),
                blurRadius: 55.r,
              )
            ],
          ),
          margin: EdgeInsets.only(bottom: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              if (icon != '')
                Image.network(
                  server + icon,
                  height: 20.h,
                ),
              SizedBox(width: 9.w),
              Text(
                title,
                style: CustomTextStyle.black_14_w400_171716,
              ),
              if (choice.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: SizedBox(
                    width: 70.w,
                    child: Text(
                      selectWork,
                      style: CustomTextStyle.grey_14_w400,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget itemCategory(Category category) {
  //   return GestureDetector(
  //     onTap: () {

  //     },
  //     child: Container(
  //       color: Colors.transparent,
  //       height: 50.h,
  //       child: Column(
  //         children: [
  //           const Spacer(),
  //           Row(
  //             children: [
  //               Image.asset(
  //                 category.icon,
  //                 height: 24.h,
  //               ),
  //               SizedBox(width: 12.w),
  //               Text(
  //                 category.title,
  //                 style: CustomTextStyle.black_13_w500_171716,
  //               ),
  //               const Spacer(),
  //               Icon(
  //                 Icons.arrow_forward_ios,
  //                 size: 16.h,
  //                 color: const Color(0xFFBDBDBD),
  //               )
  //             ],
  //           ),
  //           const Spacer(),
  //           const Divider()
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget categorySecond() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
        Row(
          children: [
            CustomIconButton(
              onBackPressed: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.category;
              },
              icon: SvgImg.arrowRight,
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: Text(
                selectActivities?.description ?? '',
                style: CustomTextStyle.black_22_w700,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ScaleButton(
          bound: 0.02,
          child: Container(
            height: 55.h,
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  'Все подкатегории',
                  style: CustomTextStyle.black_14_w400_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  activeColor: ColorStyles.yellowFFD70B,
                  value: selectActivities!.isSelect,
                  onChanged: (value) {
                    selectActivities!.isSelect = !selectActivities!.isSelect;
                    if (selectActivities!.isSelect) {
                      selectCategory = selectActivities;
                    } else {
                      selectCategory = null;
                    }
                    String str = '';
                    for (var element in selectActivities!.subcategory) {
                      element.isSelect = value;
                      str += '${element.id}, ';
                      if (element.isSelect == true) {
                        selectSubCategory.add(element.id);
                      }
                      if (element.isSelect == false) {
                        selectSubCategory.remove(element.id);
                      }
                    }

                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Column(children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: selectActivities!.subcategory.length,
            physics: const ClampingScrollPhysics(),
            itemBuilder: ((context, index) {
              return item(index, selectActivities!);
            }),
          ),
        ]),
      ],
    );
  }

  Widget item(int index, Activities? selectActivity) {
    return GestureDetector(
      onTap: () {
        selectActivities!.subcategory[index].isSelect =
            !selectActivities!.subcategory[index].isSelect;
        setState(() {});
        if (selectActivities!.subcategory[index].isSelect == true) {
          selectSubCategory.add(selectActivities!.subcategory[index].id);
        }
        if (selectActivities!.subcategory[index].isSelect == false) {
          selectSubCategory.remove(selectActivities!.subcategory[index].id);
        }
        print(selectSubCategory);
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Container(
          color: Colors.transparent,
          height: 40.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      selectActivities!.subcategory[index].description ?? '',
                      style: CustomTextStyle.black_14_w400_515150,
                    ),
                  ),
                  const Spacer(),
                  if (selectActivities!.subcategory[index].isSelect &&
                      selectSubCategory != [])
                    const Icon(Icons.check)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget itemCategory2(CategorySelect category) {
    return GestureDetector(
      onTap: () {
        // typeFilter = TypeFilter.category1;
        // BlocProvider.of<SearchBloc>(context)
        //     .add(OpenSlidingPanelToEvent(686.h));
      },
      child: SizedBox(
        height: 62.h,
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                SizedBox(width: 12.w),
                Text(
                  category.title,
                  style: CustomTextStyle.black_14_w500_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  activeColor: ColorStyles.yellowFFD70B,
                  value: category.select,
                  onChanged: (value) {
                    category.select = !category.select;
                    setState(() {});
                  },
                ),
              ],
            ),
            // const Spacer(),
            const Divider()
          ],
        ),
      ),
    );
  }

  Widget countryFilter() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
        Row(
          children: [
            CustomIconButton(
              onBackPressed: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              icon: SvgImg.arrowRight,
            ),
            SizedBox(width: 12.h),
            Text(
              'Страны',
              style: CustomTextStyle.black_22_w700,
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ScaleButton(
          bound: 0.02,
          child: Container(
            height: 55.h,
            padding: EdgeInsets.only(left: 16.w, right: 16.w),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Text(
                  'Все страны',
                  style: CustomTextStyle.black_14_w400_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  activeColor: ColorStyles.yellowFFD70B,
                  value: allCountry,
                  onChanged: (value) {
                    allCountry = !allCountry;
                    String str = '';
                    for (var element in countryList) {
                      element.select = value;
                      str += '${element.name}, ';
                    }
                    country = str;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        ListView(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(bottom: 50.h),
          children: [
            Builder(
              builder: (context) {
                List<Widget> items = [];
                for (int i = 0; i < countryList.length; i++) {
                  items.add(itemCountry(countryList[i], i));
                }

                return Column(
                  children: items,
                );
              },
            )
          ],
        ),
      ],
    );
  }

  Widget itemCountry(City country, int index) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            country.select = !country.select;
            String str = '';
            for (int i = 0; i < countryList.length; i++) {
              if (countryList[i].select && str.isEmpty) {
                str += countryList[i].name;
              } else if (countryList[i].select) {
                str += ', ${countryList[i].name}';
              }
            }
            allCountry = false;
            this.country = str;
            // if (groupValueCity) groupValueCity = index;
            setState(() {});
          },
          child: Container(
            color: Colors.transparent,
            height: 50.h,
            child: Column(
              children: [
                const Spacer(),
                Row(
                  children: [
                    Text(
                      country.name,
                      style: CustomTextStyle.black_14_w500_171716,
                    ),
                    const Spacer(),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height: 18.h,
                          width: 18.h,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xFFEAECEE),
                          ),
                        ),
                        Container(
                          height: 10.h,
                          width: 10.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: country.select
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                country.select
                    ? SizedBox(
                        height: 16.h,
                      )
                    : const Divider()
              ],
            ),
          ),
        ),
        // country.select
        //     ? country.name == 'Россия'
        //         ? listRegion(countryRussia)
        //         : listRegion(countryOAE)
        //     : const SizedBox(),
        country.select ? const Divider() : const SizedBox()
      ],
    );
  }

  Widget listRegion(List<City> region) {
    return ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.w),
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
          Row(
            children: [
              CustomIconButton(
                onBackPressed: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(OpenSlidingPanelToEvent(686.h));
                  typeFilter = TypeFilter.main;
                },
                icon: SvgImg.arrowRight,
              ),
              SizedBox(width: 12.h),
              Text(
                'Регионы',
                style: CustomTextStyle.black_22_w700,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ScaleButton(
            bound: 0.02,
            child: Container(
              height: 55.h,
              padding: EdgeInsets.only(left: 16.w, right: 16.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Text(
                    'Все регионы',
                    style: CustomTextStyle.black_14_w400_171716,
                  ),
                  const Spacer(),
                  Switch.adaptive(
                    activeColor: ColorStyles.yellowFFD70B,
                    value: allCountry,
                    onChanged: (value) {
                      allCountry = !allCountry;
                      String str = '';
                      for (var element in allRegoins) {
                        element.select = value;
                        str += '${element.name}, ';
                        if (element.select == true) {
                          isRegion.add(element.name);
                        }
                        if (element.select == false) {
                          isRegion.remove(element.name);
                        }
                        print(isRegion);
                      }
                      country = str;
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20.h),
          SizedBox(
            height: 700.h,
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: region.length,
                padding: EdgeInsets.only(left: 10.w),
                itemBuilder: ((context, index) {
                  return GestureDetector(
                    onTap: () {
                      String str1 = '';
                      region[index].select = !region[index].select;

                      if (region[index].select == true) {
                        isRegion.add(region[index].name);

                        str += '${region[index].name}, ';
                      }
                      if (region[index].select == false) {
                        isRegion.remove(region[index].name);
                        str1 = '${region[index].name}, ';
                      }

                      if (isRegion.isEmpty) {
                        print(1);
                        str = '';
                      }
                      country = str.replaceAll(str1, '');

                      setState(() {});
                    },
                    child: Container(
                      height: 40.h,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            region[index].name,
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          const Spacer(),
                          if (region[index].select) const Icon(Icons.check)
                        ],
                      ),
                    ),
                  );
                })),
          ),
        ]);
  }

  List<City> regionList = [];

  // Widget regionFilter() {
  //   regionList.clear();
  //   for (var element in countryList) {
  //     if (element.select && element.name == 'Россия') {
  //       regionList.addAll(countryRussia);
  //     } else if (element.select && element.name == 'ОАЭ') {
  //       regionList.addAll(countryOAE);
  //     }
  //   }
  //   return ListView(
  //     shrinkWrap: true,
  //     padding: EdgeInsets.symmetric(horizontal: 24.w),
  //     physics: const NeverScrollableScrollPhysics(),
  //     children: [
  //       SizedBox(height: 8.h),
  //       Stack(
  //         alignment: Alignment.center,
  //         children: [
  //           Container(
  //             height: 5.h,
  //             width: 81.w,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(25.r),
  //               color: ColorStyles.blueFC6554,
  //             ),
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 27.h),
  //       Row(
  //         children: [
  //           GestureDetector(
  //             onTap: () {
  //               BlocProvider.of<SearchBloc>(context)
  //                   .add(OpenSlidingPanelToEvent(686.h));
  //               typeFilter = TypeFilter.main;
  //             },
  //             child: Transform.rotate(
  //               angle: pi,
  //               child: SvgPicture.asset(
  //                 'assets/icons/arrow_right.svg',
  //                 height: 16.h,
  //                 width: 16.h,
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 12.h),
  //           Text(
  //             'Регионы',
  //             style: CustomTextStyle.black_20_w700,
  //           ),
  //         ],
  //       ),
  //       SizedBox(height: 20.h),
  //       ScaleButton(
  //         bound: 0.02,
  //         child: Container(
  //           height: 55.h,
  //           padding: EdgeInsets.only(left: 16.w, right: 16.w),
  //           decoration: BoxDecoration(
  //             color: Colors.grey[100],
  //             borderRadius: BorderRadius.circular(10.r),
  //           ),
  //           child: Row(
  //             children: [
  //               Text(
  //                 'Все регионы',
  //                 style: CustomTextStyle.black_12_w400_171716,
  //               ),
  //               const Spacer(),
  //               Switch.adaptive(
  //                 value: allCity,
  //                 onChanged: (value) {
  //                   allCity = !allCity;
  //                   for (var element in regionList) {
  //                     element.select = value;
  //                   }
  //                   setState(() {});
  //                 },
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //       SizedBox(height: 20.h),
  //       ListView(
  //         shrinkWrap: true,
  //         padding: EdgeInsets.only(bottom: 50.h),
  //         children: [
  //           Builder(
  //             builder: (context) {
  //               List<Widget> items = [];
  //               for (int i = 0; i < regionList.length; i++) {
  //                 items.add(itemRegion(regionList[i], i));
  //               }
  //               return Column(
  //                 children: items,
  //               );
  //             },
  //           )
  //         ],
  //       ),
  //     ],
  //   );
  // }

  // Widget itemRegion(City city, int index) {
  //   return GestureDetector(
  //     onTap: () {
  //       allCity = !allCity;

  //       city.select = !city.select;
  //       String str = '';
  //       for (int i = 0; i < regionList.length; i++) {
  //         if (regionList[i].select && str.isEmpty) {
  //           str += '${regionList[i].name}';
  //         } else if (regionList[i].select) str += ', ${regionList[i].name}';
  //       }
  //       allCity = false;
  //       this.region = str;
  //       setState(() {});
  //     },
  //     child: SizedBox(
  //       height: 50.h,
  //       child: Column(
  //         children: [
  //           const Spacer(),
  //           Row(
  //             children: [
  //               Text(
  //                 city.name,
  //                 style: CustomTextStyle.black_12_w500_171716,
  //               ),
  //               const Spacer(),
  //               Stack(
  //                 alignment: Alignment.center,
  //                 children: [
  //                   Container(
  //                     height: 18.h,
  //                     width: 18.h,
  //                     decoration: const BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: Color(0xFFEAECEE),
  //                     ),
  //                   ),
  //                   Container(
  //                     height: 10.h,
  //                     width: 10.h,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       color: city.select ? Colors.black : Colors.transparent,
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //           const Spacer(),
  //           const Divider()
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget dateFilter() {
    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
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
        Row(
          children: [
            CustomIconButton(
              onBackPressed: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              icon: SvgImg.arrowRight,
            ),
            SizedBox(width: 12.h),
            Text(
              'Даты начала и окончания',
              style: CustomTextStyle.black_22_w700,
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ScaleButton(
          bound: 0.02,
          onTap: () {
            _showDatePicker(context, 0);
          },
          child: Container(
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ColorStyles.greyF9F9F9,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дата начала',
                      style: CustomTextStyle.grey_14_w400,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      startDate != null
                          ? DateFormat('dd.MM.yyyy').format(startDate!)
                          : 'Выберите дату начала выполнения',
                      style: CustomTextStyle.black_14_w400_171716,
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(width: 16.h),
            SvgPicture.asset('assets/icons/line.svg'),
          ],
        ),
        ScaleButton(
          bound: 0.02,
          onTap: () {
            _showDatePicker(context, 1);
          },
          child: Container(
            height: 60.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: ColorStyles.greyF9F9F9,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Дата завершения',
                      style: CustomTextStyle.grey_14_w400,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      endDate != null
                          ? DateFormat('dd.MM.yyyy').format(endDate!)
                          : 'Выберите дату завершения задачи',
                      style: CustomTextStyle.black_14_w400_171716,
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDatePicker(ctx, int index) {
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
                                  if (index == 0 && startDate == null) {
                                    startDate = DateTime.now();
                                  } else if (index == 1 && endDate == null) {
                                    endDate = DateTime.now();
                                  }
                                  setState(() {});
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
                        initialDateTime: index == 0 ? startDate : endDate,
                        minimumDate:
                            index == 1 && startDate != null ? startDate : null,
                        maximumDate:
                            index == 0 && endDate != null ? endDate : null,
                        onDateTimeChanged: (val) {
                          if (index == 0) {
                            startDate = val;
                          } else if (index == 1) {
                            endDate = val;
                          }
                          setState(() {});
                        }),
                  ),
                ],
              ),
            ));
  }

  DateTime? startDate;
  DateTime? endDate;

  List<Category> category = [
    Category(icon: 'assets/images/package.png', title: 'Курьерские услуги'),
    Category(icon: 'assets/images/build.png', title: 'Ремонт и строительство'),
    Category(icon: 'assets/images/truck.png', title: 'Грузоперевозки'),
    Category(icon: 'assets/images/broom.png', title: 'Уборка помещений'),
    Category(icon: 'assets/images/laptop1.png', title: 'Компьютерная помощь'),
    Category(icon: 'assets/images/money_bag.png', title: 'Финансовый советник'),
    Category(
        icon: 'assets/images/party_popper.png',
        title: 'Мероприятия и промоакции'),
    Category(icon: 'assets/images/computer_disk.png', title: 'Разработка ПО'),
  ];

  List<City> countryList = [
    City('Россия'),
    City('ОАЭ'),
  ];

  List<City> allRegoins = [
    City('Краснодарский край'),
    City('Красноярский край'),
    City('Пермский край'),
    City('Белгородская область'),
    City('Курская область'),
    City('Московская область'),
    City('Смоленская область'),
    City('Дубай'),
    City('Абу-Даби'),
    // City('Абу-Даби'),
    City('Аджмана'),
    City('Фуджейры'),
    City('Рас-Эль-Хаймы'),
    City('Шарджи'),
  ];

  // List<City> countryOAE = [
  //   City('Дубай'),
  //   City('Абу-Даби'),
  //   // City('Абу-Даби'),
  //   City('Аджмана'),
  //   City('Фуджейры'),
  //   City('Рас-Эль-Хаймы'),
  //   City('Шарджи'),
  // ];

  List<CategorySelect> listCategory2 = [
    CategorySelect(
      title: 'Услуги пешего курьера',
      id: 1,
    ),
    CategorySelect(
      title: 'Услуги курьера на легковом авто',
      id: 2,
    ),
    CategorySelect(
      title: 'Купить и доставить',
      id: 3,
    ),
    CategorySelect(
      title: 'Срочная доставка',
      id: 4,
    ),
    CategorySelect(
      title: 'Доставка продуктов',
      id: 5,
    ),
    CategorySelect(
      title: 'Услуги пешего курьера',
      id: 6,
    ),
    CategorySelect(
      title: 'Курьер на день',
      id: 7,
    ),
  ];
}
