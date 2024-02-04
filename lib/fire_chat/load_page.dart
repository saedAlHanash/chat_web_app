import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/fire_chat/util.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_multi_type/image_multi_type.dart';

import '../go_route_pages.dart';

class LoadData extends StatefulWidget {
  const LoadData({super.key, required this.userChanged});

  final bool userChanged;

  @override
  State<LoadData> createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  @override
  void initState() {
    if (widget.userChanged) {
      doActions();
    } else {
      Future.delayed(
        const Duration(seconds: 1),
        () {
          context.pushReplacementNamed(GoRouteName.messages);
        },
      );
    }
    super.initState();
  }

  Future<void> doActions() async {
    await logoutChatUser();
    await initFirebaseChat();
    if (mounted) {
      await initFirebaseChatAfterLogin(context);
    }
    if (mounted) {
      context.pushReplacementNamed(GoRouteName.messages);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ImageMultiType(url: Icons.chat),
            SizedBox(height: 30.0),
            DrawableText(text: 'يرجى الانتظار')
          ],
        ),
      ),
    );
  }
}
