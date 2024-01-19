// import 'package:audioplayers/audioplayers.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'fire_chat/get_chats_rooms_bloc/get_rooms_cubit.dart';
import 'fire_chat/my_students/bloc/chat_users_cubit/chat_users_cubit.dart';
import 'go_route_pages.dart';

const mainColor=Color(0xff3D5CFF);
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {


  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      scrollBehavior: MyCustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
        useMaterial3: true,
      ),
      builder: (context, child) {
        DrawableText.initial(
          initialColor: Colors.black,
          titleSizeText: 28.0,
          headerSizeText: 30.0,
          initialSize: 22.0,
          initialHeightText: 2.0,
          selectable: true,
          renderHtml: true,
          // textDirection: TextDirection.ltr,
        );
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => GetRoomsCubit()..getChatRooms()),
            BlocProvider(create: (_) => ChatUsersCubit()..getChatUsers()),
          ],
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: child!,
          ),
        );
      },
      routerConfig: appGoRouter,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
