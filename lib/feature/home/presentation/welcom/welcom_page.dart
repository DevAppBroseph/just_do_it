import 'package:auto_size_text/auto_size_text.dart';
import 'package:cupertino_rounded_corners/cupertino_rounded_corners.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/profile/presentation/rating/bloc/rating_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search_list.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/services/notification_service/notifications_service.dart';
import 'package:scale_button/scale_button.dart';

class WelcomPage extends StatefulWidget {
  Function(int) onSelect;

  WelcomPage(this.onSelect, {super.key});

  @override
  State<WelcomPage> createState() => _WelcomPageState();
}

class _WelcomPageState extends State<WelcomPage> {
  late UserRegModel? user;
  bool state = true;
  int indexLanguage = 0;
  int index = 0;
  String choiceLanguage = '';
  bool searchList = false;
  List<String> searchChoose = [];

  TextEditingController searchController = TextEditingController();

  Future<void> notificationInit() async {
    await NotificationService().inject();
  }

  String? access;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthBloc>(context).add(GetCategoriesEvent());
    notificationInit();
  }

  void getHistoryList() async {
    final List<String> list = await Storage().getListHistory();
    final List<String> listReversed = list.reversed.toList();
    searchChoose.clear();
    searchChoose.addAll(listReversed);
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;
    double heightScreen = MediaQuery.of(context).size.height;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                color: ColorStyles.whiteFFFFFF,
                boxShadow: [
                  BoxShadow(
                    color: ColorStyles.shadowFC6554,
                    offset: const Offset(0, -4),
                    blurRadius: 55.r,
                  )
                ],
              ),
              child: Column(
                children: [
                  Container(
                    height: 60.h,
                    color: ColorStyles.whiteFFFFFF,
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.w, right: 28.w),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 270.w,
                          height: 36.h,
                          child: CustomTextField(
                            onTap: () async {
                              setState(() {
                                searchList = true;
                              });
                              getHistoryList();
                            },
                            fillColor: ColorStyles.greyF7F7F8,
                            prefixIcon: Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/search1.svg',
                                  height: 12.h,
                                ),
                              ],
                            ),
                            onFieldSubmitted: (value) {
                              setState(() {
                                searchList = false;
                              });
                              Storage().setListHistory(value);
                              FocusScope.of(context).unfocus();
                              BlocProvider.of<ProfileBloc>(context)
                                  .add(EditPageSearchEvent(1, value));
                            },
                            onChanged: (value) {
                              if (value.isEmpty) {
                                getHistoryList();
                              }
                              List<Activities> activities =
                                  BlocProvider.of<ProfileBloc>(context)
                                      .activities;
                              searchChoose.clear();
                              if (value.isNotEmpty) {
                                for (var element1 in activities) {
                                  for (var element2 in element1.subcategory) {
                                    if (element2.description!
                                            .toLowerCase()
                                            .contains(value.toLowerCase()) &&
                                        !searchChoose.contains(element2
                                            .description!
                                            .toLowerCase())) {
                                      searchChoose.add(element2.description!);
                                    }
                                  }
                                }
                              }
                              setState(() {});
                            },
                            hintText: 'Поиск',
                            textEditingController: searchController,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 11.w, vertical: 11.h),
                          ),
                        ),
                        const Spacer(),
                        SizedBox(width: 23.w),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(AppRoute.menu, arguments: [
                              (page) {},
                              false,
                            ]).then((value) {
                              if (value != null) {
                                if (value == 'create') {
                                  widget.onSelect(0);
                                }
                                if (value == 'search') {
                                  widget.onSelect(1);
                                }
                                if (value == 'chat') {
                                  widget.onSelect(3);
                                }
                              }
                            });
                          },
                          child: SvgPicture.asset('assets/icons/category.svg'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            searchList
                ? SearchList(
                    heightScreen,
                    bottomInsets,
                    (value) {
                      Storage().setListHistory(value);
                      BlocProvider.of<ProfileBloc>(context)
                          .add(EditPageSearchEvent(1, value));
                    },
                    searchChoose,
                  )
                : Expanded(
                    child: ListView(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Container(height: 30.h, color: ColorStyles.whiteFFFFFF),
                        BlocBuilder<ProfileBloc, ProfileState>(
                          builder: (context, snapshot) {
                            final bloc = BlocProvider.of<ProfileBloc>(context);
                            if (bloc.user == null) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 80.w),
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 40.h, bottom: 22.h),
                                  child: Center(
                                    child: Text(
                                      'jobyfine'.toUpperCase(),
                                      style:
                                          CustomTextStyle.black_39_w900_171716,
                                    ),
                                  ),
                                ),
                              );
                            }
                            return Container(
                              color: ColorStyles.whiteFFFFFF,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: 15.h),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: 24.w, left: 24.w),
                                    child: SizedBox(
                                      height: 112.h,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 190.w,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Добро пожаловать,',
                                                  style: CustomTextStyle
                                                      .black_14_w400_515150,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: null,
                                                ),
                                                SizedBox(height: 8.h),
                                                AutoSizeText(
                                                  '${bloc.user?.firstname}\n${bloc.user?.lastname}',
                                                  style: TextStyle(
                                                      fontSize: 33.sp,
                                                      fontWeight:
                                                          FontWeight.w800),
                                                  maxLines: 2,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Spacer(),
                                          BlocBuilder<RatingBloc, RatingState>(
                                              builder: (context, snapshot) {
                                            var reviews =
                                                BlocProvider.of<RatingBloc>(
                                                        context)
                                                    .reviews;
                                            return ScaleButton(
                                              bound: 0.02,
                                              child: Container(
                                                height: 112.h,
                                                width: 121.h,
                                                padding: EdgeInsets.only(
                                                  left: 16.w,
                                                  right: 16.w,
                                                  top: 4.h,
                                                  bottom: 4.h,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: ColorStyles.greyF9F9F9,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.r),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      'Рейтинг',
                                                      style: CustomTextStyle
                                                          .grey_14_w400,
                                                    ),
                                                    SizedBox(height: 6.h),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          'assets/icons/star.svg',
                                                        ),
                                                        SizedBox(width: 4.w),
                                                        Text(
                                                          reviews?.ranking ==
                                                                  null
                                                              ? '-'
                                                              : reviews!
                                                                  .ranking!
                                                                  .toString(),
                                                          style: CustomTextStyle
                                                              .black_16_w600_171716,
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 10.h),
                                                    Text(
                                                      'Баллы:',
                                                      style: CustomTextStyle
                                                          .grey_14_w400,
                                                    ),
                                                    SizedBox(height: 4.h),
                                                    Text(
                                                      user?.balance
                                                              .toString() ??
                                                          '0',
                                                      style: CustomTextStyle
                                                          .black_16_w600_171716,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40.h),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 18.h),
                        Padding(
                          padding: EdgeInsets.only(left: 24.w),
                          child: Row(
                            children: [
                              Text(
                                'Посмотреть как:',
                                style: CustomTextStyle.black_18_w800,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Row(
                            children: [
                              ScaleButton(
                                bound: 0.02,
                                onTap: () => widget.onSelect(0),
                                child: Container(
                                  height: ((MediaQuery.of(context).size.width *
                                              47) /
                                          100) -
                                      40.w,
                                  width: ((MediaQuery.of(context).size.width *
                                              47) /
                                          100) -
                                      25.w,
                                  decoration: BoxDecoration(
                                    color: ColorStyles.whiteFFFFFF,
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorStyles.shadowFC6554,
                                        offset: const Offset(0, 4),
                                        blurRadius: 45.r,
                                      )
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 15.h),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Image.asset(
                                            'assets/images/contractor.png',
                                            height: 70.h,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 12.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Заказчик',
                                              style: CustomTextStyle
                                                  .black_14_w400_171716,
                                            ),
                                            Text(
                                              'Размещай задания',
                                              style:
                                                  CustomTextStyle.grey_12_w400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const Spacer(),
                              ScaleButton(
                                bound: 0.02,
                                onTap: () => widget.onSelect(1),
                                child: Container(
                                  height: ((MediaQuery.of(context).size.width *
                                              47) /
                                          100) -
                                      40.w,
                                  width: ((MediaQuery.of(context).size.width *
                                              47) /
                                          100) -
                                      25.w,
                                  decoration: BoxDecoration(
                                    color: ColorStyles.whiteFFFFFF,
                                    borderRadius: BorderRadius.circular(10.r),
                                    boxShadow: [
                                      BoxShadow(
                                        color: ColorStyles.shadowFC6554,
                                        offset: const Offset(0, 4),
                                        blurRadius: 45.r,
                                      )
                                    ],
                                  ),
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: 15.h),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Image.asset(
                                            'assets/images/customer.png',
                                            height: 70.h,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 12.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Исполнитель',
                                              style: CustomTextStyle
                                                  .black_14_w400_171716,
                                            ),
                                            Text(
                                              'Выполняй работу',
                                              style:
                                                  CustomTextStyle.grey_12_w400,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30.h),
                        elementCategory(
                          'assets/images/language.png',
                          'Русский',
                          1,
                          choice: choiceLanguage,
                        ),
                        info(
                          [
                            'Русский',
                            'Английский',
                          ],
                          indexLanguage == 1,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: ScaleButton(
                            duration: const Duration(milliseconds: 50),
                            bound: 0.01,
                            child: SizedBox(
                              height: 85.h,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    height: 69.h,
                                    child: CupertinoCard(
                                      onPressed: (){
                                         Navigator.of(context).pushNamed(AppRoute.about);
                                        scoreDialog(context, '50', 'создание заказа');
                                      },
                                      radius: BorderRadius.circular(25.r),
                                      color: ColorStyles.yellowFFD70A,
                                      margin: EdgeInsets.zero,
                                      elevation: 0,
                                      decoration: BoxDecoration(
                                        color: ColorStyles.yellowFFD70A,
                                        boxShadow: [
                                          BoxShadow(
                                            color: ColorStyles.shadowFC6554,
                                            offset: const Offset(0, -4),
                                            blurRadius: 55.r,
                                          )
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w),
                                        child: Row(
                                          children: [
                                            const Spacer(),
                                            Text(
                                              'Узнай больше о проекте!',
                                              style: CustomTextStyle
                                                  .black_16_w600_171716,
                                            ),
                                            const Spacer(),
                                            SvgPicture.asset(
                                                'assets/icons/arrow-right1.svg')
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex,
      {String choice = ''}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () => setState(() {
          if (indexLanguage != currentIndex) {
            indexLanguage = currentIndex;
          } else {
            indexLanguage = 0;
          }
        }),
        child: Container(
          decoration: BoxDecoration(
            color: ColorStyles.whiteFFFFFF,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: [
              BoxShadow(
                color: ColorStyles.shadowFC6554,
                offset: const Offset(0, -4),
                blurRadius: 55.r,
              )
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
          child: Row(
            children: [
              Image.asset(
                icon,
                height: 20.h,
              ),
              SizedBox(width: 9.w),
              Text(
                title,
                style: CustomTextStyle.black_14_w400_515150,
              ),
              if (choice.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: SizedBox(
                    width: 100.w,
                    child: Text(
                      '- $choice',
                      style: CustomTextStyle.grey_14_w400,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              const Spacer(),
              index == currentIndex
                  ? const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.blue,
                    )
                  : Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[400],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget info(List<String> list, bool open) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: open ? 80.h : 0.h,
        decoration: BoxDecoration(
          color: ColorStyles.whiteFFFFFF,
          borderRadius: BorderRadius.circular(10.r),
        ),
        padding: EdgeInsets.zero,
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          children: list.map((e) => item(e)).toList(),
        ),
      ),
    );
  }

  Widget item(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          indexLanguage = 0;
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 8.w),
        child: Container(
          color: Colors.transparent,
          height: 40.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: CustomTextStyle.black_14_w400_515150,
                  ),
                  const Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
