import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';

import '../../../../../constants/svg_and_images.dart';
import '../../all_tasks/view/all_tasks.dart';

class Customer extends StatelessWidget {
  const Customer({
    Key? key,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AllTasks()));
          },
          child: Container(
            height: 70.h,
            width: size.width,
            margin: EdgeInsets.symmetric(
              horizontal: 20.w,
            ),
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                SvgPicture.asset(
                  SvgImg.task,
                  color: const Color(0xffFFCA0D),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '322 задания',
                      style: TextStyle(
                        color: Colors.grey,
                        fontFamily: 'SFPro',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      'Все задания',
                      style: TextStyle(
                        fontFamily: 'SFPro',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                const Icon(Icons.keyboard_arrow_right_rounded),
              ],
            ),
          ),
        ),
        Container(
          height: 70.h,
          width: size.width,
          margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                SvgImg.archive,
                color: const Color(0xffFFCA0D),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '322 задания',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    'В архиве',
                    style: TextStyle(
                      fontFamily: 'SFPro',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_right_rounded),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.only(top: 40.h, left: 20.w, bottom: 50.h),
          child: Text(
            'Вас выбрали в 3 заданиях',
            style: TextStyle(
              fontSize: 16.sp,
              fontFamily: 'SFPro',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 55.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    SvgImg.inProgress,
                    height: 15.h,
                    width: 15.w,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выполняются',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFPro',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '1 задания',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SFPro',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 55.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    SvgImg.complete,
                    height: 15.h,
                    width: 15.w,
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Выполнены',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFPro',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '1 задания',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SFPro',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          height: 55.h,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    SvgImg.needSuccess,
                    height: 15.h,
                    width: 15.w,
                  )
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ждут подтверждения',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'SFPro',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    '1 задания',
                    style: TextStyle(
                      color: Colors.grey,
                      fontFamily: 'SFPro',
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
              const Spacer(),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 15.h),
          child: const Divider(
            height: 1,
            indent: 20,
            endIndent: 20,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: CustomButton(
            onTap: () {},
            btnColor: Colors.yellow,
            textLabel: const Text('Создать новое'),
          ),
        )
      ],
    );
  }
}
