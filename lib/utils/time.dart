class UnixTime {
  final int sinceEpoch;

  UnixTime(dynamic unix) : sinceEpoch = (unix as int) * 1000;
  DateTime get date => DateTime.fromMillisecondsSinceEpoch(this.sinceEpoch);
  Duration get passedSince => DateTime.now().toUtc().difference(this.date);

  @override
  String toString() {
    return '${date.day}/${date.month}/${date.year}';
  }

  String passedSinceStr() {
    final Duration since = this.passedSince;

    final int year = since.inDays ~/ 365;
    if (year > 0) {
      return '$year years ago';
    }

    final int month = since.inDays ~/ 30;
    if (month > 0) {
      return '$month months ago';
    }

    final int week = since.inDays ~/ 7;
    if (week > 0) {
      return '$week weeks ago';
    }

    if (since.inDays > 0) {
      return '${since.inDays} days ago';
    }

    if (since.inHours > 0) {
      return '${since.inHours} hours ago';
    }

    if (since.inMinutes > 0) {
      return '${since.inMinutes} minutes ago';
    }

    if (since.inSeconds > 0) {
      return '${since.inSeconds} seconds ago';
    }

    return 'Less than a second ago';
  }
}
