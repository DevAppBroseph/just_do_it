import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/category_selector.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/date.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/task_additional.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/order_task.dart';
import 'package:just_do_it/models/task/task.dart';
import 'package:just_do_it/models/task/task_category.dart';
import 'package:just_do_it/models/task/task_status.dart';
import 'package:just_do_it/models/task/task_subcategory.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CreateTaskPage extends StatefulWidget {
  final TaskCategory? selectCategory;
  final bool customer;
  final bool doublePop;
  final int currentPage;
  const CreateTaskPage({
    super.key,
    this.selectCategory,
    required this.customer,
    this.doublePop = false,
    required this.currentPage,
  });

  @override
  State<CreateTaskPage> createState() => _CreateTaskPageState();
}

class _CreateTaskPageState extends State<CreateTaskPage> {
  late int type = widget.customer ? 1 : 2;

  late bool state = widget.customer ? false : true;
  late bool isTask = widget.customer;
  PageController pageController = PageController();

  PanelController panelController = PanelController();
  int page = 0;

  TextEditingController aboutController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();

  List<ArrayImages> documents = [];
  // List<ArrayImages> photo = [];

  List<Countries> countries = [];
  Currency? currency;
  late UserRegModel? user;
  TaskCategory? selectCategory;
  TaskSubcategory? selectSubCategory;

