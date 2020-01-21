class Attempt {
  String _attemptId;
  double _WSD;

  Attempt(this._attemptId, this._WSD);

  double get WSD => _WSD;

  set WSD(double value) {
    _WSD = value;
  }

  String get attemptId => _attemptId;

  set attemptId(String value) {
    _attemptId = value;
  }
}