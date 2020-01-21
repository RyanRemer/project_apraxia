import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/interface/IWSDCalculator.dart';
import 'package:project_apraxia/model/Attempt.dart';


class HttpConnector extends IWSDCalculator {
  String serverURL = "https://44.229.253.49:8080";
  Auth auth = new Auth.instance();
  IOClient client;

  HttpConnector() {
    HttpClient baseClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    client = new IOClient(baseClient);
  }

  Future<String> setAmbiance(String ambienceFileName) async {
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

  Future post(String path, body, headers) async {
    return await client.post(serverURL + path, body: utf8.encode(json.encode(body)), headers: headers);
  }

  Future get(String path, headers) async {
    return await client.get(serverURL + path, headers: headers);
  }

  Future sendRequest(http.BaseRequest request) async {
    return await client.send(request);
  }
}


void main() async {
  HttpConnector connector = new HttpConnector();
  String path1 = "/Users/drake_wade/OneDrive - BYU Office 365/Winter 2020/CS 495/Project/project_apraxia/assets/prompts/ConstitutionPrompt.wav";
  String path2 = "/Users/drake_wade/OneDrive - BYU Office 365/Winter 2020/CS 495/Project/project_apraxia/assets/prompts/FlatteringPrompt.wav";
  String evalID = await connector.setAmbiance(path1);

  var result = await connector.addAttempt(path2, "gingerbread", 3, evalID);
  print(result);
}


//EV-f387a73b-20b0-44d3-a3ce-e7d748c43891