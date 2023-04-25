import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/core/utils/toasts.dart';
import 'package:just_do_it/feature/auth/widget/widgets.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/bloc_tasks/bloc_tasks.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/category.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/date.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class CeateTasks extends StatefulWidget {
  Activities? selectCategory;
  bool customer;
  bool doublePop;
  CeateTasks({
    super.key,
    this.selectCategory,
    required this.customer,
    this.doublePop = false,
  });

  @override
  State<CeateTasks> createState() => _CeateTasksState();
}

class _CeateTasksState extends State<CeateTasks> {
  final PageController pageController = PageController();
  PanelController panelController = PanelController();
  int page = 0;

  TextEditingController aboutController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();

  File? document;
  File? photo;

  String? region;

  Activities? selectCategory;
  Subcategory? selectSubCategory;

  DateTime? startDate;
  DateTime? endDate;

  _selectImage() async {
    final getMedia = await ImagePicker().getImage(source: ImageSource.gallery);
    if (getMedia != null) {
      photo = File(getMedia.path);
    }
    setState(() {});
  }

  _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (result != null) {
      document = File(result.files.first.path!);
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
                    'Выберите что загрузить',
                    style: CustomTextStyle.black_16_w600_171716,
                  ),
                  ListTile(
                    title: Text(
                      'Фото',
                      style: CustomTextStyle.black_14_w400_292D32,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectImage();
                    },
                  ),
                  ListTile(
                    title: Text(
                      'Документ',
                      style: CustomTextStyle.black_14_w400_292D32,
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                      _selectFile();
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
    selectCategory = widget.selectCategory;
    if (widget.selectCategory != null) {
      for (var element in widget.selectCategory!.subcategory) {
        if (widget.selectCategory!.selectSubcategory
            .contains(element.description)) {
          selectSubCategory = element;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    log('message ${widget.customer}');
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
                      Text(
                        'Создание задания',
                        style: CustomTextStyle.black_22_w700,
                      ),
                      Text(
                        ' ${page + 1}/2',
                        style: CustomTextStyle.grey_22_w700,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 50.h),
                Expanded(
                  child: PageView(
                    controller: pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (value) {
                      page = value;
                      setState(() {});
                    },
                    children: [
                      Category(
                        bottomInsets: bottomInsets,
                        onAttach: () => onAttach(),
                        document: document,
                        photo: photo,
                        selectCategory: selectCategory ?? widget.selectCategory,
                        selectSubCategory: selectSubCategory,
                        titleController: titleController,
                        aboutController: aboutController,
                        onEdit: (cat, subCat, title, about) {
                          selectCategory = cat;
                          selectSubCategory = subCat;
                        },
                        removefiles: (photo, document) {
                          this.photo = photo;
                          this.document = document;
                          setState(() {});
                        },
                      ),
                      DatePicker(
                        bottomInsets: bottomInsets,
                        coastMaxController: coastMaxController,
                        coastMinController: coastMinController,
                        startDate: startDate,
                        endDate: endDate,
                        selectRegion: region,
                        onEdit: (region, startDate, endDate) {
                          this.region = region;
                          this.startDate = startDate;
                          this.endDate = endDate;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(left: 20.w, right: 20.w, bottom: 20.h),
                  child: CustomButton(
                    onTap: () async {
                      if (page == 1) {
                        String error = 'Укажите:';
                        bool errorsFlag = false;

                        if (startDate == null) {
                          error += '\n- дату начала';
                          errorsFlag = true;
                        }
                        if (startDate == null) {
                          error += '\n- дату завершения';
                          errorsFlag = true;
                        }
                        if (coastMinController.text.isEmpty) {
                          error += '\n- минимальную цену';
                          errorsFlag = true;
                        }
                        if (coastMaxController.text.isEmpty) {
                          error += '\n- максимальную цену';
                          errorsFlag = true;
                        }
                        if (region == null || region!.isEmpty) {
                          error += '\n- регион';
                          errorsFlag = true;
                        }

                        if (coastMinController.text.isNotEmpty &&
                            coastMaxController.text.isNotEmpty) {
                          if (int.parse(coastMinController.text) >
                              int.parse(coastMaxController.text)) {
                            error +=
                                '\n- минимальный бюджет должен быть меньше максимального';
                            errorsFlag = true;
                          }
                        }

                        if (errorsFlag) {
                          showAlertToast(error);
                        } else {
                          showLoaderWrapper(context);

                          Task newTask = Task(
                            asCustomer: widget.customer,
                            name: titleController.text,
                            description: aboutController.text,
                            subcategory: selectSubCategory!,
                            dateStart:
                                DateFormat('yyyy-MM-dd').format(startDate!),
                            dateEnd: DateFormat('yyyy-MM-dd').format(endDate!),
                            priceFrom: int.parse(
                              coastMinController.text.isEmpty
                                  ? '0'
                                  : coastMinController.text,
                            ),
                            priceTo: int.parse(
                              coastMaxController.text.isEmpty
                                  ? '0'
                                  : coastMaxController.text,
                            ),
                            region: region ?? '',
                            file: null,
                            icon: '',
                            task: '',
                            typeLocation: '',
                            whenStart: '',
                            coast: '',
                            search: '',
                          );
                          final profileBloc =
                              BlocProvider.of<ProfileBloc>(context);
                          bool res = await Repository()
                              .createTask(profileBloc.access!, newTask);
                          if (res) {
                            if (widget.doublePop) {
                              Navigator.of(context)
                                ..pop()
                                ..pop();
                              final access =
                                  BlocProvider.of<ProfileBloc>(context).access;
                              context.read<TasksBloc>().add(
                                    GetTasksEvent(
                                      access: access,
                                      query: '',
                                      dateEnd: '',
                                      dateStart: '',
                                      priceFrom: 0,
                                      priceTo: 50000000,
                                      region: [],
                                      subcategory: [],
                                      countFilter: null,
                                      customer: null,
                                    ),
                                  );
                            } else {
                              Navigator.of(context).pop();
                            }
                            BlocProvider.of<TasksBloc>(context)
                                .add(GetTasksEvent());
                          }
                          Loader.hide();
                        }
                      } else {
                        String error = 'Укажите:';
                        bool errorsFlag = false;

                        if (selectCategory == null) {
                          error += '\n- категорию';
                          errorsFlag = true;
                        }
                        if (selectSubCategory == null) {
                          error += '\n- подкатегорию';
                          errorsFlag = true;
                        }
                        if (titleController.text.isEmpty) {
                          error += '\n- название';
                          errorsFlag = true;
                        }
                        if (aboutController.text.isEmpty) {
                          error += '\n- описание';
                          errorsFlag = true;
                        }

                        if (errorsFlag) {
                          showAlertToast(error);
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
                      page == 0 ? 'Далее' : 'Создать заказ',
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
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.grey[200],
                  child: Row(
                    children: [
                      const Spacer(),
                      CupertinoButton(
                        onPressed: () => FocusScope.of(context).unfocus(),
                        child: const Text(
                          'Готово',
                          style: TextStyle(color: Colors.black),
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
