class Prompt {
  String word;
  int syllableCount;
  String soundUri;
  bool enabled;

  Prompt({this.word, this.syllableCount, this.soundUri, this.enabled = true});

  Prompt.from(Prompt prompt){
    this.word = prompt.word;
    this.syllableCount = prompt.syllableCount;
    this.soundUri = prompt.soundUri;
    this.enabled = prompt.enabled;
  }

  Map<String, dynamic> toMap(){
    return {
      "word" : this.word,
      "syllableCount" : this.syllableCount,
      "soundUri" : this.soundUri,
      "enabled" : this.enabled
    };
  }

  Prompt.fromMap(Map<String, dynamic> map){
    this.word = map["word"];
    this.syllableCount = map["syllableCount"];
    this.soundUri = map["soundUri"];
    this.enabled = map["enabled"] ?? true;
  }

}