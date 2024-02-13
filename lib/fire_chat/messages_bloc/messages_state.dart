part of 'messages_cubit.dart';

class MessagesInitial {
  final CubitStatuses statuses;
  final List<types.Message> allMessages;
  final String roomId;
  final types.Room room;
  final int oldLength;
  final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? stream;

  const MessagesInitial({
    required this.statuses,
    required this.allMessages,
    required this.roomId,
    required this.room,
    required this.oldLength,
    this.stream,
  });

  factory MessagesInitial.initial() {

    loggerObject.w(boxes.messageBox?.length);
    return MessagesInitial(
      allMessages: [],
      roomId: '',
      room: const types.Room(id: '0', type: RoomType.direct, users: []),
      oldLength: boxes.messageBox?.length ?? 0,
      statuses: CubitStatuses.init,
    );
  }

  MessagesInitial copyWith({
    CubitStatuses? statuses,
    List<types.Message>? allMessages,
    String? roomId,
    types.Room? room,
    int? oldLength,
    StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? stream,
  }) {
    return MessagesInitial(
        statuses: statuses ?? this.statuses,
        allMessages: allMessages ?? this.allMessages,
        roomId: roomId ?? this.roomId,
        room: room ?? this.room,
        oldLength: oldLength ?? this.oldLength,
        stream: stream ?? this.stream);
  }
}
