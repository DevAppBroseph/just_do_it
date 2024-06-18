import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:just_do_it/constants/constants.dart';
import 'package:just_do_it/feature/auth/bloc/auth_bloc.dart';
import 'package:just_do_it/feature/home/data/bloc/profile_bloc.dart';
import 'package:just_do_it/feature/home/presentation/chat/presentation/bloc/chat_bloc.dart';
import 'package:just_do_it/feature/home/presentation/tasks/widgets/dialogs.dart';
import 'package:just_do_it/helpers/router.dart';
import 'package:just_do_it/models/chat.dart';
import 'package:scale_button/scale_button.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({super.key, required this.chat});

  final ChatList chat;

  @override
  Widget build(BuildContext context) {
    final user = context.read<ProfileBloc>().user;
    final category = (chat.category != null &&
            context.read<AuthBloc>().categories.isNotEmpty)
        ? context
            .read<AuthBloc>()
            .categories
            .firstWhere((element) => element.description == chat.category)
        : null;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: ScaleButton(
        bound: 0.02,
        onTap: () async {
          if (user!.isBanned!) {
            banDialog(context, 'access_to_chat_is_currently_restricted'.tr());
          } else {
            final chatBloc = BlocProvider.of<ChatBloc>(context);
            chatBloc.editShowPersonChat(false);
            chatBloc.editChatId(chat.id);
            chatBloc.messages = [];
            await Navigator.of(context).pushNamed(
              AppRoute.personalChat,
              arguments: [
                '${chat.id}',
                chat.chatWith != null && chat.chatWith!.firstname!.isEmpty
                    ? ''
                    : '${chat.chatWith?.firstname} ${chat.chatWith?.lastname}',
                '${chat.chatWith?.id}',
                '$server${chat.chatWith?.photo}',
                chat.category,
              ],
            );
            chatBloc.editShowPersonChat(true);
            chatBloc.editChatId(null);
            if (context.mounted) {
              context.read<ChatBloc>().add(GetListMessageItem());
            }
          }
        },
        duration: const Duration(milliseconds: 50),
        child: Container(
          color: Colors.transparent,
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  chat.chatWith?.photo != null
                      ? SizedBox(
                          height: 50.h,
                          width: 50.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.r),
                            child: CachedNetworkImage(
                              imageUrl: '$server${chat.chatWith!.photo}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          height: 50.h,
                          width: 50.h,
                          decoration: BoxDecoration(
                            color: LightAppColors.greyActive,
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                height: 24.h,
                                width: 24.h,
                                child:
                                    SvgPicture.asset('assets/icons/user.svg'),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(width: 12.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: 255.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 180.w,
                                child: AutoSizeText(
                                  chat.chatWith != null &&
                                          chat.chatWith!.firstname!.isEmpty
                                      ? 'Аккаунт удален'
                                      : '${chat.chatWith?.firstname} ${chat.chatWith?.lastname}',
                                  style: CustomTextStyle.sf17w400(
                                      LightAppColors.blackPrimary),
                                  maxLines: 1,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                _textData(chat.lastMsg?.time
                                        ?.toUtc()
                                        .toString()
                                        .substring(0, 10) ??
                                    '-'),
                                style: CustomTextStyle.sf13w400(
                                    LightAppColors.greySecondary),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  chat.lastMsg?.text ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: CustomTextStyle.sf17w400(
                                      LightAppColors.blackSecondary),
                                ),
                              ),
                              if (chat.lastMsg?.unread != null &&
                                  chat.lastMsg!.unread! &&
                                  (user != null &&
                                      user.id != chat.lastMsg?.sender?.id) &&
                                  chat.countUnreadMessage != 0)
                                Container(
                                  height: 15.h,
                                  width: 15.h,
                                  decoration: BoxDecoration(
                                    color: LightAppColors.yellowBackground,
                                    borderRadius: BorderRadius.circular(100.r),
                                  ),
                                  child: Center(
                                    child: Text(
                                      chat.countUnreadMessage?.toString() ?? '',
                                      style: CustomTextStyle.sf11w400(
                                          LightAppColors.whitePrimary),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          SizedBox(height: 8.h),
                          if (chat.category != null) ...[
                            () {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 4),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  // color: Colors.teal,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (category!.photo != null) ...[
                                      SizedBox(
                                          height: 16,
                                          width: 16,
                                          child: Image.network(
                                              server + category.photo!)),
                                    ],
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      user?.rus ??
                                              true &&
                                                  context.locale.languageCode ==
                                                      'ru'
                                          ? category.description ?? '-'
                                          : category.engDescription ?? '-',
                                      style: CustomTextStyle.sf17w400(
                                          LightAppColors.blackSecondary),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              );
                            }()
                          ]
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 18.h),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 1.h,
                      color: LightAppColors.greyAccent,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  String _textData(String data) {
    String text = '';
    String day = '';
    String month = '';
    String year = '';
    List<String> parts = [];
    parts = data.split('-');
    year = parts[0].trim();
    day = parts[2].trim();
    month = parts[1].trim();

    text = '$day.$month.$year';
    return text;
  }
}
