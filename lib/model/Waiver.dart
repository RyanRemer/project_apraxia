class Waiver {
  String subjectName;
  String subjectEmail;

  Waiver.fromMap(Map map){
    this.subjectName = map["subjectName"];
    this.subjectEmail = map["subjectEmail"];
  }
}