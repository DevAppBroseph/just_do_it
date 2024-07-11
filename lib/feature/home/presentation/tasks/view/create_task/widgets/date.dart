import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/formatter_currency.dart';
import 'package:just_do_it/feature/auth/widget/textfield_currency.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/currency_bloc/currency_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/feature/theme/settings_scope.dart';
import 'package:just_do_it/helpers/data_formatter.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:scale_button/scale_button.dart';

class DatePicker extends StatefulWidget {
  Function(bool) saveTask;
  bool isCreating;
  double bottomInsets;
  TextEditingController coastMinController;
  TextEditingController coastMaxController;
  Function(DateTime?, DateTime?, List<Countries>, Currency?, bool) onEdit;
  DateTime? startDate;
  DateTime? endDate;
  bool isGraded;
  bool isTask;
  List<Countries> allCountries;
  Currency? currecy;
  bool isBanned;
  DatePicker({
    super.key,
    required this.onEdit,
    required this.isCreating,
    required this.isTask,
    required this.isGraded,
    required this.bottomInsets,
    required this.coastMinController,
    required this.coastMaxController,
    required this.startDate,
    required this.endDate,
    required this.allCountries,
    required this.currecy,
    required this.saveTask,
    this.isBanned = false,
  });

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  bool openCountry = false;
  bool openCurrency = false;
  bool openRegion = false;
  bool openTown = false;
  bool raise = false;
  ScrollController controller = ScrollController();
  ScrollController countyController = ScrollController();
  ScrollController regionController = ScrollController();
  ScrollController townController = ScrollController();
  ScrollController currecyController = ScrollController();
  late UserRegModel? user;

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user;
  }

  void _showDatePicker(ctx, int index) {
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
                    color: SettingsScope.themeOf(context).theme.mode ==
                            ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                    child: Row(
                      children: [
                        const Spacer(),
                        CupertinoButton(
                          padding: EdgeInsets.symmetric(horizontal: 15.w),
                          borderRadius: BorderRadius.zero,
                          child: Text(
                            'done'.tr(),
                            style: SettingsScope.themeOf(context)
                                .theme
                                .getStyle(
                                    (lightStyles) =>
                                        lightStyles.sf17w400BlackSec,
                                    (darkStyles) =>
                                        darkStyles.sf17w400BlackSec),
                          ),
                          onPressed: () {
                            if (index == 0 && widget.startDate == null) {
                              if (widget.endDate != null) {
                                widget.startDate = widget.endDate;
                                return;
                              }
                              widget.startDate = DateTime.now();
                            } else if (index == 1 && widget.endDate == null) {
                              if (widget.startDate != null) {
                                widget.endDate = widget.startDate;
                                return;
                              }
                              widget.endDate = DateTime.now();
                            }
                            setState(() {});
                            Navigator.of(ctx).pop();
                            widget.onEdit(
                              widget.startDate,
                              widget.endDate,
                              widget.allCountries,
                              widget.currecy,
                              widget.isGraded,
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
              color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                  ? DarkAppColors.blackSurface
                  : LightAppColors.whitePrimary,
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
                      widget.isGraded,
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
    final todayDate = DateTime.now();
    bool canRaise = ((widget.endDate != null &&
            (widget.endDate?.add(const Duration(days: 1)))!.isAfter(
                DateTime(todayDate.year, todayDate.month, todayDate.day)))) &&
        !widget.isGraded &&
        !widget.isBanned;
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
          for (int index = 0;
              index < widget.allCountries[i].region.length;
              index++) {
            regionsListWidget.add(
              Padding(
                padding: EdgeInsets.only(left: 20.w, right: 20.w),
                child: GestureDetector(
                  onTap: () async {
                    widget.allCountries[i].region[index].select =
                        !widget.allCountries[i].region[index].select;
                    if (widget.allCountries[i].region[index].select) {
                      if (widget.allCountries[i].region[index].town.isEmpty) {
                        widget.allCountries[i].region[index].town =
                            await Repository()
                                .towns(widget.allCountries[i].region[index]);
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
                      widget.isGraded,
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
                                user?.rus ?? true
                                    ? widget.allCountries[i].region[index].name!
                                    : widget
                                        .allCountries[i].region[index].engName!,
                                style: SettingsScope.themeOf(context)
                                    .theme
                                    .getStyle(
                                        (lightStyles) =>
                                            lightStyles.sf17w400BlackSec,
                                        (darkStyles) =>
                                            darkStyles.sf17w400BlackSec),
                              ),
                            ),
                            const Spacer(),
                            if (widget.allCountries[i].region[index].select)
                              const Icon(Icons.check)
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

    List<Widget> townsListWidget = [];
    if (openTown) {
      for (int i = 0; i < widget.allCountries.length; i++) {
        if (widget.allCountries[i].select) {
          for (int index = 0;
              index < widget.allCountries[i].region.length;
              index++) {
            if (widget.allCountries[i].region[index].select) {
              for (int index3 = 0;
                  index3 < widget.allCountries[i].region.length;
                  index3++) {
                if (widget.allCountries[i].region[index].town.isNotEmpty) {
                  townsListWidget.add(
                    Padding(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w),
                      child: GestureDetector(
                        onTap: () {
                          widget.allCountries[i].region[index].town[index3]
                                  .select =
                              !widget.allCountries[i].region[index].town[index3]
                                  .select;

                          widget.onEdit(
                            widget.startDate,
                            widget.endDate,
                            widget.allCountries,
                            widget.currecy,
                            widget.isGraded,
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
                                      user?.rus ?? true
                                          ? widget.allCountries[i].region[index]
                                              .town[index3].name!
                                          : widget.allCountries[i].region[index]
                                              .town[index3].engName!,
                                      style: SettingsScope.themeOf(context)
                                          .theme
                                          .getStyle(
                                              (lightStyles) =>
                                                  lightStyles.sf17w400BlackSec,
                                              (darkStyles) =>
                                                  darkStyles.sf17w400BlackSec),
                                    ),
                                  ),
                                  const Spacer(),
                                  if (widget.allCountries[i].region[index]
                                      .town[index3].select)
                                    const Icon(Icons.check)
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
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
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
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'start_date'.tr(),
                        style: SettingsScope.themeOf(context).theme.getStyle(
                              (lightStyles) => lightStyles.sf15w400BlackSec,
                              (darkStyles) => darkStyles.sf15w400BlackSec,
                            ),
                      ),
                      SizedBox(height: 0.h),
                      if (widget.startDate != null)
                        Text(
                          DateFormat('dd.MM.yyyy').format(widget.startDate!),
                          style: SettingsScope.themeOf(context).theme.getStyle(
                                (lightStyles) => lightStyles.sf15w400BlackSec,
                                (darkStyles) => darkStyles.sf15w400BlackSec,
                              ),
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
                color:
                    SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'completion_date'.tr(),
                        style: SettingsScope.themeOf(context).theme.getStyle(
                              (lightStyles) => lightStyles.sf15w400BlackSec,
                              (darkStyles) => darkStyles.sf15w400BlackSec,
                            ),
                      ),
                      SizedBox(height: 0.h),
                      if (widget.endDate != null)
                        Text(
                          DateFormat('dd.MM.yyyy').format(widget.endDate!),
                          style: CustomTextStyle.sf17w400(
                              LightAppColors.blackSecondary),
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
              style: SettingsScope.themeOf(context).theme.getStyle(
                  (lightStyles) => lightStyles.sf17w400BlackSec,
                  (darkStyles) => darkStyles.sf17w400BlackSec),
              fillColor:
                  SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                      ? DarkAppColors.blackSurface
                      : LightAppColors.whitePrimary,
              hintText: 'currency_paid'.tr(),
              hintStyle: SettingsScope.themeOf(context).theme.getStyle(
                    (lightStyles) => lightStyles.sf15w400BlackSec,
                    (darkStyles) => darkStyles.sf15w400BlackSec,
                  ),
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
              textEditingController: TextEditingController(
                  text: user?.rus ?? true
                      ? widget.currecy?.name
                      : widget.currecy?.engName),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
            ),
          ),
          SizedBox(height: 14.h),
          BlocBuilder<CurrencyBloc, CurrencyState>(builder: (context, state) {
            log("CurrencyBloc state $state");
            if (state is CurrencyLoaded) {
              final currecy = state.currency;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: openCurrency ? 160.h : 0.h,
                decoration: BoxDecoration(
                  color: SettingsScope.themeOf(context).theme.mode ==
                          ThemeMode.dark
                      ? DarkAppColors.blackSurface
                      : LightAppColors.whitePrimary,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: [
                    BoxShadow(
                      color: LightAppColors.shadowPrimary,
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
                                  widget.isGraded,
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
                                            user?.rus ?? true
                                                ? e.name!
                                                : e.engName!,
                                            style: SettingsScope.themeOf(
                                                    context)
                                                .theme
                                                .getStyle(
                                                    (lightStyles) => lightStyles
                                                        .sf17w400BlackSec,
                                                    (darkStyles) => darkStyles
                                                        .sf17w400BlackSec),
                                          ),
                                        ),
                                        const Spacer(),
                                        if (widget.currecy?.id == e.id)
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
                      color: SettingsScope.themeOf(context).theme.mode ==
                              ThemeMode.dark
                          ? DarkAppColors.blackSurface
                          : LightAppColors.whitePrimary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'budget_from'.tr()} ${DataFormatter.convertCurrencyNameIntoSymbol(widget.currecy?.name)}',
                          style: SettingsScope.themeOf(context).theme.getStyle(
                                (lightStyles) => lightStyles.sf15w400BlackSec,
                                (darkStyles) => darkStyles.sf15w400BlackSec,
                              ),
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
                                openCurrency = false;
                                setState(() {});
                              },
                              onChanged: (value) {
                                widget.onEdit(
                                  widget.startDate,
                                  widget.endDate,
                                  widget.allCountries,
                                  widget.currecy,
                                  widget.isGraded,
                                );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {});
                              },
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FormatterCurrency()
                              ],
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                              fillColor:
                                  SettingsScope.themeOf(context).theme.mode ==
                                          ThemeMode.dark
                                      ? DarkAppColors.blackSurface
                                      : LightAppColors.whitePrimary,
                              maxLines: null,
                              style: SettingsScope.themeOf(context)
                                  .theme
                                  .getStyle(
                                      (lightStyles) =>
                                          lightStyles.sf17w400BlackSec,
                                      (darkStyles) =>
                                          darkStyles.sf17w400BlackSec),
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
                      color: SettingsScope.themeOf(context).theme.mode ==
                              ThemeMode.dark
                          ? DarkAppColors.blackSurface
                          : LightAppColors.whitePrimary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${'budget_up_to'.tr()} ${DataFormatter.convertCurrencyNameIntoSymbol(widget.currecy?.name)}',
                          style: SettingsScope.themeOf(context).theme.getStyle(
                                (lightStyles) => lightStyles.sf15w400BlackSec,
                                (darkStyles) => darkStyles.sf15w400BlackSec,
                              ),
                        ),
                        SizedBox(height: 3.h),
                        Row(
                          children: [
                            CustomTextFieldCurrency(
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
                                  widget.isGraded,
                                );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {});
                              },
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                FormatterCurrency(),
                              ],
                              contentPadding: EdgeInsets.zero,
                              hintText: '',
                              fillColor:
                                  SettingsScope.themeOf(context).theme.mode ==
                                          ThemeMode.dark
                                      ? DarkAppColors.blackSurface
                                      : LightAppColors.whitePrimary,
                              maxLines: null,
                              style: SettingsScope.themeOf(context)
                                  .theme
                                  .getStyle(
                                      (lightStyles) =>
                                          lightStyles.sf17w400BlackSec,
                                      (darkStyles) =>
                                          darkStyles.sf17w400BlackSec),
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
              style: SettingsScope.themeOf(context).theme.getStyle(
                  (lightStyles) => lightStyles.sf17w400BlackSec,
                  (darkStyles) => darkStyles.sf17w400BlackSec),
              fillColor:
                  SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                      ? DarkAppColors.blackSurface
                      : LightAppColors.whitePrimary,
              hintText: 'select_country'.tr(),
              hintStyle: SettingsScope.themeOf(context).theme.getStyle(
                    (lightStyles) => lightStyles.sf15w400BlackSec,
                    (darkStyles) => darkStyles.sf15w400BlackSec,
                  ),
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
              textEditingController:
                  TextEditingController(text: _countriesString()),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
              color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                  ? DarkAppColors.blackSurface
                  : LightAppColors.whitePrimary,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: LightAppColors.shadowPrimary,
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
                            widget.isGraded,
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
                                      user?.rus ?? true ? e.name! : e.engName!,
                                      style: SettingsScope.themeOf(context)
                                          .theme
                                          .getStyle(
                                              (lightStyles) =>
                                                  lightStyles.sf17w400BlackSec,
                                              (darkStyles) =>
                                                  darkStyles.sf17w400BlackSec),
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
                    style: SettingsScope.themeOf(context).theme.getStyle(
                        (lightStyles) => lightStyles.sf17w400BlackSec,
                        (darkStyles) => darkStyles.sf17w400BlackSec),
                    fillColor: SettingsScope.themeOf(context).theme.mode ==
                            ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                    hintText: 'select_a_region'.tr(),
                    hintStyle: SettingsScope.themeOf(context).theme.getStyle(
                          (lightStyles) => lightStyles.sf15w400BlackSec,
                          (darkStyles) => darkStyles.sf15w400BlackSec,
                        ),
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
                    textEditingController:
                        TextEditingController(text: _regionsString()),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
              color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                  ? DarkAppColors.blackSurface
                  : LightAppColors.whitePrimary,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: LightAppColors.shadowPrimary,
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
                    style: SettingsScope.themeOf(context).theme.getStyle(
                        (lightStyles) => lightStyles.sf17w400BlackSec,
                        (darkStyles) => darkStyles.sf17w400BlackSec),
                    fillColor: SettingsScope.themeOf(context).theme.mode ==
                            ThemeMode.dark
                        ? DarkAppColors.blackSurface
                        : LightAppColors.whitePrimary,
                    hintText: 'select_an_area'.tr(),
                    hintStyle: SettingsScope.themeOf(context).theme.getStyle(
                          (lightStyles) => lightStyles.sf15w400BlackSec,
                          (darkStyles) => darkStyles.sf15w400BlackSec,
                        ),
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
                    textEditingController:
                        TextEditingController(text: _townsString()),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
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
              color: SettingsScope.themeOf(context).theme.mode == ThemeMode.dark
                  ? DarkAppColors.blackSurface
                  : LightAppColors.whitePrimary,
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: LightAppColors.shadowPrimary,
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
              GestureDetector(
                  onTap: () {
                    helpOnTopDialog(
                        context, 'raise_ad'.tr(), 'the_impact'.tr());
                  },
                  child: SvgPicture.asset(SvgImg.help)),
            ],
          ),
          SizedBox(height: 8.h),
          CustomButton(
            onTap: () {
              widget.saveTask(true);
            },
            btnColor: canRaise
                ? LightAppColors.purplePrimary
                : LightAppColors.greyTernary,
            textLabel: Text(
              (widget.isCreating
                      ? (widget.isTask
                          ? "сreate_a_task_and_raise"
                          : "create_offer_and_raise")
                      : (widget.isTask
                          ? "edit_task_and_raise"
                          : "edit_offer_and_raise"))
                  .tr(),
              style: canRaise
                  ? CustomTextStyle.sf17w400(LightAppColors.whitePrimary)
                  : CustomTextStyle.sf17w400(LightAppColors.greyBackdround),
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
        nameCountriesList.add(
            '${user?.rus ?? true ? widget.allCountries[i].name : widget.allCountries[i].engName}');
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
              nameRegionsList.add(
                  '${user?.rus ?? true ? widget.allCountries[i].region[j].name : widget.allCountries[i].region[j].engName}');
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
              for (int k = 0;
                  k < widget.allCountries[i].region[j].town.length;
                  k++) {
                if (widget.allCountries[i].region[j].town[k].select) {
                  {
                    selectCount += 1;
                    nameRegionsList.add(
                        '${user?.rus ?? true ? widget.allCountries[i].region[j].town[k].name : widget.allCountries[i].region[j].town[k].engName}');
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
