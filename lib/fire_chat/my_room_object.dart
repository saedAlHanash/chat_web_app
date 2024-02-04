class MyRoomObject {
  String roomId;
  bool needToSendNotification;
  String fcmToken;

  MyRoomObject({
    this.roomId = "",
    this.fcmToken = "",
    this.needToSendNotification = true,
  });
}

class ChatNotification {
  String body;
  String title;
  String fcm;


  ChatNotification({
    required this.body,
    required this.title,
    required this.fcm,
  });


  Map<String, dynamic> toJson() {
    return {
      "body": body,
      "title": title,
      "fcm": fcm,
    };
  }

  factory ChatNotification.fromMap(Map<String, dynamic> map) {
    return ChatNotification(
      body: map["body"] as String,
      title: map["title"] as String,
      fcm: map["fcm"] as String,
    );
  }

}