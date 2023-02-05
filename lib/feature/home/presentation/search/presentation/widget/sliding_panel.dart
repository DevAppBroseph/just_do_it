import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/radio.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/search_bloc.dart';
import 'package:just_do_it/models/category.dart';
import 'package:just_do_it/models/city.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelSearch extends StatefulWidget {
  PanelController panelController;

  SlidingPanelSearch(this.panelController);

  @override
  State<SlidingPanelSearch> createState() => _SlidingPanelSearchState();
}

class _SlidingPanelSearchState extends State<SlidingPanelSearch> {
  double heightPanel = 686.h;
  bool passportAndCV = false;
  bool allCategory = false;
  bool allCity = false;
  int groupValueCity = 0;

  bool slide = false;

  TypeFilter typeFilter = TypeFilter.main;

  TextEditingController coastMinController =
      TextEditingController(text: '1 000 ₽');
  TextEditingController coastMaxController =
      TextEditingController(text: '1 000 ₽');
  TextEditingController keyWordController =
      TextEditingController(text: 'Например, покупка апельсинов...');

  FocusNode focusCoastMin = FocusNode();
  FocusNode focusCoastMax = FocusNode();
  FocusNode focusCoastKeyWord = FocusNode();

  ScrollController mainScrollController = ScrollController();

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
        minHeight: 0,
        backdropEnabled: true,
        backdropColor: Colors.black,
        backdropOpacity: 0.8,
        defaultPanelState: PanelState.CLOSED,
      );
    });
  }

  Widget panel(BuildContext context) {
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
          child: Column(
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
                                ? const SizedBox()
                                : typeFilter == TypeFilter.region
                                    ? cityFilter()
                                    : typeFilter == TypeFilter.date
                                        ? dateFilter()
                                        : const SizedBox()
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(
                  onTap: () {
                    widget.panelController.animatePanelToPosition(0);
                  },
                  btnColor: ColorStyles.yellowFFD70A,
                  textLabel: Text(
                    'Показать задания',
                    style: CustomTextStyle.black_14_w600_171716,
                  ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget mainFilter() {
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
                    style: CustomTextStyle.black_20_w700,
                  ),
                  const Spacer(),
                  Text(
                    'Очистить',
                    style: CustomTextStyle.red_14_w400,
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
                            style: CustomTextStyle.grey_12_w400,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Все категории',
                            style: CustomTextStyle.black_12_w400_171716,
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
                  typeFilter = TypeFilter.region;
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
                            'По региону',
                            style: CustomTextStyle.grey_12_w400,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            'Все регионы',
                            style: CustomTextStyle.black_12_w400_171716,
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
                            style: CustomTextStyle.grey_12_w400,
                          ),
                          SizedBox(height: 3.h),
                          Text(
                            '21.12.22 - 22.12.22',
                            style: CustomTextStyle.black_12_w400_171716,
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
                              'Бюджет от',
                              style: CustomTextStyle.grey_12_w400,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomTextField(
                                  height: 20.h,
                                  width: 80.w,
                                  focusNode: focusCoastMin,
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
                                  hintText: '1 000 ₽',
                                  fillColor: ColorStyles.greyF9F9F9,
                                  maxLines: null,
                                  style: CustomTextStyle.black_12_w400_171716,
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
                              'Бюджет до',
                              style: CustomTextStyle.grey_12_w400,
                            ),
                            SizedBox(height: 3.h),
                            Row(
                              children: [
                                CustomTextField(
                                  height: 20.h,
                                  width: 80.w,
                                  focusNode: focusCoastMax,
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
                                  hintText: '1 000 ₽',
                                  fillColor: ColorStyles.greyF9F9F9,
                                  maxLines: null,
                                  style: CustomTextStyle.black_12_w400_171716,
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
                                      style: CustomTextStyle.grey_12_w400,
                                    ),
                                    Row(
                                      children: [
                                        CustomTextField(
                                          height: 60.h,
                                          width: 250.w,
                                          focusNode: focusCoastKeyWord,
                                          onTap: () {
                                            slide = true;
                                            mainScrollController.animateTo(
                                                heightPanel,
                                                duration:
                                                    const Duration(seconds: 1),
                                                curve: Curves.linear);
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
                                          maxLines: null,
                                          style: CustomTextStyle
                                              .black_12_w400_171716,
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
                  Text(
                    'Паспортные данные загружены и есть резюме',
                    style: CustomTextStyle.black_12_w400_171716,
                  ),
                  const Spacer(),
                  Switch.adaptive(
                    value: passportAndCV,
                    onChanged: (value) {
                      passportAndCV = !passportAndCV;
                      setState(() {});
                    },
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
            GestureDetector(
              onTap: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              child: Transform.rotate(
                angle: pi,
                child: SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  height: 16.h,
                  width: 16.h,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Text(
              'Категории',
              style: CustomTextStyle.black_20_w700,
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
                  style: CustomTextStyle.black_12_w400_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  value: allCategory,
                  onChanged: (value) {
                    allCategory = !allCategory;
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20.h),
        Column(
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(bottom: 50.h),
              children: category.map((e) => itemCategory(e)).toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget itemCategory(Category category) {
    return SizedBox(
      height: 50.h,
      child: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              Image.asset(
                category.icon,
                height: 24.h,
              ),
              SizedBox(width: 12.w),
              Text(
                category.title,
                style: CustomTextStyle.black_12_w500_171716,
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_ios,
                size: 16.h,
                color: const Color(0xFFBDBDBD),
              )
            ],
          ),
          const Spacer(),
          const Divider()
        ],
      ),
    );
  }

  Widget cityFilter() {
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
            GestureDetector(
              onTap: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              child: Transform.rotate(
                angle: pi,
                child: SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  height: 16.h,
                  width: 16.h,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Text(
              'Регионы',
              style: CustomTextStyle.black_20_w700,
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
                  style: CustomTextStyle.black_12_w400_171716,
                ),
                const Spacer(),
                Switch.adaptive(
                  value: allCity,
                  onChanged: (value) {
                    allCity = !allCity;
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
          padding: EdgeInsets.only(bottom: 50.h),
          children: [
            Builder(
              builder: (context) {
                List<Widget> items = [];
                for (int i = 0; i < city.length; i++) {
                  items.add(itemCity(city[i], i));
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

  Widget itemCity(City city, int index) {
    return GestureDetector(
      onTap: () {
        groupValueCity = index;
        setState(() {});
      },
      child: SizedBox(
        height: 50.h,
        child: Column(
          children: [
            const Spacer(),
            Row(
              children: [
                Text(
                  city.name,
                  style: CustomTextStyle.black_12_w500_171716,
                ),
                const Spacer(),
                CustomCircleRadioButtonItem(
                  label: '',
                  value: index,
                  groupValue: groupValueCity,
                )
              ],
            ),
            const Spacer(),
            const Divider()
          ],
        ),
      ),
    );
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
            GestureDetector(
              onTap: () {
                BlocProvider.of<SearchBloc>(context)
                    .add(OpenSlidingPanelToEvent(686.h));
                typeFilter = TypeFilter.main;
              },
              child: Transform.rotate(
                angle: pi,
                child: SvgPicture.asset(
                  'assets/icons/arrow_right.svg',
                  height: 16.h,
                  width: 16.h,
                ),
              ),
            ),
            SizedBox(width: 12.h),
            Text(
              'Даты начала и окончания',
              style: CustomTextStyle.black_20_w700,
            ),
          ],
        ),
        SizedBox(height: 20.h),
        ScaleButton(
          bound: 0.02,
          child: Container(
            height: 55.h,
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
                      style: CustomTextStyle.grey_12_w400,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Выберите дату начала выполнения',
                      style: CustomTextStyle.black_12_w400_171716,
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
          child: Container(
            height: 55.h,
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
                      style: CustomTextStyle.grey_12_w400,
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'Выберите дату завершения задачи',
                      style: CustomTextStyle.black_12_w400_171716,
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

  List<City> city = [
    City('Московская область'),
    City('Краснодарский край'),
    City('Красноярский край'),
    City('Иркутская область'),
    City('Московская область'),
    City('Краснодарский край'),
    City('Красноярский край'),
    City('Иркутская область'),
    City('Московская область'),
    City('Краснодарский край'),
    City('Красноярский край'),
    City('Иркутская область'),
    City('Московская область'),
    City('Краснодарский край'),
    City('Красноярский край'),
    City('Иркутская область'),
  ];
}
