class Prompt {
  String word;
  int syllableCount;
  String soundUri;

  Prompt({this.word, this.syllableCount, this.soundUri});

  Map<String, dynamic> toMap(){
    return {
      "word" : this.word,
      "syllableCount" : this.syllableCount,
      "soundUri" : this.soundUri
    };
  }

  Prompt.fromMap(Map<String, dynamic> map){
    this.word = map["word"];
    this.syllableCount = map["syllableCount"];
    this.soundUri = map["soundUri"];
  }

}