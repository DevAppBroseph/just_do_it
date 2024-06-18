import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/models/question.dart';
import 'package:just_do_it/models/user_reg.dart';
import 'package:just_do_it/network/repository.dart';
import 'package:just_do_it/widget/back_icon_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutProject extends StatefulWidget {
  const AboutProject({super.key});

  @override
  State<AboutProject> createState() => _AboutProjectState();
}

class _AboutProjectState extends State<AboutProject> {
  About? about;
  int? selectIndex;
  late UserRegModel? user;
  @override
  void initState() {
    super.initState();
    user = BlocProvider.of<ProfileBloc>(context).user;
    getQuestions();
  }

  void getQuestions() async {
    about = await Repository().aboutList();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
      data: const MediaQueryData(textScaler: TextScaler.linear(1.0)),
      child: Scaffold(
        backgroundColor: LightAppColors.whitePrimary,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    SizedBox(height: 80.h),
                    Padding(
                      padding: EdgeInsets.only(left: 25.w, right: 28.w),
                      child: SizedBox(
                        height: 35.h,
                        child: Stack(
                          alignment: Alignment.centerLeft,
                          children: [
                            CustomIconButton(
                              onBackPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: SvgImg.arrowRight,
                              color: LightAppColors.greySecondary,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'about_the_project'.tr(),
                                  style: CustomTextStyle.sf22w700(
                                      LightAppColors.blackSecondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h)
                  ],
                ),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    children: [
                      Container(
                        color: LightAppColors.yellowPrimary,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 40.h),
                            Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 50.w),
                                  child: Center(
                                    child: Text('jobyfine'.toUpperCase(),
                                        style: CustomTextStyle.sf22w700(
                                                LightAppColors.blackPrimary)
                                            .copyWith(
                                          fontSize: 39,
                                          fontWeight: FontWeight.w900,
                                          fontFamily: 'SFBold',
                                        )),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 40.h),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 40.w),
                              child: Text(
                                user?.rus ??
                                        true &&
                                            context.locale.languageCode == 'ru'
                                    ? about?.about ?? ''
                                    : about?.aboutEng ?? '',
                                style: CustomTextStyle.sf17w400(
                                    LightAppColors.blackAccent),
                              ),
                            ),
                            SizedBox(height: 40.h),
                          ],
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: Text(
                          'question_and_answer'.tr(),
                          style: CustomTextStyle.sf22w700(
                              LightAppColors.blackSecondary),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      if (about != null)
                        ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: about!.question.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: itemQuestion(
                                index,
                                user?.rus ??
                                        true &&
                                            context.locale.languageCode == 'ru'
                                    ? about!.question[index].question
                                    : about!.question[index].questionEng,
                                user?.rus ??
                                        true &&
                                            context.locale.languageCode == 'ru'
                                    ? about!.question[index].answer
                                    : about!.question[index].answerEng,
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 20.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: GestureDetector(
                          onTap: () async {
                            launch(user?.rus ??
                                    true && context.locale.languageCode == 'ru'
                                ? server + about!.confidence
                                : server + about!.confidenceEng);
                            // if (res != null) await OpenFile.open(server + res);
                          },
                          child: Text(
                            "user_agreement".tr(),
                            style: CustomTextStyle.sf17w400(
                                    LightAppColors.blueSecondary)
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40.w),
                        child: GestureDetector(
                          onTap: () async {
                            launch(user?.rus ??
                                    true && context.locale.languageCode == 'ru'
                                ? server + about!.agreement
                                : server + about!.agreementEng);
                          },
                          child: Text(
                            "consent_to_the_processing_of_personal_data".tr(),
                            style: CustomTextStyle.sf17w400(
                                    LightAppColors.blueSecondary)
                                .copyWith(decoration: TextDecoration.underline),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 40.w,
                          vertical: 27.w,
                        ),
                        child: Row(
                          children: [
                            Text(
                              '${'app_version'.tr()}: ',
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                            const Flexible(
                              child: Text(
                                appVersion,
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 175.h),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> itemQuestion(int index, String question, String answer) {
    return [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        child: GestureDetector(
          onTap: () {
            if (selectIndex == index) {
              selectIndex = null;
            } else {
              selectIndex = index;
            }
            setState(() {});
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  question,
                  textAlign: TextAlign.start,
                  style:
                      CustomTextStyle.sf17w600(LightAppColors.blackSecondary),
                ),
              ),
              selectIndex == index
                  ? const Icon(
                      Icons.keyboard_arrow_up,
                      color: LightAppColors.blueSecondary,
                    )
                  : const Icon(
                      Icons.keyboard_arrow_down,
                      color: LightAppColors.greyActive,
                    ),
            ],
          ),
        ),
      ),
      SizedBox(height: 10.h),
      AnimatedContainer(
        height: selectIndex != null
            ? selectIndex == index
                ? answer.length > 200
                    ? question != 'Для кого это приложение?'
                        ? 187.h
                        : 160.h
                    : 120.h
                : 0
            : 0,
        padding: EdgeInsets.symmetric(horizontal: 40.w),
        duration: const Duration(milliseconds: 300),
        child: Text(
          answer,
          style: CustomTextStyle.sf17w400(LightAppColors.blackAccent),
        ),
      ),
      SizedBox(height: 10.h),
    ];
  }
}
