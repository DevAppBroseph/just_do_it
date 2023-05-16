import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/currency_bloc/currency_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';

class DatePicker extends StatefulWidget {
  double bottomInsets;
  TextEditingController coastMinController;
  TextEditingController coastMaxController;
  Function(DateTime?, DateTime?, List<Countries>, Currency?) onEdit;
  DateTime? startDate;
  DateTime? endDate;
  List<Countries> allCountries;
  Currency? currecy;
  DatePicker({
    super.key,
    required this.onEdit,
    required this.bottomInsets,
    required this.coastMinController,
    required this.coastMaxController,
    required this.startDate,
    required this.endDate,
    required this.allCountries,
    required this.currecy,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool openCountry = false;
  bool openCurrency = false;
  bool openRegion = false;
  bool openTown = false;
  ScrollController controller = ScrollController();
  ScrollController countyController = ScrollController();
  ScrollController regionController = ScrollController();
  ScrollController townController = ScrollController();
  ScrollController currecyController = ScrollController();

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
                            style: CustomTextStyle.black_15,
                          ),
                          onPressed: () {
                            if (index == 0 && widget.startDate == null) {
                              widget.startDate = DateTime.now();
                            } else if (index == 1 && widget.endDate == null) {
                              widget.endDate = DateTime.now();
                            }
                            setState(() {});
                            Navigator.of(ctx).pop();
                            widget.onEdit(
                              widget.startDate,
                              widget.endDate,
                              widget.allCountries,
                              widget.currecy,
                            );
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
                  initialDateTime: index == 0
                      ? widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          )
                      : widget.endDate ??
                          widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                  minimumDate: index == 0
                      ? DateTime(
                          DateTime.now().year,
                          DateTime.now().month,
                          DateTime.now().day,
                        )
                      : widget.startDate ??
                          DateTime(
                            DateTime.now().year,
                            DateTime.now().month,
                            DateTime.now().day,
                          ),
                  maximumDate: index == 0
                      ? widget.endDate ??
                          DateTime(
                            DateTime.now().year + 5,
                            DateTime.now().month,
                            DateTime.now().day,
                          )
                      : null,
                  onDateTimeChanged: (val) {
                    if (index == 0) {
                      widget.startDate = val;
                    } else if (index == 1) {
                      widget.endDate = val;
                    }
                    widget.onEdit(
                      widget.startDate,
                      widget.endDate,
                      widget.allCountries,
                      widget.currecy,
                    );
                    setState(() {});
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int countCountry = widget.allCountries.length;

    int countRegion = 0;
    for (int i = 0; i < widget.allCountries.length; i++) {
      if (widget.allCountries[i].select) {
        for (int j = 0; j < widget.allCountries[i].region.length; j++) {
          countRegion += widget.allCountries[i].region.length;
        }
      }
    }

    int countTown = 0;
    for (int i = 0; i < widget.allCountries.length; i++) {
      if (widget.allCountries[i].select) {
        for (int j = 0; j < widget.allCountries[i].region.length; j++) {
          if (widget.allCountries[i].region[j].select) {
            {
              countTown += widget.allCountries[i].region[j].town.length;
            }
          }
        }
      }
    }

    List<Widget> regionsListWidget = [];
    if (openRegion) {
      for (int i = 0; i < widget.allCountries.length; i++) {
        if (widget.allCountries[i].select) {
          for (int index = 0; index < widget.allCountries[i].region.length; index++) {
            regionsListWidget.add(
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: GestureDetector(
                  onTap: () async {
                    widget.allCountries[i].region[index].select = !widget.allCountries[i].region[index].select;
                    if (widget.allCountries[i].region[index].select) {
                      if (widget.allCountries[i].region[index].town.isEmpty) {
                        widget.allCountries[i].region[index].town =
                            await Repository().towns(widget.allCountries[i].region[index]);
                      }
                    } else {
                      widget.allCountries[i].region[index].select = false;
                      for (var element1 in widget.allCountries[i].region) {
                        if (!element1.select) {
                          for (var element2 in element1.town) {
                            element2.select = false;
                          }
                        }
                      }
                    }
                    openCountry = false;
                    openTown = false;
                    widget.onEdit(
                      widget.startDate,
                      widget.endDate,
                      widget.allCountries,
                      widget.currecy,
                    );

                    setState(() {});
                  },
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
                                widget.allCountries[i].region[index].name!,
                                style: CustomTextStyle.black_14_w400_515150,
                              ),
                            ),
                            const Spacer(),
                            if (widget.allCountries[i].region[index].select) const Icon(Icons.check)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        }
      }
    }

    // widget.allCountries[index1].region[index2].town.length,

    List<Widget> townsListWidget = [];
    if (openTown) {
      for (int i = 0; i < widget.allCountries.length; i++) {
        if (widget.allCountries[i].select) {
          for (int index = 0; index < widget.allCountries[i].region.length; index++) {
            if (widget.allCountries[i].region[index].select) {
              for (int index3 = 0; index3 < widget.allCountries[i].region.length; index3++) {
                if (widget.allCountries[i].region[index].town.isNotEmpty) {
                  townsListWidget.add(
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: GestureDetector(
                        onTap: () {
                          widget.allCountries[i].region[index].town[index3].select =
                              !widget.allCountries[i].region[index].town[index3].select;

                          widget.onEdit(
                            widget.startDate,
                            widget.endDate,
                            widget.allCountries,
                            widget.currecy,
                          );

                          setState(() {});
                        },
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
                                      widget.allCountries[i].region[index].town[index3].name!,
                                      style: CustomTextStyle.black_14_w400_515150,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (widget.allCountries[i].region[index].town[index3].select) const Icon(Icons.check)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
            }
          }
        }
      }
    }

    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        controller: controller,
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: [
          ScaleButton(
            bound: 0.02,
            onTap: () {
              openCountry = false;
              openTown = false;
              openRegion = false;
              openCurrency = false;
              _showDatePicker(context, 0);
            },
            child: Container(
              height: 68.h,
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
                      SizedBox(height: 0.h),
                      if (widget.startDate != null)
                        Text(
                          DateFormat('dd.MM.yyyy').format(widget.startDate!),
                          style: CustomTextStyle.black_14_w400_171716,
                        ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/calendar.svg')
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
              openCountry = false;
              openTown = false;
              openRegion = false;
              openCurrency = false;
              _showDatePicker(context, 1);
            },
            child: Container(
              height: 68.h,
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
                      SizedBox(height: 0.h),
                      if (widget.endDate != null)
                        Text(
                          DateFormat('dd.MM.yyyy').format(widget.endDate!),
                          style: CustomTextStyle.black_14_w400_171716,
                        ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset('assets/icons/calendar.svg')
                ],
              ),
            ),
          ),
          SizedBox(height: 18.h),
          ScaleButton(
            bound: 0.02,
            onTap: () {
              setState(() {
                openCurrency = !openCurrency;
                openRegion = false;
                openTown = false;
                openCountry = false;
              });
              FocusScope.of(context).unfocus();

              Future.delayed(const Duration(milliseconds: 300), () {
                controller.animateTo(
                  controller.position.maxScrollExtent - 20.h,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear,
                );
              });
            },
            child: CustomTextField(
              style: CustomTextStyle.black_14_w400_171716,
              fillColor: ColorStyles.greyF9F9F9,
              hintText: 'Валюта для оплаты заказа',
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 55.h,
              enabled: false,
              suffixIcon: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [SvgPicture.asset(SvgImg.arrowRight)],
                    ),
                  ),
                ],
              ),
              textEditingController: TextEditingController(text: widget.currecy?.name),
              contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            ),
          ),
          SizedBox(height: 14.h),
          BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
            if (state is CurrencyLoaded) {
              final currecy = state.currency;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: openCurrency ? 160.h : 0.h,
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
                padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
                child: Scrollbar(
                  controller: currecyController,
                  trackVisibility: currecy!.length > 5,
                  child: ListView(
                    shrinkWrap: true,
                    controller: currecyController,
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: currecy
                        .map(
                          (e) => Padding(
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            child: GestureDetector(
                              onTap: () {
                                if (e.id == widget.currecy?.id) {
                                  widget.currecy = null;
                                } else {
                                  widget.currecy = e;
                                }

                                widget.onEdit(
                                  widget.startDate,
                                  widget.endDate,
                                  widget.allCountries,
                                  widget.currecy,
                                );

                                setState(() {});
                              },
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
                                            e.name!,
                                            style: CustomTextStyle.black_14_w400_515150,
                                          ),
                                        ),
                                        const Spacer(),
                                        if (widget.currecy?.id == e.id) const Icon(Icons.check)
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              );
            }
            return Container();
          }),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: ScaleButton(
                  bound: 0.02,
                  onTap: () {
                    openCountry = false;
                    openTown = false;
                    openRegion = false;
                    openCurrency = false;
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
                        if (widget.currecy?.name == null)
                          Text(
                            'Бюджет от ',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Российский рубль')
                          Text(
                            'Бюджет от ₽',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Доллар США')
                          Text(
                            'Бюджет от \$',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Евро')
                          Text(
                            'Бюджет от €',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Дирхам')
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
                              actionButton: false,
                              onTap: () {
                                openCurrency = false;
                                setState(() {});
                              },
                              onChanged: (value) {
                                widget.onEdit(
                                  widget.startDate,
                                  widget.endDate,
                                  widget.allCountries,
                                  widget.currecy,
                                );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {});
                              },
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                              fillColor: ColorStyles.greyF9F9F9,
                              maxLines: null,
                              style: CustomTextStyle.black_14_w400_171716,
                              textEditingController: widget.coastMinController,
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
                    openCountry = false;
                    openTown = false;
                    openRegion = false;
                    openCurrency = false;
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
                        if (widget.currecy?.name == null)
                          Text(
                            'Бюджет до ',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Российский рубль')
                          Text(
                            'Бюджет до ₽',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Доллар США')
                          Text(
                            'Бюджет до \$',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Евро')
                          Text(
                            'Бюджет до €',
                            style: CustomTextStyle.grey_14_w400,
                          ),
                        if (widget.currecy?.name == 'Дирхам')
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
                              actionButton: false,
                              textInputType: TextInputType.number,
                              onTap: () {
                                openCurrency = false;
                                setState(() {});
                              },
                              onChanged: (value) {
                                widget.onEdit(
                                  widget.startDate,
                                  widget.endDate,
                                  widget.allCountries,
                                  widget.currecy,
                                );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {});
                              },
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                              fillColor: ColorStyles.greyF9F9F9,
                              maxLines: null,
                              style: CustomTextStyle.black_14_w400_171716,
                              textEditingController: widget.coastMaxController,
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
          SizedBox(height: 18.h),
          ScaleButton(
            bound: 0.02,
            onTap: () {
              setState(() {
                openCountry = !openCountry;
                openRegion = false;
                openTown = false;
                openCurrency = false;
              });
              FocusScope.of(context).unfocus();

              Future.delayed(const Duration(milliseconds: 300), () {
                controller.animateTo(
                  controller.position.maxScrollExtent - 20.h,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.linear,
                );
              });
            },
            child: CustomTextField(
              style: CustomTextStyle.black_14_w400_171716,
              fillColor: ColorStyles.greyF9F9F9,
              hintText: 'Выбрать страну',
              hintStyle: CustomTextStyle.grey_14_w400,
              height: 55.h,
              enabled: false,
              suffixIcon: Stack(
                alignment: Alignment.centerRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          SvgImg.earth,
                          height: 15.h,
                          width: 15.h,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              textEditingController: TextEditingController(text: _countriesString()),
              contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            ),
          ),
          SizedBox(height: 14.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: openCountry
                ? countCountry < 3
                    ? countCountry * 40
                    : 170.h
                : 0.h,
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
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: Scrollbar(
              thumbVisibility: true,
              controller: countyController,
              child: ListView(
                shrinkWrap: true,
                controller: countyController,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: widget.allCountries.map(
                  (e) {
                    bool select = false;
                    for (var element in widget.allCountries) {
                      if (element.select && e.id == element.id) {
                        select = true;
                        break;
                      }
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: GestureDetector(
                        onTap: () async {
                          e.select = !e.select;
                          if (e.select) {
                            if (e.region.isEmpty) {
                              e.region = await Repository().regions(e);
                            }
                          } else {
                            for (var element2 in e.region) {
                              element2.select = false;
                              for (var element3 in element2.town) {
                                element3.select = false;
                              }
                            }
                          }

                          openRegion = false;
                          openTown = false;
                          widget.onEdit(
                            widget.startDate,
                            widget.endDate,
                            widget.allCountries,
                            widget.currecy,
                          );
                        },
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
                                      e.name!,
                                      style: CustomTextStyle.black_14_w400_515150,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (select) const Icon(Icons.check)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ),
          SizedBox(height: 14.h),
          widget.allCountries.any((element) => element.select)
              ? ScaleButton(
                  bound: 0.02,
                  onTap: () {
                    setState(() {
                      openCountry = false;
                      openTown = false;
                      openRegion = !openRegion;
                      openCurrency = false;
                    });
                    FocusScope.of(context).unfocus();

                    Future.delayed(const Duration(milliseconds: 300), () {
                      controller.animateTo(
                        controller.position.maxScrollExtent - 20.h,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear,
                      );
                    });
                  },
                  child: CustomTextField(
                    style: CustomTextStyle.black_14_w400_171716,
                    fillColor: ColorStyles.greyF9F9F9,
                    hintText: 'Выбрать регион',
                    hintStyle: CustomTextStyle.grey_14_w400,
                    height: 55.h,
                    enabled: false,
                    suffixIcon: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                SvgImg.earth,
                                height: 15.h,
                                width: 15.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    textEditingController: TextEditingController(text: _regionsString()),
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                  ),
                )
              : Container(),
          SizedBox(height: 14.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: openRegion
                ? countRegion < 3
                    ? countRegion * 40.h
                    : 170.h
                : 0.h,
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
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: Scrollbar(
              thumbVisibility: true,
              controller: regionController,
              child: ListView(
                shrinkWrap: true,
                controller: regionController,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: regionsListWidget,
              ),
            ),
          ),
          SizedBox(height: 14.h),
          widget.allCountries.any(
            (element) {
              if (element.select) {
                return element.region.any((element1) {
                  if (element1.select) {
                    return element1.town.isNotEmpty;
                  }
                  return false;
                });
              } else {
                return false;
              }
            },
          )
              ? ScaleButton(
                  bound: 0.02,
                  onTap: () {
                    setState(() {
                      setState(() {
                        openCountry = false;
                        openRegion = false;
                        openTown = !openTown;
                        openCurrency = false;
                      });
                      FocusScope.of(context).unfocus();

                      Future.delayed(const Duration(milliseconds: 300), () {
                        controller.animateTo(
                          controller.position.maxScrollExtent - 20.h,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.linear,
                        );
                      });
                    });
                  },
                  child: CustomTextField(
                    style: CustomTextStyle.black_14_w400_171716,
                    fillColor: ColorStyles.greyF9F9F9,
                    hintText: 'Выбрать район',
                    hintStyle: CustomTextStyle.grey_14_w400,
                    height: 55.h,
                    enabled: false,
                    suffixIcon: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 16.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              SvgPicture.asset(
                                SvgImg.earth,
                                height: 15.h,
                                width: 15.h,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    textEditingController: TextEditingController(text: _townsString()),
                    contentPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                  ),
                )
              : Container(),
          SizedBox(height: 14.h),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: openTown
                ? countTown < 3
                    ? countTown * 40.h
                    : 170.h
                : 0.h,
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
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
            child: Scrollbar(
              thumbVisibility: true,
              controller: townController,
              child: ListView(
                controller: townController,
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: townsListWidget,
              ),
            ),
          ),
          Row(
            children: [
              const Spacer(),
              SvgPicture.asset(SvgImg.help),
            ],
          ),
          SizedBox(height: 8.h),
          CustomButton(
            onTap: () {},
            btnColor: ColorStyles.purpleA401C4,
            textLabel: Text(
              'Поднять объявление наверх',
              style: CustomTextStyle.white_14,
            ),
          ),
          SizedBox(height: widget.bottomInsets),
        ],
      ),
    );
  }

  String _countriesString() {
    List<String> nameCountriesList = [];
    String nameCountries = '';
    int selectCount = 0;
    for (int i = 0; i < widget.allCountries.length; i++) {
      if (widget.allCountries[i].select) {
        selectCount += 1;
        nameCountriesList.add('${widget.allCountries[i].name}');
      }
    }

    for (int i = 0; i < nameCountriesList.length; i++) {
      if (i == nameCountriesList.length - 1) {
        nameCountries += nameCountriesList[i];
      } else {
        nameCountries += '${nameCountriesList[i]}, ';
      }
      if (selectCount != 0 && selectCount == 1) {
        nameCountries = nameCountries.replaceAll(',', '');
      }
    }

    return nameCountries;
  }

  String _regionsString() {
    List<String> nameRegionsList = [];
    String nameRegions = '';
    int selectCount = 0;
    for (int i = 0; i < widget.allCountries.length; i++) {
      if (widget.allCountries[i].select) {
        for (int j = 0; j < widget.allCountries[i].region.length; j++) {
          if (widget.allCountries[i].region[j].select) {
            {
              selectCount += 1;
              nameRegionsList.add('${widget.allCountries[i].region[j].name}');
            }
          }
        }
      }
    }

    for (int i = 0; i < nameRegionsList.length; i++) {
      if (i == nameRegionsList.length - 1) {
        nameRegions += nameRegionsList[i];
      } else {
        nameRegions += '${nameRegionsList[i]}, ';
      }
      if (selectCount != 0 && selectCount == 1) {
        nameRegions = nameRegions.replaceAll(',', '');
      }
    }
    return nameRegions;
  }

  String _townsString() {
    List<String> nameRegionsList = [];
    String nameRegions = '';
    int selectCount = 0;
    for (int i = 0; i < widget.allCountries.length; i++) {
      if (widget.allCountries[i].select) {
        for (int j = 0; j < widget.allCountries[i].region.length; j++) {
          if (widget.allCountries[i].region[j].select) {
            {
              for (int k = 0; k < widget.allCountries[i].region[j].town.length; k++) {
                if (widget.allCountries[i].region[j].town[k].select) {
                  {
                    selectCount += 1;
                    nameRegionsList.add('${widget.allCountries[i].region[j].town[k].name}');
                  }
                }
              }
            }
          }
        }
      }
    }

    for (int i = 0; i < nameRegionsList.length; i++) {
      if (i == nameRegionsList.length - 1) {
        nameRegions += nameRegionsList[i];
      } else {
        nameRegions += '${nameRegionsList[i]}, ';
      }
      if (selectCount != 0 && selectCount == 1) {
        nameRegions = nameRegions.replaceAll(',', '');
      }
    }
    return nameRegions;
  }
}
