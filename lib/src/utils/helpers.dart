import 'dart:math';

String generatePrivateRoom() {
  final now = DateTime.now().millisecondsSinceEpoch;
  final random = Random().nextInt(999999999);
  return 'sdk-$now-$random';
}

Future<void> sleep(Duration duration) =>
    Future.delayed(duration);

String buildRoomName(
  String destination,
  String channel, [
  String? userUniqueCode,
]) {
  return userUniqueCode != null
      ? '$destination:$channel:$userUniqueCode'
      : '$destination:$channel';
}
