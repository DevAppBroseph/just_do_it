import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:scale_button/scale_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelSearch extends StatelessWidget {
  PanelController panelController;

  SlidingPanelSearch(this.panelController);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      renderPanelSheet: false,
      panel: panel(context),
      maxHeight: 686.h,
      minHeight: 0.h,
      defaultPanelState: PanelState.CLOSED,
    );
  }

  Widget panel(BuildContext context) {
    return Material(
      child: Container(
        margin: MediaQuery.of(context).viewInsets + EdgeInsets.only(top: 15.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.r),
            topRight: Radius.circular(25.r),
          ),
          boxShadow: const [
            BoxShadow(
              blurRadius: 10,
              spreadRadius: 1,
              color: Colors.black12,
            ),
          ],
          color: Colors.white,
        ),
        child: Column(
          children: [
            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    top: 10.w,
                    left: ((MediaQuery.of(context).size.width * 33) / 100).w,
                    right: ((MediaQuery.of(context).size.width * 33) / 100).w,
                    bottom: 10.w,
                  ),
                  child: Container(
                    height: 5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25.r),
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Text(
                      'Фильтры',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 22.sp,
                        color: Colors.black,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Очистить',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.sp,
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
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_download_done,
                          color: Colors.grey[400],
                          size: 25.h,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Категории',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              'Все категории',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14.sp,
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
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_download_done,
                          color: Colors.grey[400],
                          size: 25.h,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'По региону',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              'Все регионы',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14.sp,
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
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.file_download_done,
                          color: Colors.grey[400],
                          size: 25.h,
                        ),
                        SizedBox(width: 10.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Даты начала и окончания',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 12.sp,
                                color: Colors.grey[400],
                              ),
                            ),
                            Text(
                              '21.12.22 - 22.12.22',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 14.sp,
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
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Text(
                                '1000 ₽',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.sp,
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
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
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
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.sp,
                                  color: Colors.grey[400],
                                ),
                              ),
                              Text(
                                '1000 ₽',
                                style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14.sp,
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
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.dns_sharp,
                                color: Colors.grey[400],
                              ),
                              SizedBox(width: 10.w),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ключевые слова',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 12.sp,
                                      color: Colors.grey[400],
                                    ),
                                  ),
                                  Text(
                                    'Например, покупка апельсинов',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14.sp,
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
                    value: false,
                    onChanged: (value) {},
                  ),
                ],
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: CustomButton(
                onTap: () {},
                btnColor: Colors.yellow[600]!,
                textLabel: Text(
                  'Показать задания',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}
