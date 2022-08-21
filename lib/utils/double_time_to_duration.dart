Duration serviceTimeToDuration(double time) {
  final List<int> l =
      time.toStringAsFixed(2).split('.').map((e) => int.parse(e)).toList();
  if (l.length > 1 && l[1] != 0) {
    return Duration(
      hours: l[0],
      minutes: (.6 * l[1]).toInt(),
    );
  } else {
    return Duration(hours: time.toInt());
  }
}
