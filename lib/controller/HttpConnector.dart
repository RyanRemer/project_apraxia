import 'dart:io';

class HttpConnector {
  HttpClient client = new HttpClient();

  Future getRequest(String url) async {
    client.getUrl(Uri.parse("https://" + url))
      .then((HttpClientRequest request) {
        // Optionally set up headers...
        // Optionally write to the request object...
        // Then call close.

      })
      .then((HttpClientResponse response) {
        // Process the response.
        return response.statusCode;
      });

  }

  Future postRequest(String url, Object data) async {
//    var response = await client.postUrl(Uri.parse("https://" + url));
//    return response.statusCode;
    client.postUrl(Uri.parse("https://" + url))
      .then((HttpClientRequest request) {

      })
      .then((HttpClientResponse response) {
        return response.statusCode;
      });
  }



}