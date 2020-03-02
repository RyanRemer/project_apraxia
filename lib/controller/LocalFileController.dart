import 'dart:io';
import 'package:path_provider/path_provider.dart';

/// A controller for saving and loading from local files on either android or iOS devices
/// 
class LocalFileController {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  /// transforms a non-localized [uri] to a localized [uri] 
  Future<String> getLocalRef(String uri) async {
    String localPath = await _localPath;
    return localPath + "/" + uri;
  }

  File getFile(String localRef){
    return File(localRef);
  }

  void createFile(String localRef){
    File(localRef).createSync(recursive: true);
  }
}
