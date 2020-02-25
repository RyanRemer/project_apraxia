class Attempt {
  String _attemptId;
  double _wsd;

  Attempt(this._attemptId, this._wsd);

  // ignore: unnecessary_getters_setters
  double get wsd => _wsd;

  // ignore: unnecessary_getters_setters
  set wsd(double value) {
    _wsd = value;
  }

  // ignore: unnecessary_getters_setters
  String get attemptId => _attemptId;

  // ignore: unnecessary_getters_setters
  set attemptId(String value) {
    _attemptId = value;
  }
}