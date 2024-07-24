String formatTimeDifference(String postTime) {
  final postDateTime = DateTime.parse(postTime);
  final currentTime = DateTime.now();
  final difference = currentTime.difference(postDateTime);

  if (difference.inDays > 0) {
    return '${difference.inDays} ${difference.inDays == 1 ? 'Day' : 'Days'}';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} ${difference.inHours == 1 ? 'Hour' : 'Hours'}';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'Minute' : 'Minutes'}';
  } else {
    return 'Just now';
  }
}
