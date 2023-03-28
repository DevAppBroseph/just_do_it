import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({super.key});

  @override
  State<DatePicker> createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Column(
                  children: const [
                    Text(
                      'Дата начала',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
            child: Row(
              children: [
                Column(
                  children: const [
                    Text(
                      'Дата окончания',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Icon(
                  Icons.calendar_month_outlined,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Container(
                  height: 70.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.grey[200],
                  ),
                ),
                const Spacer(),
                Container(
                  height: 70.h,
                  width: 150.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 10.h,
            ),
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: Colors.grey[200],
            ),
            child: Row(
              children: const [
                Text(
                  'Выбрать регион',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                Spacer(),
                Icon(
                  Icons.language_rounded,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: CustomButton(
              onTap: () {},
              btnColor: Colors.purple,
              textLabel: const Text(
                'Поднять объявление на верх',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
