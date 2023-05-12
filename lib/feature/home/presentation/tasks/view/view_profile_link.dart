import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/svg_and_images.dart';
import 'package:just_do_it/constants/text_style.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/view_profile.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/widget/back_icon_button.dart';

class ViewProfileLink extends StatefulWidget {
  Owner owner;
  ViewProfileLink(this.owner);

  @override
  State<ViewProfileLink> createState() => _ViewProfileLinkState();
}

class _ViewProfileLinkState extends State<ViewProfileLink> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 60.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'Профиль',
                      style: CustomTextStyle.black_22_w700,
                    ),
                  ),
                  CustomIconButton(
                    onBackPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: SvgImg.arrowRight,
                  ),
                ],
              ),
            ),
            Expanded(child: ProfileView(owner: widget.owner)),
          ],
        ),
      ),
    );
  }
}
