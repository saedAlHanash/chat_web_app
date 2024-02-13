import 'dart:async';
import 'dart:convert';

import 'package:chat_web_app/api_manager/api_service.dart';
import 'package:chat_web_app/api_manager/api_url.dart';
import 'package:chat_web_app/util/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:hive_flutter/adapters.dart';

import '../main.dart';
import 'my_room_object.dart';

final baseImageUrl = 'https://$baseUrl/public/storage/';

extension TypesRoom on types.Room {
  bool get isNotReed {
    if (createdAt == updatedAt) return false;
    final json = boxes.latestMessagesBox?.get(id);

    if (json == null) return false;

    final message = types.Message.fromJson(jsonDecode(json));

    final messageUpdatedAt = message.updatedAt;

    final result = (updatedAt ?? 0) - (messageUpdatedAt ?? updatedAt ?? 0);
    loggerObject.w('$id $updatedAt - ${(messageUpdatedAt)} = $result');
    return result > 2000;
  }
}

enum CubitStatuses { init, loading, done, error }

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

  await boxes.roomsBox?.clear();
  boxes.reInitialBoxes();

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

class UtilBoxes {
  Box<String>? roomsBox;

  Box<String>? messageBox;

  Box<String>? latestMessagesBox;

  UtilBoxes();

  Future<bool> initialBoxes() async {
    roomsBox = Hive.isBoxOpen('rooms')
        ? Hive.box<String>('rooms')
        : await Hive.openBox<String>('rooms');

    latestMessagesBox = Hive.isBoxOpen('latestMessagesBox')
        ? Hive.box<String>('latestMessagesBox')
        : await Hive.openBox<String>('latestMessagesBox');

    return true;
  }

  Future<void> reInitialBoxes() async {
    await roomsBox?.close();

    await latestMessagesBox?.close();

    roomsBox = await Hive.openBox('roomsBox');

    latestMessagesBox = await Hive.openBox('latestMessagesBox');
  }
}
