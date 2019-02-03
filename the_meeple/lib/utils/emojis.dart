class Emojis {
  static List<String> _emojis = List();
  static int _start1 = 0x1F600;

  static List<String> get list {
    if (_emojis.isEmpty) {
      _emojis.addAll(List<int>.generate(56, (index) => index + _start1).map((intValue) => String.fromCharCode(intValue)));
    }
    return _emojis;
  }
}