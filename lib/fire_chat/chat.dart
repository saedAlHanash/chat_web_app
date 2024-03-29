import 'dart:convert';
import 'dart:io';

import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/fire_chat/extensions.dart';
import 'package:chat_web_app/fire_chat/messages_bloc/messages_cubit.dart';
import 'package:chat_web_app/fire_chat/src/chat_theme.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'package:mime/mime.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../main.dart';
import '../app_widget.dart';

import 'my_room_object.dart';
import 'src/widgets/chat.dart';
import 'dart:html' as html;

class ChatPage extends StatefulWidget {
  const ChatPage({
    super.key,
    required this.room,
    required this.name,
  });

  final types.Room room;
  final String name;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // late final
  List<types.Message>? initialMessage;

  late final MessagesCubit cubit;

  late final MyRoomObject myRoomObject;

  @override
  void initState() {
    myRoomObject = MyRoomObject(
      roomId: widget.room.id,
      fcmToken: (getChatMember(widget.room.users).metadata ?? {})['fcm'] ?? '',
      fcmTokenWeb: (getChatMember(widget.room.users).metadata ?? {})['fcm_web'] ?? '',
    );
    cubit = context.read<MessagesCubit>();
    super.initState();
  }

  // @override
  // void deactivate() {
  //   if (cubit.state.allMessages.isNotEmpty) {
  //     final m = cubit.state.allMessages.first;
  //     boxes.latestUpdateMessagesBox?.put(cubit.state.roomId, m.updatedAt ?? 0);
  //
  //     var room = types.Room.fromJson(
  //         jsonDecode(boxes.roomsBox?.get(cubit.state.roomId) ?? '{}'));
  //
  //     if (room.updatedAt == m.updatedAt) return;
  //     room = room.copyWith(updatedAt: m.updatedAt);
  //     boxes.roomsBox?.put(cubit.state.roomId, jsonEncode(room));
  //     context.read<GetRoomsCubit>().updateRooms();
  //   }
  //
  //   super.deactivate();
  // }

  bool _isAttachmentUploading = false;

  void _handleAtachmentPressed() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) => SafeArea(
        child: SizedBox(
          height: 144,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(height: 15.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleImageSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Photo'),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _handleFileSelection();
                },
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('File'),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleFileSelection() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.firstOrNull != null) {
      _setAttachmentUploading(true);

      final name = result.files.single.name;

      final fileBytes = result.files.first.bytes;

      if (fileBytes == null) return;
      try {
        final reference = FirebaseStorage.instance.ref(name);

        await reference.putData(fileBytes);

        final uri = await reference.getDownloadURL();

        final message = types.PartialFile(
          mimeType: lookupMimeType(result.files.single.name),
          name: name,
          size: result.files.single.size,
          uri: uri,
        );

        FirebaseChatCore.instance.sendMessage(message, widget.room.id);
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleImageSelection() async {
    final result = await ImagePicker().pickImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );

    if (result != null) {
      _setAttachmentUploading(true);
      final name = result.name;

      final bytes = await result.readAsBytes();

      final image = await decodeImageFromList(bytes);

      try {
        final reference = FirebaseStorage.instance.ref(name);
        await reference.putData(bytes);
        final uri = await reference.getDownloadURL();

        final message = types.PartialImage(
          height: image.height.toDouble(),
          name: name,
          size: bytes.length,
          uri: uri,
          width: image.width.toDouble(),
        );

        FirebaseChatCore.instance.sendMessage(
          message,
          widget.room.id,
        );
        _setAttachmentUploading(false);
      } finally {
        _setAttachmentUploading(false);
      }
    }
  }

  void _handleMessageTap(BuildContext _, types.Message message) async {
    if (message is types.FileMessage) {
      var localPath = message.uri;

      if (message.uri.startsWith('http')) {
        try {
          downloadFile(localPath);
        } finally {}
      }

      await OpenFilex.open(localPath);
    }
  }

  void _handlePreviewDataFetched(
    types.TextMessage message,
    types.PreviewData previewData,
  ) {
    final updatedMessage = message.copyWith(previewData: previewData);

    FirebaseChatCore.instance.updateMessage(updatedMessage, widget.room.id);
  }

  void _handleSendPressed(types.PartialText message) {
    if (myRoomObject.needToSendNotification) {
      sendNotificationMessage(
        myRoomObject,
        ChatNotification(
          body: message.text,
          title: 'رسالة جديدة',
          fcm: myRoomObject.fcmToken,
          fcmWeb: myRoomObject.fcmTokenWeb,
        ),
      ).then(
        (value) {
          if (value) {
            ///for send notification to first message
            myRoomObject.needToSendNotification = false;
          }
        },
      );
    }

    FirebaseChatCore.instance.sendMessage(
      message,
      widget.room.id,
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MessagesCubit, MessagesInitial>(
        buildWhen: (p, c) => c.roomId == widget.room.id,
        builder: (context, state) {
          if (state.statuses.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          return FireChat(
            isAttachmentUploading: _isAttachmentUploading,
            messages: state.allMessages,
            onAttachmentPressed: _handleAtachmentPressed,
            onMessageTap: _handleMessageTap,
            onPreviewDataFetched: _handlePreviewDataFetched,
            onSendPressed: _handleSendPressed,
            customBottomWidget: !isAdmin ? null : const SizedBox(),
            user: !isAdmin
                ? types.User(
                    id: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
                  )
                : widget.room.users.last,
            theme: DefaultChatTheme(
              backgroundColor: const Color(0xFFEAEAFF),
              inputBackgroundColor: Colors.white,
              inputBorderRadius: BorderRadius.circular(30.0.r),
              inputTextColor: mainColor,
              inputTextDecoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20.0).r,
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(200),
                  gapPadding: 0,
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(200),
                  gapPadding: 0,
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(200),
                  gapPadding: 0,
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(200),
                  gapPadding: 0,
                  borderSide: const BorderSide(color: Colors.grey),
                ),
              ),
              inputContainerDecoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30.0.r),
              ),
              inputPadding: const EdgeInsets.symmetric(vertical: 10.0).h,
            ),
          );
        },
      ),
    );
  }
}

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false, // Prevents dialog dismissal on outside tap
    builder: (BuildContext context) {
      return Dialog(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text("Loading..."),
            ],
          ),
        ),
      );
    },
  );
}

void downloadFile(String url) {
  final anchorElement = html.AnchorElement(href: url);
  anchorElement.download = url;
  anchorElement.click();
}

Future<Uint8List?> fetchImage(String imageUrl) async {
  if (imageUrl.isEmpty) return null;

  final imageFromCash = hiveFilesBox?.get(imageUrl);

  if (imageFromCash != null) {
    return imageFromCash;
  }

  try {
    final response = await http.get(
      Uri.parse(
        'https://api.allorigins.win/raw?url=$imageUrl',
      ),
    );

    if (response.statusCode == 200) {
      hiveFilesBox?.put(imageUrl, response.bodyBytes);

      return response.bodyBytes;
    } else {
      return null;
    }
  } on Exception {
    return null;
  }
}
