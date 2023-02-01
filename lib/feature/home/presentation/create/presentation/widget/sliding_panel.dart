import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelSearch extends StatefulWidget {
  PanelController panelController;

  SlidingPanelSearch(this.panelController);

  @override
  State<SlidingPanelSearch> createState() => _SlidingPanelSearchState();
}

class _SlidingPanelSearchState extends State<SlidingPanelSearch> {
  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: widget.panelController,
      renderPanelSheet: false,
      panel: panel(context),
      maxHeight: 686.h,
      minHeight: 0.h,
      backdropEnabled: true,
      backdropColor: Colors.black,
      backdropOpacity: 0.8,
      defaultPanelState: PanelState.CLOSED,
    );
  }

  bool passportAndCV = false;

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
            color: Colors.white,
          ),
          child: Column(
            children: [
              ListView(
                shrinkWrap: true,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                          color: const Color(0xFF14376A).withOpacity(0.45),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 27.h),
                  Row(
                    children: [
                      Text(
                        'Фильтры',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          color: Colors.black,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Очистить',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.sp,
                          color: Colors.red,
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
                          SvgPicture.asset('assets/icons/crown.svg'),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Категории',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: const Color(0xFFBDBDBD),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Все категории',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: const Color(0xFF171716),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 16.h,
                          ),
                        ],
                      ),
                    ),
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
                          SvgPicture.asset('assets/icons/location.svg'),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'По региону',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: const Color(0xFFBDBDBD),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                'Все регионы',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.sp,
                                  color: const Color(0xFF171716),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
                            size: 16.h,
                          ),
                        ],
                      ),
                    ),
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
                          SvgPicture.asset('assets/icons/calendar.svg'),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Даты начала и окончания',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                  color: const Color(0xFFBDBDBD),
                                ),
                              ),
                              SizedBox(height: 3.h),
                              Text(
                                '21.12.22 - 22.12.22',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.sp,
                                  color: const Color(0xFF171716),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey[400],
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
                          child: Container(
                            height: 55.h,
                            padding: EdgeInsets.only(left: 16.w, right: 16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Бюджет от',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  '1 000 ₽',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.sp,
                                    color: const Color(0xFF171716),
                                  ),
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
                          child: Container(
                            height: 55.h,
                            padding: EdgeInsets.only(left: 16.w, right: 16.w),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Бюджет до',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: const Color(0xFFBDBDBD),
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  '1 000 ₽',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.sp,
                                    color: const Color(0xFF171716),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 99.h,
                        padding:
                            EdgeInsets.only(left: 16.w, right: 16.w, top: 16.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset(
                                    'assets/icons/quote-up-square.svg'),
                                SizedBox(width: 10.w),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Ключевые слова',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12.sp,
                                        color: const Color(0xFFBDBDBD),
                                      ),
                                    ),
                                    SizedBox(height: 3.h),
                                    Text(
                                      'Например, покупка апельсинов',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 14.sp,
                                        color: const Color(0xFF171716),
                                      ),
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    Text(
                      'Паспортные данные загружены и есть резюме',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
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
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton(
                  onTap: () {
                    widget.panelController.animatePanelToPosition(0);
                  },
                  btnColor: Colors.yellow[600]!,
                  textLabel: Text(
                    'Показать задания',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
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
}
