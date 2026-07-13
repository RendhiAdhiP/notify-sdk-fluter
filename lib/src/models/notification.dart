class NotificationPayload {
  final String id;
  final String ownerId;
  final String room;
  final String title;
  final String message;
  final String link;
  final String? userUniqueCode;
  final String? type;
  final NotificationMeta meta;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  const NotificationPayload({
    required this.id,
    required this.ownerId,
    required this.room,
    required this.title,
    required this.message,
    required this.link,
    this.userUniqueCode,
    this.type,
    required this.meta,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationPayload.fromJson(Map<String, dynamic> json) {
    return NotificationPayload(
      id: json['_id'] as String,
      ownerId: json['ownerId'] as String,
      room: json['room'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      link: json['link'] as String,
      userUniqueCode: json['userUniqueCode'] as String?,
      type: json['type'] as String?,
      meta: NotificationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      isRead: json['isRead'] as bool,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'ownerId': ownerId,
    'room': room,
    'title': title,
    'message': message,
    'link': link,
    'userUniqueCode': userUniqueCode,
    'type': type,
    'meta': meta.toJson(),
    'isRead': isRead,
    'createdAt': createdAt,
    'updatedAt': updatedAt,
  };
}

class NotificationMeta {
  final String destination;
  final String channel;
  final String? origin;

  const NotificationMeta({
    required this.destination,
    required this.channel,
    this.origin,
  });

  factory NotificationMeta.fromJson(Map<String, dynamic> json) {
    return NotificationMeta(
      destination: json['destination'] as String,
      channel: json['channel'] as String,
      origin: json['origin'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'destination': destination,
    'channel': channel,
    'origin': origin,
  };
}
