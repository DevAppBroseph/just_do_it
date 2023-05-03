import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/countries_bloc/countries_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/search_list.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/view/create_task_page.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/helpers/storage.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:scale_button/scale_button.dart';

class CreatePage extends StatefulWidget {
  final Function() onBackPressed;
  final Function(int) onSelect;

  const CreatePage({
    super.key,
    required this.onBackPressed,
    required this.onSelect,
  });

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  int openCategory = -1;
  List<Activities> activities = [];
  Activities? selectCategory;
  ScrollController scrollController = ScrollController();
  bool searchList = false;
  List<String> searchChoose = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    activities.addAll(BlocProvider.of<AuthBloc>(context).activities);
  }

  void getHistoryList() async {
    final List<String> list = await Storage().getListHistory();
    searchChoose.clear();
    searchChoose.addAll(list);
  }

  @override
  Widget build(BuildContext context) {
    double heightScreen = MediaQuery.of(context).size.height;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;

    return BlocBuilder<AuthBloc, AuthState>(buildWhen: (previous, current) {
      if (current is GetCategoriesState) {
        activities.clear();
        activities.addAll(current.res);
      }
      return true;
    }, builder: (context, snapshot) {
      return MediaQuery(
        data: const MediaQueryData(textScaleFactor: 1.0),
        child: Scaffold(
          backgroundColor: ColorStyles.whiteFFFFFF,
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Container(
                height: 130.h,
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
                    Padding(
                      padding:
                          EdgeInsets.only(top: 60.h, left: 15.w, right: 28.w),
                      child: Row(
                        children: [
                          CustomIconButton(
                            onBackPressed: widget.onBackPressed,
                            icon: SvgImg.arrowRight,
                          ),
                          const Spacer(),
                          SizedBox(
                            width: 240.w,
                            height: 36.h,
                            child: CustomTextField(
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
                              onTap: () async {
                                setState(() {
                                  searchList = true;
                                });
                                getHistoryList();
                              },
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
                              hintStyle: CustomTextStyle.grey_14_w400
                                  .copyWith(overflow: TextOverflow.ellipsis),
                              textEditingController: searchController,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 11.w, vertical: 11.h),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(width: 23.w),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pushNamed(AppRoute.menu,
                                  arguments: [(page) {}, false]).then((value) {
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
                            child:
                                SvgPicture.asset('assets/icons/category.svg'),
                          ),
                        ],
                      ),
                    ),
                    Container(height: 30.h),
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
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          ListView(
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            physics: const ClampingScrollPhysics(),
                            children: [firstStage()],
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.h, vertical: 20.h),
                              child: CustomButton(
                                onTap: () async {
                                  final bloc =
                                      BlocProvider.of<ProfileBloc>(context);
                                  if (bloc.user == null) {
                                    Navigator.of(context)
                                        .pushNamed(AppRoute.auth);
                                  } else {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CeateTasks(
                                            customer: true,
                                            selectCategory: selectCategory,
                                          );
                                        },
                                      ),
                                    );
                                    BlocProvider.of<CountriesBloc>(context)
                                        .add(GetCountryEvent());
                                  }
                                },
                                btnColor: ColorStyles.yellowFFD70A,
                                textLabel: Text(
                                  'Создать',
                                  style: CustomTextStyle.black_16_w600_171716,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
            ],
          ),
        ),
      );
    });
  }

  Widget firstStage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.w),
          child: Text(
            'Что необходимо сделать?',
            style: CustomTextStyle.black_18_w800,
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 1.8,
          child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            physics: const ClampingScrollPhysics(),
            itemCount: activities.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  elementCategory(
                    activities[index].photo ?? '',
                    activities[index].description ?? '',
                    index,
                    choice: activities[index].selectSubcategory,
                  ),
                  info(
                    activities[index].subcategory,
                    index == openCategory,
                    index,
                  ),
                ],
              );
            },
          ),
        ),
        if (openCategory != 0) SizedBox(height: 80.h),
      ],
    );
  }

  Widget elementCategory(String icon, String title, int currentIndex,
      {List<String> choice = const []}) {
    String selectWork = '';
    if (choice.isNotEmpty) {
      selectWork = '- ${choice.first}';
      if (choice.length > 1) {
        for (int i = 1; i < choice.length; i++) {
          selectWork += ', ${choice[i]}';
        }
      }
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () => setState(() {
          if (openCategory != currentIndex) {
            openCategory = currentIndex;
            Future.delayed(const Duration(milliseconds: 300), () {
              scrollController.animateTo(
                65.h * currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            });
          } else {
            openCategory = -1;
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
              if (icon != '')
                SizedBox(
                  width: 20.h,
                  child: CachedNetworkImage(
                    imageUrl: server + icon,
                    height: 20.h,
                  ),
                ),
              SizedBox(width: 9.w),
              Text(
                title,
                style: CustomTextStyle.black_14_w400_171716,
              ),
              if (choice.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: SizedBox(
                    width: 70.w,
                    child: Text(
                      selectWork,
                      style: CustomTextStyle.grey_14_w400,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                ),
              const Spacer(),
              openCategory == currentIndex
                  ? const Icon(
                      Icons.keyboard_arrow_up,
                      color: Colors.blue,
                    )
                  : const Icon(
                      Icons.keyboard_arrow_down,
                      color: ColorStyles.greyBDBDBD,
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget info(List<Subcategory> list, bool open, int index) {
    double height = 0;
    if (open) {
      if (list.length >= 5) {
        height = 200.h;
      } else if (list.length == 4) {
        height = 160.h;
      } else if (list.length == 3) {
        height = 120.h;
      } else if (list.length == 2) {
        height = 80.h;
      }
    } else {
      height = 0;
    }
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 10.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: height,
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
        padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 0.w),
        child: ListView(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const ClampingScrollPhysics(),
          children: list
              .map((e) => item(
                    e.description ?? '',
                    index,
                  ))
              .toList(),
        ),
      ),
    );
  }

  Widget item(String label, int index) {
    return GestureDetector(
      onTap: () {
        if (activities[index].selectSubcategory.contains(label)) {
          activities[index].selectSubcategory.remove(label);
          selectCategory = null;
        } else {
          activities[index].selectSubcategory.clear();
          selectCategory = activities[index];
          activities[index].selectSubcategory.add(label);
        }
        for (int i = 0; i < activities.length; i++) {
          if (i != index) {
            activities[i].selectSubcategory.clear();
          }
        }
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w),
        child: Container(
          color: Colors.transparent,
          height: 40.h,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 250.w,
                    child: Text(
                      label,
                      style: CustomTextStyle.black_14_w400_515150,
                    ),
                  ),
                  const Spacer(),
                  if (activities[index].selectSubcategory.contains(label))
                    const Icon(Icons.check)
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
