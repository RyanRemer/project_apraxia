import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';

import 'package:project_apraxia/controller/Auth.dart';


class HttpConnector {
  String serverURL = "https://44.229.253.49:8080";
  Auth auth = new Auth.instance();
  HttpClient client;
  IOClient ioClient;

  HttpConnector() {
    client = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    ioClient = new IOClient(client);
  }

//  setAmbience(recording as file name) -> evaluationId: string (for native modules return fake evaluationId)
  Future<String> setAmbience(String ambienceFileName) async {
    File ambienceFile = File(ambienceFileName);
    Uri uri = Uri.parse(serverURL + "/evaluation");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('recording', ambienceFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    http.StreamedResponse response = await ioClient.send(request);
    String responseBody = await response.stream.bytesToString();
    Map body = jsonDecode(responseBody);
    return body['evaluationId'];
  }

//  addAttempt(recording as file name, word (e.g. “gingerbread”), syllableCount, evaluationId) -> attemptId: string, wsd: double (?)
  Future<Map> addAttempt(String recordingFileName, String word, int syllableCount, String evaluationId) async {
    File recordingFile = File(recordingFileName);
    Uri uri = Uri.parse(serverURL + "/evaluation/" + evaluationId + '/attempt?word=' + word + '&syllableCount=' + syllableCount.toString());
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('recording', recordingFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
//    request.fields.addEntries([MapEntry<String, String>('syllableCount', syllableCount.toString()), MapEntry<String, String>('word', word)]);
    http.StreamedResponse response = await ioClient.send(request);
    String responseBody = await response.stream.bytesToString();
    Map body = jsonDecode(responseBody);
    return body;
  }

//  getReport(id) -> wsd’s: map<word:double>
  Future<Map> getReport(String id) async {

  }


  Future post(String path, body, headers) async {
    return await ioClient.post(serverURL + path, body: utf8.encode(json.encode(body)), headers: headers);
  }

  Future get(String path, headers) async {
    return await ioClient.get(serverURL + path, headers: headers);
  }

  Future sendRequest(http.BaseRequest request) async {
    return await ioClient.send(request);
  }
}


void main() async {
  HttpConnector connector = new HttpConnector();
  String path1 = "/Users/drake_wade/OneDrive - BYU Office 365/Winter 2020/CS 495/Project/project_apraxia/assets/prompts/zippering.wav";
  String evalID = await connector.setAmbience(path1);
  var result = await connector.addAttempt("/Users/drake_wade/OneDrive - BYU Office 365/Winter 2020/CS 495/Project/project_apraxia/assets/prompts/gingerbread.wav", "gingerbread", 3, evalID);
  print(result);
}


//EV-f387a73b-20b0-44d3-a3ce-e7d748c43891