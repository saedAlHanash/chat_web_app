import 'package:chat_web_app/fire_chat/util.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'app_widget.dart';
import 'fire_chat/my_students/bloc/chat_users_cubit/chat_users_cubit.dart';
import 'firebase_options.dart';

Box<dynamic>? hiveFilesBox;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance().then((value) {
    AppSharedPreference.init(value);
  });

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await Hive.initFlutter();

  await initialBoxes();

  setPathUrlStrategy();

  hiveFilesBox = await Hive.openBox('image_box');

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => ChatUsersCubit()),
    ],
    child: MyApp(),
  ));
}
