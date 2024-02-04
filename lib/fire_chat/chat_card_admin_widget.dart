import 'dart:convert';

import 'package:chat_web_app/fire_chat/chat_card_widget.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/src/chat_theme.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/circle_image_widget.dart';
import 'package:image_multi_type/image_multi_type.dart';
import 'package:image_multi_type/round_image_widget.dart';

import '../generated/assets.dart';
import 'get_chats_rooms_bloc/get_rooms_cubit.dart';

class ChatCardAdminWidget extends StatefulWidget {
  final Room room;

  const ChatCardAdminWidget({
    super.key,
    required this.room,
  });

  @override
  State<ChatCardAdminWidget> createState() => _ChatCardAdminWidgetState();
}

class _ChatCardAdminWidgetState extends State<ChatCardAdminWidget> {
  Future<void> openRoom(
    BuildContext context,
  ) async {
    if (context.mounted) {
      context.read<GetRoomsCubit>().state.stream?.pause();
      openRoomFunction(context, widget.room).then((value) => setState(() {}));
    }
  }

  Widget get latestMessage {
    final json = latestMessagesBox.get(widget.room.id) ?? '{}';

    if (json == '{}') {
      return const SizedBox();
    }

    final message = Message.fromJson(jsonDecode(json));
    switch (message.type) {
      case MessageType.file:
        return const DrawableText(
          text: 'ملف',
          drawableEnd: ImageMultiType(url: Icons.file_copy),
        );
      case MessageType.image:
        return const DrawableText(
          text: 'صورة',
          drawableEnd: ImageMultiType(url: Icons.image),
        );
      case MessageType.video:
        return const DrawableText(
          text: 'فيديو',
          drawableEnd: ImageMultiType(url: Icons.videocam_rounded),
        );
      case MessageType.text:
        return DrawableText(
          text: (message as TextMessage).text,
          maxLines: 1,
          size: 12.sp,
          color: Colors.grey,
        );
      case MessageType.audio:
      case MessageType.custom:
      case MessageType.system:
      case MessageType.unsupported:
    }
    return const SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: InkWell(
        onTap: () => openRoom(context),
        child: SizedBox(
          height: 150.0.h,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0).r,
            child: Row(
              children: [
                CircleImageWidget(
                  size: 150.0.r,
                  url: getChatMember(widget.room.users).firstName == '0'
                      ? Assets.assetsLogo
                      : '$baseImageUrl${getChatMember(widget.room.users).imageUrl}',
                ),
                30.0.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    DrawableText(
                      text: widget.room.users.first.lastName.toString(),
                      size: 12.0.sp,
                      drawableStart: ImageMultiType(
                        url: Icons.person,
                        color: Colors.black,
                        height: 22.0.r,
                        width: 22.0.r,
                      ),
                    ),
                    DrawableText(
                      text: widget.room.users.last.lastName.toString(),
                      size: 12.0.sp,
                      drawableStart: ImageMultiType(
                        url: Icons.person,
                        color: primary,
                        height: 22.0.r,
                        width: 22.0.r,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DrawableText(
                      text: DateTime.fromMillisecondsSinceEpoch(
                        widget.room.updatedAt ?? DateTime.now().millisecond,
                      ).formatDate,
                      color: const Color(0xff8E8E93),
                      size: 12.0.sp,
                    ),
                    if (widget.room.isNotReed)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Icon(
                          Icons.circle,
                          size: 30.0.r,
                          color: const Color(0xffFF6905),
                        ),
                      )
                  ],
                ),
                25.0.horizontalSpace,
                ImageMultiType(
                  url: Icons.arrow_forward_ios_outlined,
                  height: 30.0.r,
                  width: 30.0.r,
                  color: Colors.grey.withOpacity(0.3),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
