import 'dart:async';

import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/api_manager/api_url.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hive_flutter/adapters.dart';

import '../go_route_pages.dart';
import 'get_chats_rooms_bloc/get_rooms_cubit.dart';
import 'my_room_object.dart';

final baseImageUrl = 'https://$baseUrl/public/storage/';

extension TypesRoom on types.Room {
  bool get isNotReed {
    if (createdAt == updatedAt) return false;
    final result = (updatedAt ?? 0) - (latestUpdateMessagesBox?.get(id) ?? 0);
    // loggerObject.w('$id $updatedAt - ${(latestUpdateMessagesBox.get(id))} = $result');
    return result > 2000;
  }
}

enum CubitStatuses { init, loading, done, error }

Box<String>? roomsBox;
Box? usersBox;
Box<String>? roomMessage;
Box<int>? latestUpdateMessagesBox;

Box<String>? latestMessagesBox;

Future<void> initialBoxes() async {
  roomsBox = await Hive.openBox('rooms');
  latestUpdateMessagesBox = await Hive.openBox('messages');
  usersBox = await Hive.openBox('users');
  latestMessagesBox = await Hive.openBox('latestMessagesBox');
}

Future<void> reInitialBoxes() async {
  await roomsBox?.close();
  await latestUpdateMessagesBox?.close();
  await usersBox?.close();
  await latestMessagesBox?.close();
  await initialBoxes();
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
    if (e.firstName == '${isTestDomain ? 'test' : ''}$id') return true;
  }
  return false;
}

Future<void> createChatUser() async {
  final meta = AppSharedPreference.myMetta;
  try {
    final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: 'LMS${isTestDomain ? 'test' : ''}.${meta.userId}@LMS.com',
      password: 'LMS${meta.userId}LMS',
    );

    await FirebaseChatCore.instance.createUserInFirestore(
      types.User(
        firstName: '${isTestDomain ? 'test' : ''}${meta.userId}',
        id: credential.user!.uid,
        imageUrl: meta.userPhoto.replaceAll(baseImageUrl, ''),
        lastName: meta.userName,
        metadata: {'fcm_web': meta.userFcm},
      ),
    );
  } on Exception catch (e) {
    if (e.toString().contains('email address is already')) {
      await loginChatUser();
    }
  }
}

Future<void> loginChatUser() async {
  final meta = AppSharedPreference.myMetta;
  var credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: 'LMS${isTestDomain ? 'test' : ''}.${meta.userId}@LMS.com',
    password: 'LMS${meta.userId}LMS',
  );

  await FirebaseChatCore.instance.createUserInFirestore(
    types.User(
      firstName: '${isTestDomain ? 'test' : ''}${meta.userId}',
      id: credential.user!.uid,
      imageUrl: meta.userPhoto.replaceAll(baseImageUrl, ''),
      lastName: meta.userName,
      metadata: {'fcm_web': meta.userFcm},
    ),
  );
}

Future<void> logoutChatUser() async {
  if (firebaseUser != null) {
    await FirebaseFirestore.instance.collection('users').doc(firebaseUser?.uid).update(
      {
        'metadata': {'fcm_web': ''}
      },
    );
  }
  loggerObject.w('logout');
  await roomsBox?.clear();
  await reInitialBoxes();
  await FirebaseAuth.instance.signOut();
}

Future<void> initFirebaseChat() async {
  final meta = AppSharedPreference.myMetta;
  try {
    if (await isChatUserFound(meta.userId)) {
      await loginChatUser();
      return;
    } else {
      await createChatUser();
    }
  } on Exception catch (e) {
    loggerObject.e(e);
  }
  return;
}

Future<bool> sendNotificationMessage(
    MyRoomObject myRoomObject, ChatNotification message) async {
  if (myRoomObject.fcmToken.isEmpty && myRoomObject.fcmTokenWeb.isEmpty) return false;

  if (message.body.length > 100) {
    message.body = message.body.substring(0, 99);
  }

  final result = await APIService().uploadMultiPart(
    url: 'api/send',
    fields: message.toJson(),
  );

  return result.statusCode == 200;
}

var loading = false;

Future<void> _initial() async {
  if (loading) return;
  loading = true;

  if (FirebaseChatCore.instance.firebaseUser != null) return;

  await initFirebaseChat();
  loading = false;
}
