import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingPanelSearch extends StatelessWidget {
  PanelController panelController;

  SlidingPanelSearch(this.panelController);

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: panelController,
      renderPanelSheet: false,
      panel: Container(
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
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: 10.w,
                left: ((MediaQuery.of(context).size.width * 47) / 100).w,
                right: ((MediaQuery.of(context).size.width * 47) / 100).w,
                bottom: 10.w,
              ),
              child: Container(
                height: 5.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.r),
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
      maxHeight: 500.h,
      minHeight: 0.h,
      defaultPanelState: PanelState.CLOSED,
    );
  }
}
