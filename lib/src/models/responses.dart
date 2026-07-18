import 'notification.dart';

class GetNotificationsResponse {
  final int total;
  final int totalIsRead;
  final int totalUnread;
  final List<ChannelGroup> data;

  const GetNotificationsResponse({
    required this.total,
    required this.totalIsRead,
    required this.totalUnread,
    required this.data,
  });

  factory GetNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return GetNotificationsResponse(
      total: json['total'] as int,
      totalIsRead: json['total_is_read'] as int,
      totalUnread: json['total_unread'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => ChannelGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ChannelGroup {
  final String channel;
  final int total;
  final int totalIsRead;
  final int totalUnread;
  final List<DateGroup> data;

  const ChannelGroup({
    required this.channel,
    required this.total,
    required this.totalIsRead,
    required this.totalUnread,
    required this.data,
  });

  factory ChannelGroup.fromJson(Map<String, dynamic> json) {
    return ChannelGroup(
      channel: json['channel'] as String,
      total: json['total'] as int,
      totalIsRead: json['total_is_read'] as int,
      totalUnread: json['total_unread'] as int,
      data: (json['data'] as List<dynamic>)
          .map((e) => DateGroup.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DateGroup {
  final String label;
  final List<RWSPayload> notifications;

  const DateGroup({
    required this.label,
    required this.notifications,
  });

  factory DateGroup.fromJson(Map<String, dynamic> json) {
    return DateGroup(
      label: json['label'] as String,
      notifications: (json['notif'] as List<dynamic>)
          .map((e) =>
              RWSPayload.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class ApiResponse {
  final String status;
  final int code;
  final String message;
  final dynamic data;

  const ApiResponse({
    required this.status,
    required this.code,
    required this.message,
    this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] as String,
      code: json['code'] as int,
      message: json['message'] as String,
      data: json['data'],
    );
  }

  bool get isSuccess => status == 'success';
}
