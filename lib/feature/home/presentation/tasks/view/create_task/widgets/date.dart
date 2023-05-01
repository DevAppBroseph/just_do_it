import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:scale_button/scale_button.dart';

class DatePicker extends StatefulWidget {
  double bottomInsets;
  TextEditingController coastMinController;
  TextEditingController coastMaxController;
  Function(List<Regions>, DateTime?, DateTime?, List<Countries>, List<Town>)
      onEdit;
  DateTime? startDate;
  DateTime? endDate;
  List<Countries> selectCountry;
  List<Regions> selectRegion;
  List<Town> selectTown;
  DatePicker({
    super.key,
    required this.onEdit,
    required this.bottomInsets,
    required this.coastMinController,
    required this.coastMaxController,
    required this.startDate,
    required this.endDate,
    required this.selectRegion,
    required this.selectTown,
    required this.selectCountry,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool openCountry = false;
  bool openRegion = false;
  bool openTown = false;
  ScrollController controller = ScrollController();

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
                            style:
                                TextStyle(fontSize: 15.sp, color: Colors.black),
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
                                widget.selectRegion,
                                widget.startDate,
                                widget.endDate,
                                widget.selectCountry,
                                widget.selectTown);
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
                        widget.selectRegion,
                        widget.startDate,
                        widget.endDate,
                        widget.selectCountry,
                        widget.selectTown);
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
    return BlocBuilder<CountriesBloc, CountriesState>(
        builder: (context, state) {
      List<Countries> allCountries =
          BlocProvider.of<CountriesBloc>(context).country;
      List<Regions> allRegion = BlocProvider.of<CountriesBloc>(context).region;
      List<Town> allTown = BlocProvider.of<CountriesBloc>(context).town;

      return MediaQuery(
        data: const MediaQueryData(textScaleFactor: 1.0),
        child: ListView(
          controller: controller,
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          children: [
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
                        SizedBox(height: 0.h),
                        if (widget.startDate != null)
                          Text(
                            DateFormat('dd.MM.yyyy').format(widget.startDate!),
                            // : 'Выберите дату начала выполнения',
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
                        SizedBox(height: 0.h),
                        if (widget.endDate != null)
                          Text(
                            DateFormat('dd.MM.yyyy').format(widget.endDate!),
                            // : 'Выберите дату завершения задачи',
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
            Row(
              children: [
                Expanded(
                  child: ScaleButton(
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
                                actionButton: false,
                                onTap: () {
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  widget.onEdit(
                                      widget.selectRegion,
                                      widget.startDate,
                                      widget.endDate,
                                      widget.selectCountry,
                                      widget.selectTown);
                                },
                                onFieldSubmitted: (value) {
                                  setState(() {});
                                },
                                contentPadding: EdgeInsets.zero,
                                hintText: '',
                                fillColor: ColorStyles.greyF9F9F9,
                                maxLines: null,
                                style: CustomTextStyle.black_14_w400_171716,
                                textEditingController:
                                    widget.coastMinController,
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
                                actionButton: false,
                                textInputType: TextInputType.number,
                                onTap: () {
                                  setState(() {});
                                },
                                onChanged: (value) {
                                  widget.onEdit(
                                      widget.selectRegion,
                                      widget.startDate,
                                      widget.endDate,
                                      widget.selectCountry,
                                      widget.selectTown);
                                },
                                onFieldSubmitted: (value) {
                                  setState(() {});
                                },
                                contentPadding: EdgeInsets.zero,
                                hintText: '',
                                fillColor: ColorStyles.greyF9F9F9,
                                maxLines: null,
                                style: CustomTextStyle.black_14_w400_171716,
                                textEditingController:
                                    widget.coastMaxController,
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
                });
                FocusScope.of(context).unfocus();

                Future.delayed(Duration(milliseconds: 300), () {
                  controller.animateTo(
                    controller.position.maxScrollExtent - 20.h,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.linear,
                  );
                });
              },
              child: CustomTextField(
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
                textEditingController: TextEditingController(
                    text: _countriesString(widget.selectCountry)),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
              ),
            ),
            SizedBox(height: 14.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: openCountry ? 80.h : 0.h,
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
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: const ClampingScrollPhysics(),
                children: allCountries
                    .map(
                      (e) => Padding(
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        child: GestureDetector(
                          onTap: () {
                            openRegion = false;

                            List<Countries> list = widget.selectCountry;
                            if (list.contains(e)) {
                              list.remove(e);
                            } else {
                              list.add(e);
                            }
                            widget.onEdit(
                              [],
                              widget.startDate,
                              widget.endDate,
                              list,
                              [],
                            );
                            final access =
                                BlocProvider.of<ProfileBloc>(context).access;
                            context
                                .read<CountriesBloc>()
                                .add(GetRegionEvent(access, list));
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
                                        style: CustomTextStyle
                                            .black_14_w400_515150,
                                      ),
                                    ),
                                    const Spacer(),
                                    if (widget.selectCountry.contains(e))
                                      const Icon(Icons.check)
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
            SizedBox(height: 14.h),
            widget.selectCountry.isNotEmpty
                ? ScaleButton(
                    bound: 0.02,
                    onTap: () {
                      setState(() {
                        openRegion = !openRegion;
                      });
                      FocusScope.of(context).unfocus();

                      Future.delayed(Duration(milliseconds: 300), () {
                        controller.animateTo(
                          controller.position.maxScrollExtent - 20.h,
                          duration: Duration(milliseconds: 200),
                          curve: Curves.linear,
                        );
                      });
                    },
                    child: CustomTextField(
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
                      textEditingController: TextEditingController(
                          text: _regionsString(widget.selectRegion)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 18.h),
                    ),
                  )
                : Container(),
            SizedBox(height: 14.h),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: openRegion ? 200.h : 0.h,
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
              child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: allRegion
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                          child: GestureDetector(
                            onTap: () {
                              openTown = false;

                              List<Regions> list = widget.selectRegion;
                              if (list.contains(e)) {
                                list.remove(e);
                              } else {
                                list.add(e);
                              }

                              widget.onEdit(
                                list,
                                widget.startDate,
                                widget.endDate,
                                widget.selectCountry,
                                [],
                              );

                              final access =
                                  BlocProvider.of<ProfileBloc>(context).access;
                              context
                                  .read<CountriesBloc>()
                                  .add(GetTownsEvent(access, list));
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
                                          style: CustomTextStyle
                                              .black_14_w400_515150,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (widget.selectRegion.contains(e))
                                        const Icon(Icons.check)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
            SizedBox(height: 14.h),
            widget.selectRegion.isNotEmpty
                ? ScaleButton(
                    bound: 0.02,
                    onTap: () {
                      setState(() {
                        setState(() {
                          openTown = !openTown;
                        });
                        FocusScope.of(context).unfocus();

                        Future.delayed(Duration(milliseconds: 300), () {
                          controller.animateTo(
                            controller.position.maxScrollExtent - 20.h,
                            duration: Duration(milliseconds: 200),
                            curve: Curves.linear,
                          );
                        });
                      });
                    },
                    child: CustomTextField(
                      fillColor: ColorStyles.greyF9F9F9,
                      hintText: 'Выбрать подрегион',
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
                      textEditingController: TextEditingController(
                          text: _townsString(widget.selectTown)),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 18.h),
                    ),
                  )
                : Container(),
            SizedBox(height: 14.h),
            AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: openTown ? 200.h : 0.h,
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
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: allTown
                      .map(
                        (e) => Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 20.w),
                          child: GestureDetector(
                            onTap: () {
                              List<Town> list = widget.selectTown;
                              if (list.contains(e)) {
                                list.remove(e);
                              } else {
                                list.add(e);
                              }

                              widget.onEdit(
                                  widget.selectRegion,
                                  widget.startDate,
                                  widget.endDate,
                                  widget.selectCountry,
                                  list);

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
                                          style: CustomTextStyle
                                              .black_14_w400_515150,
                                        ),
                                      ),
                                      const Spacer(),
                                      if (widget.selectTown.contains(e))
                                        const Icon(Icons.check)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                  // : allTown
                  //     .map(
                  //       (e) => Padding(
                  //         padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             widget.onEdit(
                  //                 widget.selectRegion,
                  //                 widget.startDate,
                  //                 widget.endDate,
                  //                 widget.selectCountry,
                  //                 townsSelect);
                  //             setState(() {});
                  //           },
                  //           child: Container(
                  //             color: Colors.transparent,
                  //             height: 40.h,
                  //             child: Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Row(
                  //                   children: [
                  //                     SizedBox(
                  //                       width: 250.w,
                  //                       child: Text(
                  //                         e.name!,
                  //                         style: CustomTextStyle
                  //                             .black_14_w400_515150,
                  //                       ),
                  //                     ),
                  //                     const Spacer(),
                  //                     if (widget.selectTown.contains(e))
                  //                       const Icon(Icons.check)
                  //                   ],
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                )
                //     .toList()),
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
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
            SizedBox(height: widget.bottomInsets),
          ],
        ),
      );
    });
  }

  String _countriesString(List<Countries> selectCountries) {
    String nameCountries = '';
    for (var element in selectCountries) {
      nameCountries += '${element.name!}, ';
    }
    if (selectCountries.length == 1) {
      nameCountries = nameCountries.replaceAll(',', '');
    }
    return nameCountries;
  }

  String _regionsString(List<Regions> selectRegions) {
    String nameRegions = '';
    for (var element in selectRegions) {
      nameRegions += '${element.name!}, ';
    }
    if (selectRegions.length == 1) {
      nameRegions = nameRegions.replaceAll(',', '');
    }
    return nameRegions;
  }

  String _townsString(List<Town> selectTowns) {
    String nameTowns = '';
    for (var element in selectTowns) {
      nameTowns += '${element.name!}, ';
    }
    if (selectTowns.length == 1) {
      nameTowns = nameTowns.replaceAll(',', '');
    }
    return nameTowns;
  }
}
