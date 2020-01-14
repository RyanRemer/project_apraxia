import 'dart:io';
import 'package:http/io_client.dart';
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


  Future getRequest(path, headers) async {
    return await ioClient.get(serverURL + path, headers: headers);
  }

  Future postRequest(path, body, headers) async {
    return await ioClient.post(serverURL + path, body: utf8.encode(json.encode(body)), headers: headers);
  }
}


void main() async {
  HttpConnector connector = new HttpConnector();
  var response = await connector.getRequest('/evaluation/1234', null);
  print(response);
}
