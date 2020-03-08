import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:project_apraxia/controller/Auth.dart';
import 'package:project_apraxia/model/Attempt.dart';


class HttpConnector {
  static HttpConnector _instance = HttpConnector._();
  static String serverURL = "https://52.41.34.29:8080";
//  static String serverURL = "https://localhost:8080";
  static Auth auth = new Auth.instance();
  IOClient client;

  HttpConnector._() {
    HttpClient baseClient = new HttpClient()..badCertificateCallback = ((X509Certificate cert, String host, int port) => true);
    client = new IOClient(baseClient);
  }

  factory HttpConnector.instance() {
    return _instance;
  }

  Future<String> createEvaluation(String age, String gender, String impression) async {
    Uri uri = Uri.parse(serverURL + "/evaluation");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    request.fields.addEntries([
      MapEntry<String, String>('age', age),
      MapEntry<String, String>('gender', gender),
      MapEntry<String, String>('impression', impression),
    ]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return body['evaluationId'];
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<void> setAmbiance(String ambienceFileName, String evalId) async {
    if (ambienceFileName.startsWith('file://')) {
      ambienceFileName = ambienceFileName.substring(6);
    }
    File ambienceFile = File(ambienceFileName);
    Uri uri = Uri.parse(serverURL + "/evaluation/" + evalId + "/ambiance");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('recording', ambienceFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<Attempt> addAttempt(String recordingFileName, String word, int syllableCount, String evaluationId) async {
    if (recordingFileName.startsWith('file://')) {
      recordingFileName = recordingFileName.substring(6);
    }
    File recordingFile = File(recordingFileName);
    Uri uri = Uri.parse(serverURL + "/evaluation/" + evaluationId + '/attempt');
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('recording', recordingFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    request.fields.addEntries([MapEntry<String, String>('syllableCount', syllableCount.toString()), MapEntry<String, String>('word', word)]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        Attempt attempt = Attempt(body['attemptId'], body['wsd']);
        return attempt;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<void> sendSubjectWaiver(String signatureFileName, String subjectName, String subjectEmail, String subjectDate) async {
    if (signatureFileName.startsWith('file://')) {
      signatureFileName = signatureFileName.substring(6);
    }
    File signatureFile = File(signatureFileName);
    Uri uri = Uri.parse(serverURL + "/waiver/subject");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('researchSubjectSignature', signatureFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    request.fields.addEntries([
      MapEntry<String, String>('researchSubjectName', subjectName),
      MapEntry<String, String>('researchSubjectEmail', subjectEmail),
      MapEntry<String, String>('researchSubjectDate', subjectDate),
      MapEntry<String, String>('clinicianEmail', auth.userEmail),
    ]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<void> sendRepresentativeWaiver(String signatureFileName, String subjectName, String subjectEmail, String repName, String repRelationship, String repDate) async {
    if (signatureFileName.startsWith('file://')) {
      signatureFileName = signatureFileName.substring(6);
    }
    File signatureFile = File(signatureFileName);
    Uri uri = Uri.parse(serverURL + "/waiver/representative");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath('representativeSignature', signatureFile.path, contentType: new MediaType('application', 'x-tar')));
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    request.fields.addEntries([
      MapEntry<String, String>('researchSubjectName', subjectName),
      MapEntry<String, String>('researchSubjectEmail', subjectEmail),
      MapEntry<String, String>('representativeName', repName),
      MapEntry<String, String>('representativeRelationship', repRelationship),
      MapEntry<String, String>('representativeDate', repDate),
      MapEntry<String, String>('clinicianEmail', auth.userEmail),
    ]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<Map<String, String>> getWaiverOnFile(String subjectEmail, String subjectName) async {
    Uri uri = Uri.parse(serverURL + "/waiver/" + subjectEmail + "/" + subjectName);
    http.BaseRequest request = new http.Request('GET', uri);
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        dynamic rawWaiver = body['waiver'];
        Map<String, String> output = new Map<String, String>();
        if (rawWaiver != null) {
          output['date'] = rawWaiver['date'];
          output['subjectName'] = rawWaiver['subjectName'];
          output['subjectEmail'] = rawWaiver['subjectEmail'];
          output['waiverId'] = rawWaiver['waiverId'];
        }
        return output;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<bool> invalidateWaiver(String waiverId) async {
    Uri uri = Uri.parse(serverURL + "/waiver/invalidate/" + waiverId);
    http.BaseRequest request = new http.Request('PUT', uri);
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return true;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<void> updateAttempt(String evalId, String attemptId, bool active) async {
    Uri uri = Uri.parse(serverURL + "/evaluation/" + evalId + "/attempt/" + attemptId);
    http.MultipartRequest request = new http.MultipartRequest('PUT', uri);
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    request.fields.addEntries([
      MapEntry<String, String>('active', active.toString()),
    ]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<void> sendReport(String email, String name, String evalId) async {
    Uri uri = Uri.parse(serverURL + "/sendReport");
    http.MultipartRequest request = new http.MultipartRequest('POST', uri);
    request.headers.addEntries([MapEntry('TOKEN', await auth.getJWT())]);
    request.fields.addEntries([
      MapEntry<String, String>('evalId', evalId),
      MapEntry<String, String>('name', name),
      MapEntry<String, String>('email', email),
    ]);
    try {
      http.StreamedResponse response = await client.send(request);
      String responseBody = await response.stream.bytesToString();
      Map body = jsonDecode(responseBody);
      if (response.statusCode == 200) {
        return;
      }
      String errorMessage = body['errorMessage'];
      if (errorMessage != null) {
        throw new InternalServerException(message: errorMessage);
      }
      throw new InternalServerException();
    } catch (error) {
      if (error is InternalServerException) {
        throw error;
      }
      throw new ServerConnectionException();
    }
  }

  Future<bool> serverConnected() async {
    try {
      http.Response response = await client.get(serverURL + '/healthcheck');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (error) {
      return false;
    }
  }
}


class InternalServerException implements Exception {
  String message;

  InternalServerException({String message}) {
    if (message != null) {
      this.message = "Exception: " + message;
    }
    else {
      this.message = "Exception: Internal server error.";
    }
  }

  @override
  String toString() {
    return this.message;
  }
}


class ServerConnectionException implements Exception {
  final String message = "Error connecting to the server.";
}

