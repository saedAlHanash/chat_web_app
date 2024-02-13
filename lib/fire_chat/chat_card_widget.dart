import 'dart:convert';

import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/fire_chat/chat.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/messages_bloc/messages_cubit.dart';
import 'package:chat_web_app/fire_chat/rooms_bloc/rooms_cubit.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_multi_type/circle_image_widget.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../../generated/assets.dart';
import '../api_manager/api_url.dart';
import '../main.dart';

String selectedId = '';

class ChatCardWidget extends StatefulWidget {
  const ChatCardWidget({
    super.key,
    required this.room,
  });

  final Room room;

  @override
  State<ChatCardWidget> createState() => _ChatCardWidgetState();
}

class _ChatCardWidgetState extends State<ChatCardWidget> {
  Widget get latestMessage {
    final json = boxes.latestMessagesBox?.get(widget.room.id) ?? '{}';

    if (json == '{}') {
      return const SizedBox();
    }

    final message = Message.fromJson(jsonDecode(json));
    switch (message.type) {
      case MessageType.file:
        return DrawableText(
          maxLines: 1,
          size: 14.0.sp,
          text: 'ملف',
          drawableEnd: const ImageMultiType(url: Icons.file_copy),
        );
      case MessageType.image:
        return DrawableText(
          maxLines: 1,
          size: 14.0.sp,
          text: 'صورة',
          drawableEnd: const ImageMultiType(url: Icons.image),
        );
      case MessageType.video:
        return DrawableText(
          maxLines: 1,
          size: 14.0.sp,
          text: 'فيديو',
          drawableEnd: const ImageMultiType(url: Icons.videocam_rounded),
        );
      case MessageType.text:
        return DrawableText(
          maxLines: 1,
          size: 14.0.sp,
          text: (message as TextMessage).text,
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
    return InkWell(
      onTap: selectedId == widget.room.id
          ? null
          : () async {
              selectedId = widget.room.id;
              context.read<RoomsCubit>().selectRoom(widget.room.id);
              await context.read<MessagesCubit>().reInitial(widget.room);
              if (mounted) {
                context.read<MessagesCubit>().getChatRoomMessage(widget.room);
              }

              setState(() {});
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0).w,
        color: widget.room.id == selectedId ? const Color(0xFFF3F0F0) : null,
        child: Row(
          children: [
            CircleImageWidget(
              size: 50.0.r,
              url: getChatMember(widget.room.users).firstName ==
                      '${isTestDomain ? 'test' : ''}0'
                  ? Assets.assetsLogo
                  : '$baseImageUrl${getChatMember(widget.room.users).imageUrl?.replaceAll(baseImageUrl, '')}',
            ),
            10.horizontalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DrawableText(
                  maxLines: 1,
                  size: 14.0.sp,
                  text: getChatMember(widget.room.users).lastName ?? '',
                ),
                latestMessage,
              ],
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DrawableText(
                  maxLines: 1,
                  size: 14.0.sp,
                  text: DateTime.fromMillisecondsSinceEpoch(
                    widget.room.updatedAt ?? DateTime.now().millisecond,
                  ).formatDate,
                  color: const Color(0xff8E8E93),
                ),
                if (widget.room.isNotReed)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Icon(
                      Icons.circle,
                      size: 18.0.r,
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
    );
  }
}

Future<void> openRoomFunction(BuildContext context, Room room) async {
  boxes.messageBox = await Hive.openBox<String>(room.id);

  if (context.mounted) {
    context.read<RoomsCubit>().state.stream?.pause();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => MessagesCubit()..getChatRoomMessage(room),
              ),
            ],
            child: ChatPage(
              room: room,
              name: getChatMember(room.users).lastName ?? '',
            ),
          );
        },
      ),
    );
    await boxes.messageBox?.close();
    if (context.mounted) {
      context.read<RoomsCubit>().state.stream?.resume();
    }

    return;
  }
}
