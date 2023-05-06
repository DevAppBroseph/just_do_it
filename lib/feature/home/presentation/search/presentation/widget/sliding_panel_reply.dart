import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search/presentation/bloc/reply/reply_bloc.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/type_filter.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelReply extends StatefulWidget {
  PanelController panelController;

  SlidingPanelReply(this.panelController, {super.key});

  @override
  State<SlidingPanelReply> createState() => _SlidingPanelReplyState();
}

class _SlidingPanelReplyState extends State<SlidingPanelReply> {
  double heightPanel = 637.h;
  List<Countries> countries = [];
  bool slide = false;
  DateTime? startDate;
  DateTime? endDate;

  TypeFilter typeFilter = TypeFilter.main;

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();
  TextEditingController keyWordController = TextEditingController();

  ScrollController mainScrollController = ScrollController();

  bool customerFlag = true;
  bool contractorFlag = true;

  final GlobalKey _countryKey = GlobalKey();
  final GlobalKey _regionKey = GlobalKey();

  List<Countries> listCountries = [];
  Countries? selectCountries;

  List<Regions> listRegions = [];
  Regions? selectRegions;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReplyBloc, ReplyState>(buildWhen: (previous, current) {
      if (current is OpenSlidingPanelToState) {
        heightPanel = current.height;
        widget.panelController.animatePanelToPosition(1);
        return true;
      } else {
        heightPanel = 637.h;
      }
      return true;
    }, builder: (context, snapshot) {
      return BlocBuilder<CountriesBloc, CountriesState>(
          builder: (context, state) {
        if (state is CountriesLoaded) {
          listCountries.addAll(BlocProvider.of<CountriesBloc>(context).country);
          countries.clear();
          countries.addAll(BlocProvider.of<CountriesBloc>(context).country);
        }
        return SlidingUpPanel(
          controller: widget.panelController,
          renderPanelSheet: false,
          panel: panel(context),
          onPanelSlide: (position) {
            if (position == 0) {
              BlocProvider.of<ReplyBloc>(context).add(HideSlidingPanelEvent());
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
                        if (format1 != null || format2 != null) {
                          countField++;
                        }

                        List<Countries> country = [];
                        List<Regions> regions = [];
                        List<Town> towns = [];

                        for (var element in countries) {
                          if (element.select) {
                            country.add(element);
                          }
                        }

                        for (var element in country) {
                          for (var element1 in element.region) {
                            if (element1.select) {
                              regions.add(element1);
                            }
                          }
                        }

                        for (var element in regions) {
                          for (var element1 in element.town) {
                            if (element1.select) {
                              towns.add(element1);
                            }
                          }
                        }
                      },
                      btnColor: ColorStyles.yellowFFD70A,
                      textLabel: Text(
                        'Далее',
                        style: CustomTextStyle.black_16_w600_171716,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
              // if (MediaQuery.of(context).viewInsets.bottom > 0 &&
              //     (focusCoastMin.hasFocus ||
              //         focusCoastMax.hasFocus ||
              //         focusCoastKeyWord.hasFocus))
              //   Column(
              //     children: [
              //       const Spacer(),
              //       AnimatedPadding(
              //         duration: const Duration(milliseconds: 0),
              //         padding: EdgeInsets.only(
              //             bottom: MediaQuery.of(context).viewInsets.bottom),
              //         child: Row(
              //           children: [
              //             Expanded(
              //               child: Container(
              //                 color: Colors.grey[200],
              //                 child: MediaQuery(
              //                   data: MediaQuery.of(context)
              //                       .copyWith(textScaleFactor: 1.0),
              //                   child: Align(
              //                     alignment: Alignment.centerRight,
              //                     child: Padding(
              //                       padding: const EdgeInsets.all(5),
              //                       child: InkWell(
              //                         onTap: () {
              //                           FocusScope.of(context).unfocus();
              //                           slide = false;
              //                           setState(() {});
              //                         },
              //                         child: Container(
              //                             padding: const EdgeInsets.symmetric(
              //                               vertical: 9.0,
              //                               horizontal: 12.0,
              //                             ),
              //                             child: const Text('Готово')),
              //                       ),
              //                     ),
              //                   ),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   )
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
                key: GlobalKeys.keyIconBtn2,
                onTap: () => showIconModal(
                  context,
                  GlobalKeys.keyIconBtn2,
                  (value) {
                    // documentTypeController.text = value;
                    // additionalInfo = true;
                    // user?.copyWith(docType: mapDocumentType(value));
                    // setState(() {});
                  },
                  ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
                  'Документ',
                ),
                child: Row(
                  // alignment: Alignment.centerRight,
                  children: [
                    CustomTextField(
                      hintText: 'Документ',
                      hintStyle: CustomTextStyle.grey_14_w400,
                      height: 50.h,
                      enabled: false,
                      onTap: () {},
                      // fillColor: Colors.grey[200],
                      textEditingController: TextEditingController(),
                      // textEditingController: documentTypeController,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 18.w, vertical: 18.h),
                    ),
                    // Padding(
                    //   padding: EdgeInsets.only(right: 16.w),
                    //   child: Stack(
                    //     alignment: Alignment.center,
                    //     children: [
                    //       // documentTypeController.text.isNotEmpty
                    //       //     ? GestureDetector(
                    //       //         onTap: () {
                    //       //           additionalInfo = false;
                    //       //           documentTypeController.text = '';
                    //       //           serialDocController.text = '';
                    //       //           numberDocController.text = '';
                    //       //           whoGiveDocController.text = '';
                    //       //           dateDocController.text = '';
                    //       //           dateTimeStart = null;
                    //       //           dateTimeEnd = null;
                    //       //           setState(() {});
                    //       //         },
                    //       //         child: const Icon(Icons.close),
                    //       //       )
                    //       SvgPicture.asset(
                    //         SvgImg.arrowBottom,
                    //         width: 16.h,
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                key: _countryKey,
                onTap: () => showCountry(
                  context,
                  _countryKey,
                  (value) async {
                    // countryController.text = value.name ?? '-';
                    selectCountries = value;
                    // regionController.text = '';
                    listRegions.clear();
                    listRegions = await Repository().regions(selectCountries!);
                    // user?.copyWith(country: countryController.text);
                    // setState(() {});
                  },
                  countries,
                  'Выберите страну',
                ),
                child: CustomTextField(
                  hintText: 'Страна',
                  hintStyle: CustomTextStyle.grey_14_w400,
                  height: 50.h,
                  enabled: false,
                  textEditingController: TextEditingController(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                  onChanged: (value) {},
                ),
              ),
              SizedBox(height: 16.h),
              GestureDetector(
                key: _regionKey,
                onTap: () {
                  // if (countryController.text.isNotEmpty) {
                  showRegion(
                    context,
                    _regionKey,
                    (value) {
                      // regionController.text = value.name ?? '-';
                      // user!.copyWith(region: regionController.text);
                      setState(() {});
                    },
                    listRegions,
                    'Выберите регион',
                  );
                  // } else {
                  //   showAlertToast(
                  //       'Чтобы выбрать регион, сначала укажите страну');
                  // }
                },
                child: CustomTextField(
                  hintText: 'Регион',
                  hintStyle: CustomTextStyle.grey_14_w400,
                  height: 50.h,
                  enabled: false,
                  textEditingController: TextEditingController(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
                  onChanged: (value) {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
