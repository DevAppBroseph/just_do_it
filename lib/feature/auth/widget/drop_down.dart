import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/widget_position.dart';

showIconModal(
  BuildContext context,
  GlobalKey key,
  Function(String) onTap,
  List<String> list,
  String label,
) async {
  iconSelectModal(
    context,
    getWidgetPosition(key),
    (index) {
      Navigator.pop(context);
      onTap(list[index]);
    },
    list,
    label,
  );
}

void iconSelectModal(
  BuildContext context,
  Offset offset,
  Function(int index) onTap,
  List<String> list,
  String label,
) =>
    showDialog(
      useSafeArea: false,
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            insetPadding:
                EdgeInsets.only(top: offset.dy, left: 20.h, right: 20.h),
            alignment: Alignment.topCenter,
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            elevation: 0,
            content: Container(
              width: MediaQuery.of(context).size.width - 20.w,
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.1),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  )
                ],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w, right: 8.w),
                          child: Container(
                            color: Colors.transparent,
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      label,
                                      style: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w300,
                                      ),
                                    ),
                                    const Spacer(),
                                    Icon(
                                      Icons.keyboard_arrow_up,
                                      size: 30,
                                      color: Colors.grey[400],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Stack(
                        children: [
                          SizedBox(
                            height: 140.h,
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: list.length,
                              padding: EdgeInsets.zero,
                              physics: const ClampingScrollPhysics(),
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return ElevatedButton(
                                  onPressed: () => onTap(index),
                                  style: ButtonStyle(
                                      padding: const MaterialStatePropertyAll(
                                          EdgeInsets.all(0)),
                                      backgroundColor:
                                          const MaterialStatePropertyAll(
                                              Colors.white),
                                      elevation:
                                          const MaterialStatePropertyAll(0),
                                      overlayColor:
                                          const MaterialStatePropertyAll(
                                              Colors.grey),
                                      shape: MaterialStatePropertyAll(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.r)))),
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 20.w),
                                    child: SizedBox(
                                      height: 50.h,
                                      child: Row(
                                        children: [
                                          Text(
                                            list[index],
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 13.sp,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                          const Spacer(),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
