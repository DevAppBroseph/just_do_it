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
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/category.dart';
import 'package:just_do_it/feature/home/presentation/tasks/view/create_task/widgets/date.dart';
import 'package:just_do_it/models/countries.dart';
import 'package:just_do_it/models/task.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class EditTasks extends StatefulWidget {
  Task task;
  EditTasks({
    super.key,
    required this.task,
  });

  @override
  State<EditTasks> createState() => _EditTasksState();
}

class _EditTasksState extends State<EditTasks> {
  final PageController pageController = PageController();
  PanelController panelController = PanelController();
  int page = 0;

  TextEditingController aboutController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  TextEditingController coastMinController = TextEditingController();
  TextEditingController coastMaxController = TextEditingController();

  File? document;
  File? photo;

  Regions? region;

  Activities? selectCategory;
  Subcategory? selectSubCategory;

  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    selectCategory = widget.task.activities;
    selectSubCategory = widget.task.subcategory;
    aboutController.text = widget.task.description;
    titleController.text = widget.task.name;
    coastMinController.text = widget.task.priceFrom.toString();
    coastMaxController.text = widget.task.priceTo.toString();
    final splitStartDate = widget.task.dateStart.split('-');
    startDate = DateTime(int.parse(splitStartDate[0]),
        int.parse(splitStartDate[1]), int.parse(splitStartDate[2]));
    final splitEndDate = widget.task.dateEnd.split('-');
    endDate = DateTime(int.parse(splitEndDate[0]), int.parse(splitEndDate[1]),
        int.parse(splitEndDate[2]));
    region = widget.task.regions;
    log('message ${widget.task.toJson()}');

    // if (widget.selectCategory != null) {
    //   for (var element in widget.selectCategory!.subcategory) {
    //     if (widget.selectCategory!.selectSubcategory
    //         .contains(element.description)) {
    //       selectSubCategory = element;
    //     }
    //   }
    // }
  }

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
  Widget build(BuildContext context) {
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
                        'Редактирование',
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
                        selectCategory:
                            selectCategory ?? widget.task.activities,
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
                          this.region = region as Regions?;
                          this.startDate = startDate;
                          this.endDate = endDate;
                        },
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                        if (region == null ) {
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
                            id: widget.task.id,
                            asCustomer: widget.task.asCustomer,
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
                            regions:  region,
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
                              .editTask(profileBloc.access!, newTask);
                          if (res) Navigator.of(context)..pop()..pop();
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
                      page == 0 ? 'Далее' : 'Редактировать задание',
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
