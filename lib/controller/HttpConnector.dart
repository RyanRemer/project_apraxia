import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';


class HttpConnector extends IWSDCalculator {
  String serverURL = "https://52.41.34.29:8080";
  Auth auth = new Auth.instance();
  IOClient client;

  HttpConnector() {
    HttpClient baseClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    client = new IOClient(baseClient);
  }

  Future<String> setAmbiance(String ambienceFileName) async {
    if (ambienceFileName.startsWith('file://')) {
      ambienceFileName = ambienceFileName.substring(6);
    }
    File ambienceFile = File(ambienceFileName);
    Uri uri = Uri.parse(serverURL + "/evaluation");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('recording', ambienceFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    http.StreamedResponse response = await client.send(request);
    String responseBody = await response.stream.bytesToString();
    Map body = jsonDecode(responseBody);
    return body['evaluationId'];
  }

  Future<Attempt> addAttempt(String recordingFileName, String word, int syllableCount, String evaluationId) async {
    if (recordingFileName.startsWith('file://')) {
      recordingFileName = recordingFileName.substring(6);
    }
    File recordingFile = File(recordingFileName);
    Uri uri = Uri.parse(serverURL + "/evaluation/" + evaluationId + '/attempt?word=' + word + '&syllableCount=' + syllableCount.toString());
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('recording', recordingFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
//    request.fields.addEntries([MapEntry<String, String>('syllableCount', syllableCount.toString()), MapEntry<String, String>('word', word)]);
    http.StreamedResponse response = await client.send(request);
    String responseBody = await response.stream.bytesToString();
    Map body = jsonDecode(responseBody);
    Attempt attempt = Attempt(body['attemptId'], body['wsd']);
    return attempt;
  }

  Future<List<double>> getAmplitudes(String fileName) {
    return null;
  }
}

