import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:just_do_it/constants/colors.dart';
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
          Expanded(
            child: page == 0 ? firstStage() : secondStage(),
          ),
          SizedBox(height: 10.h),
          CustomButton(
            onTap: () {
              if (page == 0) {
                page = 1;
                widget.stage(2);
              } else {
                Navigator.of(context).pushNamed(AppRoute.confirmCode);
              }
            },
            btnColor: yellow,
            textLabel: Text(
              page == 0 ? 'Далее' : 'Зарегистрироваться',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF171716),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          CustomButton(
            onTap: () {
              if (page == 1) {
                page = 0;
                widget.stage(1);
              } else {
                Navigator.of(context).pop();
              }
            },
            btnColor: const Color(0xFFE0E6EE),
            textLabel: Text(
              'Назад',
              style: TextStyle(
                color: const Color(0xFF515150),
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 34.h),
        ],
      ),
    );
  }

  Widget firstStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: '   Ваше имя',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Ваша фамилия',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 30.h),
        Row(
          children: [
            Text(
              'Ваш пол',
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
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
        SizedBox(height: 30.h),
        CustomTextField(
          hintText: '   Номер телефона',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   E-mail',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
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
                : const Icon(Icons.remove_red_eye),
          ),
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
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
                : const Icon(Icons.remove_red_eye),
          ),
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Checkbox(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.r)),
              value: true,
              onChanged: (value) {},
              checkColor: Colors.black,
              activeColor: yellow,
            ),
            Flexible(
              child: Text(
                'Согласен на обработку персональных данных и с пользовательским соглашением',
                textAlign: TextAlign.justify,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF515150),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 23.h),
      ],
    );
  }

  Widget secondStage() {
    return ListView(
      addAutomaticKeepAlives: false,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      children: [
        CustomTextField(
          hintText: '   Добавить фото',
          height: 50.h,
          suffixIcon: Stack(
            alignment: Alignment.centerRight,
            children: [
              Padding(
                padding: EdgeInsets.only(right: 16.h),
                child: SvgPicture.asset(
                  'assets/icons/gallery.svg',
                  height: 15.h,
                  width: 15.h,
                ),
              ),
            ],
          ),
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Регион',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
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
            key: iconBtn,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                key: iconBtn,
                hintText: '   Тип документа',
                height: 50.h,
                enabled: false,
                onTap: () {},
                textEditingController:
                    TextEditingController(text: '   Тип документа'),
              ),
              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/icons/arrow_bottom.svg',
                      width: 16.h,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if (additionalInfo) additionalInfoWidget(),
        SizedBox(height: 16.h),
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
            key: iconBtnCategory,
            alignment: Alignment.centerRight,
            children: [
              CustomTextField(
                hintText: '   Выбор до 3ех категорий',
                height: 50.h,
                enabled: false,
                onTap: () {},
                textEditingController:
                    TextEditingController(text: '   Дизайн, ремонт, доставка'),
              ),
              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.h),
                    child: SvgPicture.asset(
                      'assets/icons/arrow_right.svg',
                      height: 18.h,
                      width: 18.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          height: 130.h,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Stack(
            alignment: Alignment.topLeft,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: 18.h, right: 18.h, top: 18.h, bottom: 30.h),
                child: SizedBox(
                  height: 100.h,
                  child: TextFormField(
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {});
                    },
                    inputFormatters: [LengthLimitingTextInputFormatter(250)],
                    controller: experienceController,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.zero,
                      border: InputBorder.none,
                      hintText: 'Описание своего опыта',
                      hintStyle: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 12.sp,
                        color: const Color(0xFFBDBDBD),
                        fontWeight: FontWeight.w400,
                      ),
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
                      overflow: TextOverflow.ellipsis,
                      fontSize: 10.sp,
                      color: const Color(0xFFBDBDBD),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 11.h),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 14.h,
                    width: 14.h,
                    child: SvgPicture.asset('assets/icons/add_circle.svg'),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Изображения',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(width: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 9.h, vertical: 11.h),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 14.h,
                    width: 14.h,
                    child: SvgPicture.asset('assets/icons/document_text.svg'),
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Загрузить резюме (10мб)',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w400,
                    ),
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
      padding: EdgeInsets.zero,
      children: [
        SizedBox(height: 16.h),
        Row(
          children: [
            CustomTextField(
              hintText: '   Серия',
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 40) / 100 - 6.w,
              textEditingController: TextEditingController(),
            ),
            SizedBox(width: 12.w),
            CustomTextField(
              hintText: '   Номер',
              height: 50.h,
              width:
                  ((MediaQuery.of(context).size.width - 48.w) * 60) / 100 - 6.w,
              textEditingController: TextEditingController(),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Кем выдан',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
        SizedBox(height: 16.h),
        CustomTextField(
          hintText: '   Дата выдачи',
          height: 50.h,
          textEditingController: TextEditingController(),
        ),
      ],
    );
  }
}
