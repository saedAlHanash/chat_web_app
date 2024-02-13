// import 'package:audioplayers/audioplayers.dart';
import 'package:drawable_text/drawable_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_multi_type/image_multi_type.dart';

import 'api_manager/api_service.dart';

import 'fire_chat/my_students/bloc/chat_users_cubit/chat_users_cubit.dart';
import 'fire_chat/messages_bloc/messages_cubit.dart';
import 'fire_chat/rooms_bloc/rooms_cubit.dart';
import 'generated/assets.dart';
import 'go_route_pages.dart';
import 'main.dart';

const mainColor = Color(0xff3D5CFF);

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // designSize: const Size(360, 800),
      designSize: const Size(1440, 972),
      minTextAdapt: true,
      builder: (context, child) {
        DrawableText.initial(
          headerSizeText: 28.0.sp,
          initialHeightText: 1.5.sp,
          titleSizeText: 20.0.sp,
          initialSize: 18.0.sp,
          selectable: false,
          initialColor: Colors.black,
        );
        return FutureBuilder(
            future: boxes.initialBoxes(),
            builder: (context, sh) {
              if (!sh.hasData) {
                return 0.0.verticalSpace;
              }
              return MaterialApp.router(
                scrollBehavior: MyCustomScrollBehavior(),
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  colorScheme: ColorScheme.fromSeed(seedColor: mainColor),
                  useMaterial3: true,
                ),
                builder: (context, child) {
                  setImageMultiTypeErrorImage(
                      const ImageMultiType(url: Assets.imagesLogo));
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
                      BlocProvider(create: (_) => RoomsCubit()..getChatRooms()),
                      BlocProvider(create: (_) => ChatUsersCubit()..getChatUsers(_)),
                      BlocProvider(create: (_) => MessagesCubit()),
                    ],
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: child!,
                    ),
                  );
                },
                routerConfig: appGoRouter,
              );
            });
      },
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
