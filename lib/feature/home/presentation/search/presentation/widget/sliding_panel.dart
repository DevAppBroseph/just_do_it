import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/currency_bloc/currency_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/models/category_select.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
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
  bool allCountrys = false;
  bool allRegions = false;
  bool allTowns = false;
  int groupValueCity = 0;
  String str = '';
  String str2 = '';
  String strcat = '';
  String strcat2 = '';
  String strcat3 = '';
  int? groupValueCountry;
  Activities? selectActivities;
  Currency? selectCurrency;
  List<int> selectSubCategory = [];
  List<Countries> selectCountry = [];
  List<Regions> selectRegions = [];
  List<Town> selectTowns = [];
  List<Activities> activities = [];
  List<Countries> countries = [];
  List<Regions> regions = [];
  List<Town> towns = [];
  Activities? selectCategory;
  int? currencySelect;
  bool slide = false;

  TypeFilter typeFilter = TypeFilter.main;

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();

  String? countryString;
  String? currencyString;
  String? category;
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
        widget.panelController.animatePanelToPosition(1);
        return true;
      } else {
        heightPanel = 686.h;
      }
      return true;
    }, builder: (context, snapshot) {
      return BlocBuilder<CountriesBloc, CountriesState>(
          builder: (context, state) {
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
                                    ? categorySecond(selectActivities)
                                    : typeFilter == TypeFilter.date
                                        ? dateFilter()
                                        : typeFilter == TypeFilter.country
                                            ? countryFilter()
                                            : typeFilter == TypeFilter.region
                                                ? listRegion()
                                                : typeFilter == TypeFilter.towns
                                                    ? listTowns()
                                                    : typeFilter ==
                                                            TypeFilter.currency
                                                        ? currency()
                                                        : SizedBox(),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: CustomButton(
                      onTap: () {
                        int countField = 0;
                        widget.panelController.animatePanelToPosition(0);
                        if (coastMinController.text != '') {
                          countField++;
                        }
                        if (coastMaxController.text != '') {
                          countField++;
                        }

                        var format1 = endDate == null
                            ? null
                            : "${endDate?.year}-${endDate?.month}-${endDate?.day}";
                        var format2 = startDate == null
                            ? null
                            : "${startDate?.year}-${startDate?.month}-${startDate?.day}";

                        if (keyWordController.text != '') {
                          countField++;
                        }
                        if (selectSubCategory.isNotEmpty) {
                          countField++;
                        }
                        if (format1 != null || format2 != null) {
                          countField++;
                        }
                        if (countries.isNotEmpty ||
                            regions.isNotEmpty ||
                            towns.isNotEmpty) {
                          countField++;
                        }

                        if (currencyString != null &&
                            currencyString!.isNotEmpty) {
                          countField++;
                        }

                        context.read<TasksBloc>().add(
                              GetTasksEvent(
                                access: access,
                                query: keyWordController.text,
                                dateEnd: format1,
                                dateStart: format2,
                                priceFrom:
                                    int.tryParse(coastMinController.text),
                                priceTo: int.tryParse(coastMaxController.text),
                                isSelectCountry: selectCountry,
                                isSelectRegions: selectRegions,
                                isSelectTown: selectTowns,
                                subcategory: selectSubCategory,
                                countFilter: countField,
                                currency: selectCurrency?.id,
                                customer: (contractorFlag && contractorFlag) ||
                                        (contractorFlag && contractorFlag)
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
                  BlocBuilder<CountriesBloc, CountriesState>(
                      builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        selectCountry = [];
                        selectRegions = [];
                        selectTowns = [];
                        currencyString = '';
                        endDate = null;
                        startDate = null;
                        date = '';
                        category = '';
                        coastMinController.text = '';
                        coastMaxController.text = '';
                        keyWordController.text = '';
                        selectSubCategory = [];
                        countryString = '';
                        passportAndCV = false;
                        strcat2 = '';
                        strcat = '';
                        allCategory = false;
                        for (int i = 0; i < activities.length; i++) {
                          for (int y = 0;
                              y < activities[i].subcategory.length;
                              y++) {
                            activities[i].subcategory[y].isSelect = false;
                            selectSubCategory = [];
                          }
                          activities[i].isSelect = false;
                        }

                        setState(() {});
                      },
                      child: Text(
                        'Очистить',
                        style: CustomTextStyle.red_16_w400,
                      ),
                    );
                  }),
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
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              category != null && category!.isNotEmpty
                                  ? category!
                                  : 'Все категории',
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
                            'Страны',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          SizedBox(
                            width: 200.w,
                            child: BlocBuilder<CountriesBloc, CountriesState>(
                                builder: (context, state) {
                              str = '';
                              if (selectCountry.isNotEmpty) {
                                for (int i = 0; i < selectCountry.length; i++) {
                                  if (i == selectCountry.length - 1) {
                                    str += '${selectCountry[i].name}';
                                  } else {
                                    str += '${selectCountry[i].name}, ';
                                  }
                                }
                              }
                              countryString = str;
                              if (selectCountry.length == 1) {
                                countryString =
                                    countryString?.replaceAll(',', '');
                              }
                              return Text(
                                countryString != null &&
                                        countryString!.isNotEmpty
                                    ? countryString!
                                    : 'Страны не выбраны',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: CustomTextStyle.black_14_w400_171716,
                              );
                            }),
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
              ScaleButton(
                bound: 0.02,
                onTap: () {
                  BlocProvider.of<SearchBloc>(context)
                      .add(OpenSlidingPanelToEvent(686.h));
                  typeFilter = TypeFilter.currency;
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
                      SvgPicture.asset('assets/icons/wallet-money.svg'),
                      SizedBox(width: 10.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Валюта',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                          SizedBox(height: 3.h),
                          SizedBox(
                            width: 200.w,
                            child: Text(
                              currencyString != null &&
                                      currencyString!.isNotEmpty
                                  ? currencyString!
                                  : 'Валюта не выбрана',
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
                            if (currencyString == '' || currencyString == null)
                              Text(
                                'Бюджет от ₽',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Российский рубль')
                              Text(
                                'Бюджет от ₽',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Доллар США')
                              Text(
                                'Бюджет от \$',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Евро')
                              Text(
                                'Бюджет от €',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Дирхам')
                              Text(
                                'Бюджет от AED',
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
                            if (currencyString == '' || currencyString == null)
                              Text(
                                'Бюджет до ₽',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Российский рубль')
                              Text(
                                'Бюджет до ₽',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Доллар США')
                              Text(
                                'Бюджет до \$',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Евро')
                              Text(
                                'Бюджет до €',
                                style: CustomTextStyle.grey_14_w400,
                              ),
                            if (currencyString == 'Дирхам')
                              Text(
                                'Бюджет до AED',
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

  Widget currency() {
    return BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
      if (state is CurrencyLoaded) {
        final currencies = state.currency;
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
                  'Валюта',
                  style: CustomTextStyle.black_22_w700,
                ),
              ],
            ),
            SizedBox(height: 20.h),
            SizedBox(
              height: 440.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  physics: const ClampingScrollPhysics(),
                  itemCount: currencies!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        elementCurrency(
                          currencies[index],
                        ),
                      ],
                    );
                  }),
            ),
          ],
        );
      }
      return Container();
    });
  }

  Widget elementCurrency(Currency currency) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (currency.id == selectCurrency?.id) {
              currencyString = null;
              selectCurrency = null;
            } else {
              currencyString = currency.name;
              selectCurrency = currency;
            }

            BlocProvider.of<SearchBloc>(context)
                .add(OpenSlidingPanelToEvent(686.h));
            typeFilter = TypeFilter.main;
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
                      currency.name!,
                      style: CustomTextStyle.black_14_w500_171716,
                    ),
                    const Spacer(),
                    if (currency.id == selectCurrency?.id) Icon(Icons.check),
                  ],
                ),
                const Spacer(),
                currency.isSelect
                    ? SizedBox(
                        height: 16.h,
                      )
                    : const Divider()
              ],
            ),
          ),
        ),
      ],
    );
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
                          strcat +=
                              '${activities[i].subcategory[y].description!}, ';
                        }
                        activities[i].isSelect = true;
                      }
                      category = strcat;
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
                      category = '';
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

  Widget categorySecond(Activities? selectActivity) {
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
                    strcat = '';
                    selectActivity?.isSelect = !selectActivity.isSelect;
                    for (var element in selectActivity!.subcategory) {
                      element.isSelect = value;
                      strcat += '${element.description}, ';
                      if (element.isSelect == true) {
                        selectSubCategory.add(element.id);
                      }
                      if (element.isSelect == false) {
                        selectSubCategory.remove(element.id);
                        strcat = '';
                      }
                      category = strcat;
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
        strcat2 = '';
        selectActivities!.subcategory[index].isSelect =
            !selectActivities!.subcategory[index].isSelect;
        setState(() {});
        if (selectActivities!.subcategory[index].isSelect == true) {
          selectSubCategory.add(selectActivities!.subcategory[index].id);
          strcat += '${selectActivities!.subcategory[index].description!}, ';
        }
        if (selectActivities!.subcategory[index].isSelect == false) {
          selectSubCategory.remove(selectActivities!.subcategory[index].id);
          allCategory = false;
          strcat2 = '${selectActivities!.subcategory[index].description!}, ';
        }
        if (selectSubCategory.isEmpty) {
          strcat = '';
          strcat2 = '';
        }

        strcat3 = strcat.replaceAll(strcat2, '');
        strcat = strcat3;
        category = strcat3;

        if (selectSubCategory.length == 1) {
          category = category?.replaceAll(',', '');
        }
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
      onTap: () {},
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
            const Divider()
          ],
        ),
      ),
    );
  }

  Widget countryFilter() {
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
      final allCountryList = BlocProvider.of<CountriesBloc>(context).country;

      if (selectCountry.isEmpty) {
        allCountrys = false;
      } else {
        allCountrys = allCountryList.length == selectCountry.length;
      }

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
                    value: allCountrys,
                    onChanged: (value) {
                      allCountrys = !allCountrys;

                      if (allCountrys) {
                        selectCountry.clear();
                        selectCountry.addAll(allCountryList);
                        final access =
                            BlocProvider.of<ProfileBloc>(context).access;
                        BlocProvider.of<CountriesBloc>(context)
                            .add(GetRegionEvent(access, selectCountry));
                        typeFilter = TypeFilter.region;
                      } else {
                        selectCountry.clear();
                      }
                      selectRegions.clear();
                      selectTowns.clear();
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

                  for (int i = 0; i < allCountryList.length; i++) {
                    items.add(itemCountry(allCountryList[i], selectCountry));
                  }
                  return Column(children: items);
                },
              )
            ],
          ),
        ],
      );
    });
  }

  Widget itemCountry(Countries countrySecond, List<Countries> countrySelect) {
    final isSelectedCountry =
        countrySelect.any((element) => countrySecond == element);
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            final access = BlocProvider.of<ProfileBloc>(context).access;
            if (selectCountry.contains(countrySecond)) {
              selectCountry.remove(countrySecond);
            } else {
              selectCountry.add(countrySecond);
              BlocProvider.of<SearchBloc>(context)
                  .add(OpenSlidingPanelToEvent(686.h));
              typeFilter = TypeFilter.region;
            }
            BlocProvider.of<CountriesBloc>(context)
                .add(GetRegionEvent(access, selectCountry));
            selectRegions.clear();
            selectTowns.clear();
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
                      countrySecond.name!,
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
                            color: isSelectedCountry
                                ? Colors.black
                                : Colors.transparent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),
                isSelectedCountry
                    ? SizedBox(
                        height: 16.h,
                      )
                    : const Divider()
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget listRegion() {
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
      final regionSelect = BlocProvider.of<CountriesBloc>(context).region;

      if (regionSelect.isEmpty) {
        allRegions = false;
      } else {
        allRegions = regionSelect.length == selectRegions.length;
      }

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
                    typeFilter = TypeFilter.country;
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
                      value: allRegions,
                      onChanged: (value) {
                        allRegions = !allRegions;
                        final access =
                            BlocProvider.of<ProfileBloc>(context).access;
                        if (allRegions) {
                          selectRegions.clear();
                          selectRegions.addAll(regionSelect);
                          typeFilter = TypeFilter.towns;
                          BlocProvider.of<CountriesBloc>(context)
                              .add(GetTownsEvent(access, selectRegions));
                        } else {
                          selectRegions.clear();
                        }
                        selectTowns.clear();
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
                itemCount: regionSelect.length,
                padding: EdgeInsets.only(left: 10.w),
                itemBuilder: ((context, index) {
                  final isSelectedRegion = selectRegions
                      .any((element) => regionSelect[index].id == element.id);
                  return GestureDetector(
                    onTap: () {
                      final access =
                          BlocProvider.of<ProfileBloc>(context).access;

                      if (selectRegions.contains(regionSelect[index])) {
                        selectRegions.remove(regionSelect[index]);
                      } else {
                        selectRegions.add(regionSelect[index]);
                        BlocProvider.of<SearchBloc>(context)
                            .add(OpenSlidingPanelToEvent(686.h));
                        typeFilter = TypeFilter.towns;
                      }
                      BlocProvider.of<CountriesBloc>(context)
                          .add(GetTownsEvent(access, selectRegions));
                      selectTowns.clear();
                      setState(() {});
                    },
                    child: Container(
                      height: 40.h,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            regionSelect[index].name!,
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              setState(() {});
                            },
                            child: Stack(
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
                                    color: isSelectedRegion
                                        ? Colors.black
                                        : Colors.transparent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ]);
    });
  }

  Widget listTowns() {
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
      final townSelect = BlocProvider.of<CountriesBloc>(context).town;

      if (townSelect.isEmpty) {
        allTowns = false;
      } else {
        allTowns = townSelect.length == selectTowns.length;
      }

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
                    typeFilter = TypeFilter.region;
                  },
                  icon: SvgImg.arrowRight,
                ),
                SizedBox(width: 12.h),
                Text(
                  'Районы',
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
                      'Все районы',
                      style: CustomTextStyle.black_14_w400_171716,
                    ),
                    const Spacer(),
                    Switch.adaptive(
                      activeColor: ColorStyles.yellowFFD70B,
                      value: allTowns,
                      onChanged: (value) {
                        allTowns = !allTowns;

                        if (allTowns) {
                          selectTowns.clear();
                          selectTowns.addAll(townSelect);
                        } else {
                          selectTowns.clear();
                        }
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
                itemCount: townSelect.length,
                padding: EdgeInsets.only(left: 10.w),
                itemBuilder: ((context, index) {
                  final isSelectedTown = selectTowns
                      .any((element) => townSelect[index].id == element.id);
                  return GestureDetector(
                    onTap: () {
                      if (selectTowns.contains(townSelect[index])) {
                        selectTowns.remove(townSelect[index]);
                      } else {
                        selectTowns.add(townSelect[index]);
                      }

                      setState(() {});
                    },
                    child: Container(
                      height: 40.h,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          Text(
                            townSelect[index].name!,
                            style: CustomTextStyle.black_14_w500_171716,
                          ),
                          const Spacer(),
                          if (isSelectedTown) const Icon(Icons.check)
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ]);
    });
  }

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
}
