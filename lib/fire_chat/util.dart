import 'dart:async';

import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:hive_flutter/adapters.dart';

import '../go_route_pages.dart';
import 'get_chats_rooms_bloc/get_rooms_cubit.dart';
import 'my_room_object.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const String baseUrl = 'https://manage.almas.education/api';
const String baseImageUrl = 'https://manage.almas.education/public/storage/';

extension TypesRoom on types.Room {
  bool get isNotReed {
    if (createdAt == updatedAt) return false;
    final result = (updatedAt ?? 0) - (latestUpdateMessagesBox.get(id) ?? 0);
    // loggerObject.w('$id $updatedAt - ${(latestUpdateMessagesBox.get(id))} = $result');
    return result > 2000;
  }
}

enum CubitStatuses { init, loading, done, error }

late Box<String> roomsBox;
late Box usersBox;
late Box<String> roomMessage;
late Box<int> latestUpdateMessagesBox;

Future<void> initialBoxes() async {
  roomsBox = await Hive.openBox('rooms');
  latestUpdateMessagesBox = await Hive.openBox('messages');
  usersBox = await Hive.openBox('users');
}

User? get firebaseUser {
  final user = FirebaseChatCore.instance.firebaseUser;
  if (user == null) _initial();
  return user;
}

Future<User?> get firebaseUserAsync async {
  final user = FirebaseChatCore.instance.firebaseUser;

  if (user == null) {
    await _initial();
    return firebaseUser;
  }

  return user;
}

Future<List<types.User>> getChatUsers() async {
  final users = await FirebaseFirestore.instance.collection('users').get();

  final listUsers = users.docs.map((doc) {
    final data = doc.data();

    data['createdAt'] = data['createdAt']?.millisecondsSinceEpoch;
    data['id'] = doc.id;
    data['lastSeen'] = data['lastSeen']?.millisecondsSinceEpoch;
    data['updatedAt'] = data['updatedAt']?.millisecondsSinceEpoch;

    return types.User.fromJson(data);
  }).toList();

  return listUsers;
}

types.User getChatMember(List<types.User> list, {bool? me}) {
  for (var e in list) {
    if (me ?? false) {
      if (e.id == firebaseUser?.uid) {
        return e;
      }
    } else if (e.id != firebaseUser?.uid) {
      return e;
    }
  }
  throw Exception('user not found');
}

Future<bool> isChatUserFound(String id) async {
  for (var e in await getChatUsers()) {
    if (e.firstName == id) return true;
  }
  return false;
}

Future<void> createChatUser(String id, String? name, String? photo) async {
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'LMS.$id@LMS.com',
      password: 'LMS${id}LMS',
    );

    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: id,
        id: credential.user!.uid,
        imageUrl:
            '${(photo?.contains('http://') ?? true) ? '' : baseImageUrl}${photo ?? ''}',
        lastName: name ?? DateTime.now().toString(),
      ),
    );
  } on Exception catch (e) {
    if (e.toString().contains('email address is already')) {
      await loginChatUser(id, name, photo);
    }
  }
}

Future<void> loginChatUser(String id, String? name, String? photo) async {
  var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'LMS.$id@LMS.com',
    password: 'LMS${id}LMS',
  );

  await FirebaseChatCore.instance.createUserInFirestore(
    types.User(
      firstName: id,
      id: credential.user!.uid,
      imageUrl:
          '${(photo?.contains('http://') ?? true) ? '' : baseImageUrl}${photo ?? ''}',
      lastName: name ?? DateTime.now().toString(),
    ),
  );
}

Future<void> logoutChatUser() async {
  loggerObject.w('logout');
  await roomsBox.clear();
  await FirebaseAuth.instance.signOut();
}

Future<void> initFirebaseChat() async {
  try {
    if (await isChatUserFound(userIdFromUrl)) {
      await loginChatUser(userIdFromUrl, userNameFromUrl, userPhotoFromUrl);
      return;
    } else {
      await createChatUser(userIdFromUrl, userNameFromUrl, userPhotoFromUrl);
    }
  } on Exception catch (e) {
    print(e);
  }
  return;
}

Future<bool> sendNotificationMessage(
    MyRoomObject myRoomObject, ChatNotification message) async {
  if (myRoomObject.fcmToken.isEmpty) return false;

  if (message.body.length > 100) {
    message.body = message.body.substring(0, 99);
  }
  return true;
  // final result = await APIService().postApi(
  //   url: 'mobile/api/send-notification',
  //   body: {"token": myRoomObject.fcmToken, "message": message.body},
  // );
  // return result.statusCode == 200;
}

var loading = false;

Future<void> _initial() async {
  if (loading) return;
  loading = true;

  if (FirebaseChatCore.instance.firebaseUser != null) return;

  await initFirebaseChat();
  loading = false;
}
