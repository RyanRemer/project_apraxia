class Evaluation {
  String id;
  String age;
  String gender;
  String impression;
  String dateCreated;

  Evaluation.fromMap(Map<String, dynamic> map) {
    this.id = map["evaluationId"];
    this.age = map["age"];
    this.gender = map["gender"];
    this.impression = map["impression"];
    this.dateCreated = map["dateCreated"];
  }
}
