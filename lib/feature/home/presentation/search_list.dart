import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/colors.dart';
import 'package:just_do_it/constants/text_style.dart';

class SearchList extends StatefulWidget {
  double heightScreen;
  double bottomInsets;
  Function(String) onSelect;
  List<String> array = [];

  SearchList(this.heightScreen, this.bottomInsets, this.onSelect, this.array,
      {super.key});

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context)
          .copyWith(textScaler: const TextScaler.linear(1.0)),
      child: Container(
        height: widget.heightScreen - 152.h - 220.h,
        color: Colors.white,
        child: ListView.builder(
          itemCount: widget.array.length,
          padding: EdgeInsets.only(bottom: 96.h),
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                widget.onSelect(widget.array[index]);
              },
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 24.w, vertical: 18.h),
                      child: Text(
                        widget.array[index],
                        style:
                            CustomTextStyle.sf17w400(AppColors.blackSecondary)
                                .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: const Divider(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
