import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/feature/auth/widget/button.dart';
import 'package:just_do_it/feature/auth/widget/drop_down.dart';
import 'package:just_do_it/feature/auth/widget/radio.dart';
import 'package:just_do_it/feature/auth/widget/textfield.dart';
import 'package:just_do_it/helpers/router.dart';

class Contractor extends StatefulWidget {
  Function(int) stage;

  Contractor(this.stage);
  @override
  State<Contractor> createState() => _ContractorState();
}

class _ContractorState extends State<Contractor> {
  GlobalKey iconBtn = GlobalKey();
  GlobalKey iconBtnCategory = GlobalKey();
  TextEditingController experienceController = TextEditingController();

  int groupValue = 0;
  int page = 0;
  bool visiblePassword = false;
  bool visiblePasswordRepeat = false;
  bool additionalInfo = false;

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Column(
        children: [
          SizedBox(height: 15.h),
          Expanded(
            child: page == 0 ? firstStage() : secondStage(),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            onTap: () {
              if (page == 0) {
                page = 1;
                widget.stage(2);
              } else {
                Navigator.of(context).pushNamed(AppRoute.confirmCode);
              }
            },
            btnColor: Colors.yellow[600]!,
            textLabel: Text(
              page == 0 ? 'Далее' : 'Зарегистрироваться',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CustomButton(
            onTap: () {
              if (page == 1) {
                page = 0;
                widget.stage(1);
              } else {
                Navigator.of(context).pop();
              }
            },
            btnColor: Colors.grey[200]!,
            textLabel: Text(
              'Назад',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget firstStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: '   Ваше имя',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Ваша фамилия',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Text(
              'Ваш пол',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = 0;
                });
              },
              child: CustomCircleRadioButtonItem(
                label: 'Муж.',
                value: 0,
                groupValue: groupValue,
              ),
            ),
            SizedBox(width: 15.w),
            GestureDetector(
              onTap: () {
                setState(() {
                  groupValue = 1;
                });
              },
              child: CustomCircleRadioButtonItem(
                label: 'Жен.',
                value: 1,
                groupValue: groupValue,
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Номер телефона',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   E-mail',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Пароль',
          height: 50.h,
          suffixIcon: GestureDetector(
              onTap: () {
                visiblePassword = !visiblePassword;
                setState(() {});
              },
              child: visiblePassword
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : const Icon(Icons.remove_red_eye)),
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Повторите пароль',
          height: 50.h,
          suffixIcon: GestureDetector(
              onTap: () {
                visiblePasswordRepeat = !visiblePasswordRepeat;
                setState(() {});
              },
              child: visiblePasswordRepeat
                  ? const Icon(Icons.remove_red_eye_outlined)
                  : const Icon(Icons.remove_red_eye)),
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: true,
              onChanged: (value) {},
              checkColor: Colors.black,
              activeColor: Colors.yellow[600]!,
            ),
            Flexible(
              child: Text(
                'Согласен на обработку персональных данных и с пользовательским соглашением',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget secondStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Добавить фото',
          height: 50.h,
          suffixIcon: Icon(
            Icons.photo_size_select_actual_outlined,
            color: Colors.grey[400],
          ),
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Регион',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () => showIconModal(
            context,
            iconBtn,
            () {
              additionalInfo = true;
              setState(() {});
            },
            ['Паспорт РФ', 'Заграничный паспорт', 'Резидент ID'],
            'Тип документа',
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: '   Тип документа',
                height: 50.h,
                enabled: false,
                onTap: () {},
                fillColor: Colors.grey[200],
                textEditingController:
                    TextEditingController(text: '   Тип документа'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  key: iconBtn,
                  Icons.keyboard_arrow_down,
                  size: 30,
                  color: Colors.grey[400],
                ),
              )
            ],
          ),
        ),
        if (additionalInfo) additionalInfoWidget(),
        SizedBox(height: 20.h),
        GestureDetector(
          onTap: () => showIconModal(
            context,
            iconBtnCategory,
            () {
              setState(() {});
            },
            ['Дизайн', 'Ремонт', 'Доставка', 'Программирование', 'Видеомонтаж'],
            'Выбор до 3ех категорий',
          ),
          child: Stack(
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: '   Выбор до 3ех категорий',
                height: 50.h,
                enabled: false,
                onTap: () {},
                fillColor: Colors.grey[200],
                textEditingController:
                    TextEditingController(text: '   Дизайн, ремонт, доставка'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: Icon(
                  key: iconBtnCategory,
                  Icons.arrow_forward,
                  size: 30,
                  color: Colors.grey[400],
                ),
              )
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Container(
          height: 150.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 20.h, right: 20.h, top: 5.h, bottom: 22.h),
                child: TextFormField(
                  maxLines: null,
                  onChanged: (value) {
                    setState(() {});
                  },
                  inputFormatters: [LengthLimitingTextInputFormatter(250)],
                  controller: experienceController,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Описание своего опыта',
                    hintStyle: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14,
                      color: Colors.grey[400],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15.h, vertical: 15.h),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    '${experienceController.text.length}/250',
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 16.h,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Изображения',
                    style: TextStyle(fontSize: 10.sp),
                  )
                ],
              ),
            ),
            SizedBox(width: 10.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.h),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.drive_folder_upload_outlined,
                    size: 16.h,
                  ),
                  SizedBox(width: 5.w),
                  Text(
                    'Загрузить резюме (10мб)',
                    style: TextStyle(fontSize: 10.sp),
                  )
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 2.h),
        Row(
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: true,
              onChanged: (value) {},
              checkColor: Colors.black,
              activeColor: Colors.yellow[600]!,
            ),
            Flexible(
              child: Text(
                'Юридическое лицо',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget additionalInfoWidget() {
    return ListView(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        SizedBox(height: 20.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomTextField(
              hintText: '   Серия',
              height: 50.h,
              width: ((MediaQuery.of(context).size.width - 40.w) * 40) / 100,
              textEditingController: TextEditingController(),
            ),
            CustomTextField(
              hintText: '   Номер',
              height: 50.h,
              width: ((MediaQuery.of(context).size.width - 40.w) * 55) / 100,
              textEditingController: TextEditingController(),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Кем выдан',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 20.h),
        CustomTextField(
          hintText: '   Дата выдачи',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
      ],
    );
  }
}
