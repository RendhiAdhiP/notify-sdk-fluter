class RWSPayload {
  final String id;
  final String ownerId;
  final String room;
  final String title;
  final String message;
  final String link;
  final String? userUniqueCode;
  final String? type;
  final RWSNotificationMeta meta;
  final bool isRead;
  final String createdAt;
  final String updatedAt;

  const RWSPayload({
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

  factory RWSPayload.fromJson(Map<String, dynamic> json) {
    return RWSPayload(
      id: json['_id'] as String,
      ownerId: json['owner_id'] as String,
      room: json['room'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      link: json['link'] as String,
      userUniqueCode: json['user_unique_code'] as String?,
      type: json['type'] as String?,
      meta: RWSNotificationMeta.fromJson(json['meta'] as Map<String, dynamic>),
      isRead: json['is_read'] as bool,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    '_id': id,
    'owner_id': ownerId,
    'room': room,
    'title': title,
    'message': message,
    'link': link,
    'user_unique_code': userUniqueCode,
    'type': type,
    'meta': meta.toJson(),
    'is_read': isRead,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}

class RWSNotificationMeta {
  final String destination;
  final String channel;
  final String? origin;

  const RWSNotificationMeta({
    required this.destination,
    required this.channel,
    this.origin,
  });

  factory RWSNotificationMeta.fromJson(Map<String, dynamic> json) {
    return RWSNotificationMeta(
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