  DateTime? startDate;
  DateTime? endDate;
  Future<void> createTask(bool isGraded) async {
    String error = 'specify'.tr();
    bool errorsFlag = false;
    if (startDate == null) {
      error += '\n- ${'starts_date'.tr().toLowerCase()}';
      errorsFlag = true;
    }
    if (endDate == null) {
      error += '\n- ${'completions_date'.tr().toLowerCase()}';
      errorsFlag = true;
    }
    if (coastMinController.text.isEmpty) {
      error += '\n- ${'minimum_price'.tr()}';
      errorsFlag = true;
    }
    if (coastMaxController.text.isEmpty) {
      error += '\n- ${'maximum_price'.tr()}';
      errorsFlag = true;
    }

    if (currency == null) {
      error += '\n- ${'currency'.tr().toLowerCase()}';
      errorsFlag = true;
    }
    coastMaxController.text = coastMaxController.text.replaceAll(' ', '');
    coastMinController.text = coastMinController.text.replaceAll(' ', '');
    if (coastMinController.text.isNotEmpty &&
        coastMaxController.text.isNotEmpty) {
      if (int.parse(coastMinController.text) >
          int.parse(coastMaxController.text)) {
        error +=
            '\n- ${'the_minimum_budget_must_be_less_than_the_maximum'.tr()}';
        errorsFlag = true;
      }
    }
    if (coastMinController.text.isNotEmpty &&
        coastMaxController.text.isNotEmpty) {
      if (int.parse(coastMinController.text) > 1000000000) {
        error += '\n- themaximum_budget_should_not_exceed'.tr();
        errorsFlag = true;
      }
    }
    if (coastMinController.text.isNotEmpty &&
        coastMaxController.text.isNotEmpty) {
      if (int.parse(coastMaxController.text) > 1000000000) {
        error += '\n- themaximum_budget_should_not_exceed'.tr();
        errorsFlag = true;
      }
    }

    if (errorsFlag) {
      // showAlertToast(error);
      CustomAlert().showMessage(error);
    } else {
      if (user!.isBanned!) {
        if (isTask) {
          banDialog(context, 'respond_to_the_task'.tr());
        } else {
          banDialog(context, 'respond_to_the_offer'.tr());
        }
      } else {
        showLoaderWrapper(context);

        List<Countries> country = [];
        List<Regions> regions = [];
        List<Town> towns = [];

        for (var element in countries) {
          if (element.select) {
            country.add(element);
          }
        }

        for (var element in country) {
          for (var element1 in element.region) {
            if (element1.select) {
              regions.add(element1);
            }
          }
        }

        for (var element in regions) {
          for (var element1 in element.town) {
            if (element1.select) {
              towns.add(element1);
            }
          }
        }
        Task newTask = Task(
            isTask: isTask,
            name: titleController.text,
            description: aboutController.text,
            subcategory: selectSubCategory!,
            dateStart: DateFormat('yyyy-MM-dd').format(startDate!),
            dateEnd: DateFormat('yyyy-MM-dd').format(endDate!),
            priceFrom: int.parse(
              coastMinController.text.isEmpty ? '0' : coastMinController.text,
            ),
            priceTo: int.parse(
              coastMaxController.text.isEmpty ? '0' : coastMaxController.text,
            ),
            regions: regions,
            countries: country,
            towns: towns,
            files: documents,
            currency: currency,
            isGraded: isGraded,
            status: TaskStatus.undefined,
            canAppellate: false);
        BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
        final profileBloc = BlocProvider.of<ProfileBloc>(context);

        bool res = await Repository().createTask(profileBloc.access!, newTask);
        if (res) {
          BlocProvider.of<ProfileBloc>(context).add(UpdateProfileEvent(user));
          if (widget.currentPage == 6) {
            if (res) Navigator.of(context).pop();
          }

          if (widget.currentPage == 1 || widget.currentPage == 2) {
            if (res) Navigator.of(context).pop();
            if (res) {
              Navigator.of(context).pop(!isTask);
            }
          }
          if (widget.currentPage == 3 || widget.currentPage == 4) {
            if (res) {
              Navigator.of(context).pop(!isTask);
            }
          }

          Loader.hide();

          if (isTask) {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return TaskAdditional(
                  title: 'my_task'.tr(),
                  asCustomer: true,
                  scoreTrue: true,
                );
              }),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return TaskAdditional(
                    title: 'opens'.tr(), asCustomer: isTask, scoreTrue: true);
              }),
            );
          }
        } else {
          Loader.hide();
          if (isTask) {
            noMoney(context, 'raise_task'.tr(), 'task_to_the_top'.tr());
          } else {
            noMoney(context, 'raise_offer'.tr(), 'the_offer_to_the_top'.tr());
          }
        }
      }
    }
  }

  _selectImages() async {
    final getMedia = await ImagePicker().pickMultiImage();
    if (getMedia.isNotEmpty) {
      for (var element in getMedia) {
        final byte = await element.readAsBytes();
        documents.add(ArrayImages(null, byte,
            file: File(element.path), type: element.path.split('.').last));
      }
    }
    setState(() {});
  }

  _selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
      withData: true,
    );
    if (result != null) {
      for (var element in result.files) {
        documents.add(ArrayImages(null, element.bytes,
            file: File(element.path!), type: element.path?.split('.').last));
      }
      setState(() {});
    }
  }

  void onAttach() {
    showDialog(
      context: context,
      builder: (context) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              decoration: BoxDecoration(
                color: ColorStyles.whiteF5F5F5,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  Text(
                    'choose_what_to_download'.tr(),
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                  ListTile(
                    title: Text(
                      'photo'.tr(),
                      style: CustomTextStyle.black_14_w400_292D32,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectImages();
                    },
                  ),
                  ListTile(
                    title: Text(
                      'document'.tr(),
                      style: CustomTextStyle.black_14_w400_292D32,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectFiles();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user;
    selectCategory = widget.selectCategory;
    if (widget.selectCategory != null) {
      for (var element in widget.selectCategory!.subcategory) {
        if (widget.selectCategory!.selectSubcategory.contains(
            user?.rus ?? true ? element.description : element.engDescription)) {
          selectSubCategory = element;
        }
      }
    }
    getCountry();
  }

  void getCountry() async {
    countries = await Repository().countries();
  }

  @override
  Widget build(BuildContext context) {
    user = BlocProvider.of<ProfileBloc>(context).user;
    // if ((widget.currentPage == 2 || widget.currentPage == 1 || widget.currentPage == 4) && proverka == true) {
    //   if (isTask == false) {
    //     type = 2;
    //     state = true;
    //   }
    //   proverka = false;
    // }

    double widthTabBarItem = (MediaQuery.of(context).size.width - 40.w) / 2;
    double bottomInsets = MediaQuery.of(context).viewInsets.bottom;
    return MediaQuery(
      data: const MediaQueryData(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: ColorStyles.whiteFFFFFF,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 60.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Row(
                    children: [
                      CustomIconButton(
                        onBackPressed: () {
                          if (page == 0) {
                            Navigator.of(context).pop();
                          } else {
                            pageController.animateToPage(0,
                                duration: const Duration(milliseconds: 600),
                                curve: Curves.easeInOut);
                          }
                        },
                        icon: SvgImg.arrowRight,
                      ),
                      SizedBox(width: 12.w),
                      if (isTask)
                        Text(
                          'creating_a_task'.tr(),
                          style: CustomTextStyle.black_22_w700,
                        ),
                      if (!isTask)
                        Text(
                          'creating_an_offer'.tr(),
                          style: CustomTextStyle.black_22_w700,
                        ),
                      Text(
                        ' ${page + 1}/2',
                        style: CustomTextStyle.grey_22_w700,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Container(
                    height: 40.h,
                    decoration: BoxDecoration(
                      color: ColorStyles.greyE0E6EE,
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Stack(
                      children: [
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 100),
                          alignment: type == 1
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          child: Container(
                            height: 40.h,
                            width: widthTabBarItem,
                            decoration: BoxDecoration(
                              color: ColorStyles.yellowFFD70A,
                              borderRadius: BorderRadius.only(
                                topLeft: !state
                                    ? Radius.circular(20.r)
                                    : Radius.zero,
                                bottomLeft: !state
                                    ? Radius.circular(20.r)
                                    : Radius.zero,
                                topRight:
                                    state ? Radius.circular(20.r) : Radius.zero,
                                bottomRight:
                                    state ? Radius.circular(20.r) : Radius.zero,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (type != 1) {
                                      Future.delayed(
                                        const Duration(milliseconds: 50),
                                        (() {
                                          setState(() {
                                            isTask = true;
                                            state = !state;
                                          });
                                        }),
                                      );
                                    }
                                    type = 1;
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text('as_a_customer'.tr(),
                                        style: CustomTextStyle
                                            .black_14_w400_171716),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (type != 2) {
                                      Future.delayed(
                                        const Duration(milliseconds: 50),
                                        (() {
                                          setState(() {
                                            isTask = false;
                                            state = !state;
                                          });
                                        }),
                                      );
                                    }
                                    type = 2;
                                  });
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Center(
                                    child: Text(
                                      'as_an_executor'.tr(),
                                      style:
                                          CustomTextStyle.black_14_w400_171716,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24.h),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      page = value;
                      setState(() {});
                    },
                    children: [
                      CategorySelector(
                        bottomInsets: bottomInsets,
                        onAttach: () => onAttach(),
                        document: documents,
                        selectCategory: selectCategory ?? widget.selectCategory,
                        selectSubCategory: selectSubCategory,
                        titleController: titleController,
                        aboutController: aboutController,
                        onEdit: (cat, subCat, title, about) {
                          selectCategory = cat;
                          selectSubCategory = subCat;
                        },
                        removefiles: (photoIndex, documentIndex) {
                          if (photoIndex != null) {
                            documents.removeAt(photoIndex);
                          }
                          if (documentIndex != null) {
                            documents.removeAt(documentIndex);
                          }

                          setState(() {});
                        },
                        customer: isTask,
                      ),
                      DatePicker(
                        isTask: isTask,
                        bottomInsets: bottomInsets,
                        coastMaxController: coastMaxController,
                        coastMinController: coastMinController,
                        startDate: startDate,
                        endDate: endDate,
                        allCountries: countries,
                        isGraded: false,
                        currecy: currency,
                        onEdit: (startDate, endDate, countries, currency,
                            isGraded) {
                          this.startDate = startDate;
                          this.endDate = endDate;
                          this.countries = countries;
                          this.currency = currency;
                          setState(() {});
                        },
                        saveTask: createTask,
                        isCreating: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20.w, right: 20.w, bottom: 60.h),
                  child: CustomButton(
                    onTap: () async {
                      if (page == 1) {
                        createTask(false);
                      } else {
                        String error = 'specify'.tr();
                        bool errorsFlag = false;

                        if (selectCategory == null) {
                          error += '\n-  ${'category'.tr().toLowerCase()}';
                          errorsFlag = true;
                        }
                        if (selectSubCategory == null) {
                          error += '\n- ${'subcategory'.tr().toLowerCase()}';
                          errorsFlag = true;
                        }
                        if (titleController.text.isEmpty) {
                          error += '\n- ${'names'.tr()}';
                          errorsFlag = true;
                        }
                        if (aboutController.text.isEmpty) {
                          error += '\n- ${'description'.tr().toLowerCase()}';
                          errorsFlag = true;
                        }

                        if (errorsFlag) {
                          CustomAlert().showMessage(error);
                        } else {
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 600),
                            curve: Curves.easeInOut,
                          );
                        }
                      }
                    },
                    btnColor: ColorStyles.yellowFFD70A,
                    textLabel: Text(
                      page == 0
                          ? 'further'.tr()
                          : isTask
                              ? 'сreate_a_task'.tr()
                              : 'create_offer'.tr(),
                      style: CustomTextStyle.black_16_w600_171716,
                    ),
                  ),
                ),
              ],
            ),
            if (bottomInsets > MediaQuery.of(context).size.height / 3)
              Positioned(
                bottom: bottomInsets,
                child: Container(
                  height: 60.h,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      const Spacer(),
                      CupertinoButton(
                        onPressed: () => FocusScope.of(context).unfocus(),
                        child: Text(
                          'done'.tr(),
                          style: CustomTextStyle.black_empty,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
