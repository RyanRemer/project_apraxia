import 'package:intl/intl.dart';

class WaiverFormFields {
  String researchSubjectName;
  String researchSubjectEmail;
  bool hasRepresentative;
  String researchSubjectSignatureFile;
  DateTime researchSubjectDate;
  String representativeName;
  String representativeRelationship;
  String representativeSignatureFile;
  DateTime representativeDate;

  String getFormattedSubjectDate() {
    DateFormat formatter = new DateFormat("MMMM dd, yyyy");
    return formatter.format(researchSubjectDate);
  }

  String getFormattedRepresentativeDate() {
    DateFormat formatter = new DateFormat("MMMM dd, yyyy");
    return formatter.format(representativeDate);
  }

  WaiverFormFields() {
    hasRepresentative = false;
    researchSubjectDate = new DateTime.now();
    representativeDate = new DateTime.now();
  }

  WaiverFormFields.test() {
    researchSubjectName = "John Smith";
    researchSubjectEmail = "drakebwade@gmail.com";
    researchSubjectSignatureFile = "/Users/drake_wade/Library/Developer/CoreSimulator/Devices/E16D4309-1732-46EC-8872-818B2A284134/data/Containers/Data/Application/423ECC33-AB8D-498F-8B14-0EDDC0605965/Documents/signature.png";
    researchSubjectDate = new DateTime.now();
    representativeDate = new DateTime.now();
  }
}