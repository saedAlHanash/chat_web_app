import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/app_widget.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:drawable_text/drawable_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_multi_type/image_multi_type.dart';

import 'get_chats_rooms_bloc/get_rooms_cubit.dart';

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
  Future<void> openRoom(
    BuildContext context,
  ) async {
    roomMessage = await Hive.openBox<String>(widget.room.id);
    if (context.mounted) {
      context.read<GetRoomsCubit>().state.stream?.pause();

      openRoomFunction(context, widget.room).then((value) {
        print('sa_____________________________________________________________');
        roomMessage.close();
        context.read<GetRoomsCubit>().state.stream?.resume();
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () => openRoom(context),
      child: Container(
        height: MediaQuery.of(context).size.height / 6,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.1,
                blurRadius: 8,
                offset: const Offset(0, 10), // changes position of shadow
              ),
            ],
          borderRadius: BorderRadius.circular(12.0),
          color: Colors.white
        ),
        margin:
            EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height / 162.4),
        child: Row(children: [
          Container(
              width: MediaQuery.of(context).size.width / 6,
              height: MediaQuery.of(context).size.width / 6,
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(3.0),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.white),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.1,
                    blurRadius: 8,
                    offset: const Offset(0, 10), // changes position of shadow
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: ImageMultiType(url: getChatMember(widget.room.users).imageUrl)),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getChatMember(widget.room.users).lastName ?? '',
                style: const TextStyle(
                    color: Color(0xFF565C63), fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                widget.room.lastMessages?.first.status?.name ?? '',
                style: const TextStyle(color: Color(0xFFA0A0A0), fontSize: 16),
              ),
              const Divider(),
              DrawableText(
                  color: Colors.grey,
                  size: 12.0,
                  text: DateTime.fromMillisecondsSinceEpoch(
                          widget.room.updatedAt ?? DateTime.now().millisecond)
                      .formatDuration())
            ],
          ),
          if (widget.room.isNotReed) ...[
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(
                Icons.circle,
                color: mainColor,
              ),
            )
          ]
        ]),
      ),
    );
  }
}

Future<void> openRoomFunction(BuildContext context, Room room) async {
  roomMessage = await Hive.openBox<String>(room.id);
  if (context.mounted) {
    context.read<GetRoomsCubit>().state.stream?.pause();
    // return await Get.toNamed(
    //   Routes.fireChat,
    //   arguments: {
    //     'room': room,
    //     'name': getChatMember(room.users).lastName ?? '',
    //   },
    // );
  }
}
