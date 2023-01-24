import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';

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
                const Icon(
                  Icons.book,
                  color: Colors.amber,
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      '322 задания',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    Text('Все задания')
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
              const Icon(
                Icons.archive_sharp,
                color: Colors.amber,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    '322 задания',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  Text('В архиве')
                ],
              ),
              const Spacer(),
              const Icon(Icons.keyboard_arrow_right_rounded),
            ],
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 40, left: 20, bottom: 50),
          child: Text(
            'Вас выбрали в 3 заданиях',
            style: TextStyle(
              fontSize: 20,
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
                children: const [
                  Icon(
                    Icons.archive_sharp,
                    color: Colors.amber,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Выполняются',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '1 задания',
                    style: TextStyle(
                      color: Colors.grey,
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
                children: const [
                  Icon(
                    Icons.archive_sharp,
                    color: Colors.amber,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Выполнены',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '1 задания',
                    style: TextStyle(
                      color: Colors.grey,
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
                children: const [
                  Icon(
                    Icons.archive_sharp,
                    color: Colors.amber,
                  ),
                ],
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Ждут подтверждения',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    '1 задания',
                    style: TextStyle(
                      color: Colors.grey,
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
