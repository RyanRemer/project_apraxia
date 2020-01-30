import 'package:intl/intl.dart';

class WaiverFormFields {
  String researchSubjectName;
  String researchSubjectEmail;
  String researchSubjectSignatureFile;
  String researchSubjectDate;
  String representativeName;
  String representativeRelationship;
  String representativeSignatureFile;
  String representativeDate;

  String getToday() {
    var now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd');
    return formatter.format(now);
  }

  WaiverFormFields() {
    researchSubjectName = "";
    researchSubjectEmail = "";
    researchSubjectSignatureFile = "";
    researchSubjectDate = getToday();
    representativeName = "";
    representativeRelationship = "";
    representativeSignatureFile = "";
    representativeDate = getToday();
  }

  WaiverFormFields.test() {
    researchSubjectName = "John Smith";
    researchSubjectEmail = "drakebwade@gmail.com";
    researchSubjectSignatureFile = "/Users/drake_wade/Library/Developer/CoreSimulator/Devices/E16D4309-1732-46EC-8872-818B2A284134/data/Containers/Data/Application/423ECC33-AB8D-498F-8B14-0EDDC0605965/Documents/signature.png";
    researchSubjectDate = getToday();
    representativeName = "";
    representativeRelationship = "";
    representativeSignatureFile = "";
    representativeDate = getToday();
  }
}